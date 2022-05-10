import 'dart:typed_data';
import 'dart:io' show Platform;

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:dishful/common/data/image.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/picture.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/storage.service.dart';
import 'package:dishful/common/widgets/dishful_loading.widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';

typedef TemporaryPicture = Future<Picture> Function();

Future<TemporaryPicture> createPicture(
  XFile file, {
  required Picture? currentPicture,
}) async {
  final id = AuthService.currentUser.uid;
  final subscription = await DbService.publicDb.subscriptions.get(id);
  if (subscription == null) throw "Failed to fetch subscription with ID: $id";

  final isLocal = !kIsWeb && !subscription.isCurrentlySubscribed;

  final data = await file.readAsBytes();
  final image = bytesToImage(data);
  final resizedImage = normalizeImage(image);

  final blurHash = BlurHash.encode(
    resizedImage,
    numCompX: blurImageComponents(resizedImage).item1,
    numCompY: blurImageComponents(resizedImage).item2,
  );

  final pictureWithoutPath = Picture.create(
    id: currentPicture?.id,
    blurHash: blurHash.hash,
    width: resizedImage.width,
    height: resizedImage.height,
    isLocal: isLocal,
  );

  return pictureWithoutPath.upload(file: file);
}

class DishfulEditablePicture extends ConsumerWidget {
  final StateProvider<TemporaryPicture?> _temporaryPictureProvider =
      StateProvider((_) => null);
  late final StateProvider<Picture?> pictureProvider;
  late final StateProvider<bool> isEditingProvider;
  final StateProvider<bool> isLoadingProvider = StateProvider((_) => false);
  final Future<void> Function(Picture?) onSave;
  final Picture? initialValue;

  DishfulEditablePicture({
    Key? key,
    StateProvider<Picture?>? pictureProvider,
    StateProvider<bool>? isEditingProvider,
    required this.onSave,
    this.initialValue,
  })  : pictureProvider = pictureProvider ?? StateProvider((_) => initialValue),
        isEditingProvider = isEditingProvider ?? StateProvider((_) => true),
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedPicture = ref.watch(pictureProvider);
    final temporaryPicture = ref.watch(_temporaryPictureProvider);
    final isEditing = ref.watch(isEditingProvider);
    final isLoading = ref.watch(isLoadingProvider);

    if (!isEditing) return DishfulPicture(picture: savedPicture);

    final uploadButton = TextButton(
      child: Text("Upload"),
      onPressed: () async {
        final _picker = ImagePicker();
        final file = await _picker.pickImage(source: ImageSource.gallery);
        final newTemporaryPicture = await createPicture(
          file!,
          currentPicture: savedPicture,
        );

        ref.set(_temporaryPictureProvider, newTemporaryPicture);
      },
    );

    final removeButton = TextButton(
      child: Text("Remove"),
      onPressed: () {
        if (temporaryPicture != null) {
          ref.set(_temporaryPictureProvider, null);
          return;
        }
        if (savedPicture != null) {
          ref.set(pictureProvider, null);
          return;
        }
      },
    );

    final saveButton = TextButton(
      child: Text("Save"),
      onPressed: () async {
        ref.set(isLoadingProvider, true);
        final _temporaryPicture = ref.read(_temporaryPictureProvider);
        ref.set(_temporaryPictureProvider, null);

        /// [DishfulEditablePicture] will upload the file to the correct
        /// storage location and delegates the [Picture] storage to the
        /// consumer.
        ///
        /// Different consumers will want to store their [Picture]s in
        /// different locations, whereas they all will use the [StorageService]
        /// to store the associated [XFile]s.
        final newPicture = await _temporaryPicture?.call();
        await onSave(newPicture);

        ref.set(pictureProvider, newPicture);
        ref.set(isLoadingProvider, false);
        ref.set(isEditingProvider, false);
      },
    );

    final cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        ref.set(_temporaryPictureProvider, null);
        ref.set(isEditingProvider, false);
      },
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        if (savedPicture != null && temporaryPicture == null)
          DishfulBlurHash(
            blurHash: savedPicture.blurHash,
            width: savedPicture.width,
            height: savedPicture.height,
          ),
        if (isLoading)
          DishfulLoading()
        else
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              uploadButton,
              if (temporaryPicture != null || savedPicture != null)
                removeButton,
              if (temporaryPicture != null) saveButton,
              if (temporaryPicture != null) cancelButton,
            ],
          )
      ],
    );
  }
}

class DishfulPicture extends StatelessWidget {
  final Picture? picture;

  const DishfulPicture({Key? key, required this.picture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (picture?.path == null) return Text("No image.");

    return OctoImage.fromSet(
      image: picture!.isLocal
          ? XFileImage(XFile(picture!.path!)) as ImageProvider
          : CachedNetworkImageProvider(picture!.path!),
      octoSet: OctoSet.blurHash(picture!.blurHash),
      width: picture!.width.toDouble(),
      height: picture!.height.toDouble(),
    );
  }
}

class DishfulBlurHash extends StatelessWidget {
  final String blurHash;
  final int width;
  final int height;

  const DishfulBlurHash({
    Key? key,
    required this.blurHash,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = imageToBytes(
      BlurHash.decode(blurHash).toImage(width, height),
    );
    return FittedBox(
      fit: BoxFit.fill,
      child: Image.memory(
        bytes,
        width: width.toDouble(),
        height: height.toDouble(),
      ),
    );
  }
}
