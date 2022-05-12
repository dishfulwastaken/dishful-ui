import 'dart:typed_data';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:dishful/common/data/image.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/picture.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/widgets/dishful_loading.widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';

class _PictureBuilder {
  final Future<Picture> Function() upload;
  final Picture pictureWithoutPath;

  const _PictureBuilder({
    required this.upload,
    required this.pictureWithoutPath,
  });
}

Future<_PictureBuilder> createPictureBuilder(
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

  final pictureBuilder = _PictureBuilder(
    pictureWithoutPath: pictureWithoutPath,
    upload: pictureWithoutPath.upload(file: file),
  );

  return pictureBuilder;
}

class DishfulEditablePicture extends ConsumerWidget {
  final StateProvider<_PictureBuilder?> _pictureBuilderProvider =
      StateProvider((_) => null);
  late final StateProvider<Picture?> pictureProvider;
  late final StateProvider<bool> isEditingProvider;
  final StateProvider<bool> isLoadingProvider = StateProvider((_) => false);
  final Future<void> Function(Picture?) onSave;
  final Future<void> Function(Picture) onDelete;
  final Picture? initialValue;

  DishfulEditablePicture({
    Key? key,
    StateProvider<Picture?>? pictureProvider,
    StateProvider<bool>? isEditingProvider,
    required this.onSave,
    required this.onDelete,
    this.initialValue,
  })  : pictureProvider = pictureProvider ?? StateProvider((_) => initialValue),
        isEditingProvider = isEditingProvider ?? StateProvider((_) => true),
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedPicture = ref.watch(pictureProvider);
    final pictureBuilder = ref.watch(_pictureBuilderProvider);
    final isEditing = ref.watch(isEditingProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final blurHashPicture = pictureBuilder?.pictureWithoutPath ?? savedPicture;

    final uploadButton = TextButton(
      child: Text(
        pictureBuilder == null && savedPicture == null ? "Upload" : "Change",
      ),
      onPressed: () async {
        final _picker = ImagePicker();
        final file = await _picker.pickImage(source: ImageSource.gallery);
        final newPictureBuilder = await createPictureBuilder(
          file!,
          currentPicture: savedPicture,
        );

        ref.set(_pictureBuilderProvider, newPictureBuilder);
      },
    );

    final deleteButton = TextButton(
      child: Text("Delete"),
      onPressed: () async {
        try {
          await savedPicture!.delete();
          await onDelete(savedPicture);
        } catch (e) {
          print("Picture file or object deletion failed.");
          print(e);
        }
      },
    );

    final saveButton = TextButton(
      child: Text("Save"),
      onPressed: () async {
        ref.set(isLoadingProvider, true);
        final _pictureBuilder = ref.read(_pictureBuilderProvider);

        try {
          final newPicture = await _pictureBuilder?.upload();
          await onSave(newPicture);

          ref.set(_pictureBuilderProvider, null);
          ref.set(pictureProvider, newPicture);
        } catch (e) {
          print("Picture file or object upload failed.");
          print(e);
        }

        ref.set(isLoadingProvider, false);
        ref.set(isEditingProvider, false);
      },
    );

    final cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        ref.set(_pictureBuilderProvider, null);
        ref.set(isEditingProvider, false);
      },
    );

    final readonlyChild = DishfulPicture(picture: savedPicture);
    final editingChild = Stack(
      alignment: Alignment.center,
      children: [
        if (blurHashPicture != null)
          DishfulBlurHash(
            blurHash: blurHashPicture.blurHash,
            width: blurHashPicture.width,
            height: blurHashPicture.height,
          ),
        if (isLoading)
          DishfulLoading()
        else
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              uploadButton,
              if (savedPicture != null) deleteButton,
              if (pictureBuilder != null) saveButton,
              if (pictureBuilder != null) cancelButton,
            ],
          )
      ],
    );

    return AnimatedCrossFade(
      firstChild: editingChild,
      secondChild: readonlyChild,
      crossFadeState:
          isEditing ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: 800.milliseconds,
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
      child: Image.memory(bytes),
    );
  }
}
