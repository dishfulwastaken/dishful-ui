import 'dart:typed_data';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:dishful/common/data/image.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/picture.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/storage.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';

Future<Picture?> createPicture(
  XFile file, {
  required Picture? currentPicture,
}) async {
  final id = AuthService.currentUser.uid;
  final subscription = await DbService.publicDb.subscriptions.get(id);
  if (subscription == null) throw "Failed to fetch subscription with ID: $id";

  final isLocal = !subscription.isCurrentlySubscribed;

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

  final path = isLocal
      ? file.path
      : await StorageService.upload(file, pictureWithoutPath.id);

  return pictureWithoutPath.copyWithPath(path);
}

class DishfulEditablePicture extends ConsumerWidget {
  late final StateProvider<Picture?> pictureProvider;
  late final StateProvider<bool> isEditingProvider;

  DishfulEditablePicture({
    Key? key,
    StateProvider<Picture?>? pictureProvider,
    StateProvider<bool>? isEditingProvider,
  })  : pictureProvider = pictureProvider ?? StateProvider((_) => null),
        isEditingProvider = isEditingProvider ?? StateProvider((_) => true),
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final picture = ref.watch(pictureProvider);
    final isEditing = ref.watch(isEditingProvider);

    if (!isEditing) return DishfulPicture(picture: picture);

    final uploadButton = TextButton(
      child: Text("Upload"),
      onPressed: () async {
        final _picker = ImagePicker();
        final file = await _picker.pickImage(source: ImageSource.gallery);
        final newPicture = createPicture(file!, currentPicture: picture);

        ref.set(pictureProvider, newPicture);
      },
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        if (picture != null)
          DishfulBlurHash(
            blurHash: picture.blurHash,
            width: picture.width,
            height: picture.height,
          ),
        uploadButton,
      ],
    );
  }
}

class DishfulPicture extends StatelessWidget {
  final Picture? picture;

  const DishfulPicture({Key? key, required this.picture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (picture == null) return Text("No image.");

    return OctoImage.fromSet(
      image: picture!.isLocal
          ? XFileImage(XFile(picture!.path)) as ImageProvider
          : CachedNetworkImageProvider(picture!.path),
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
