import 'dart:async';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:dishful/common/data/image.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/picture.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/widgets/dishful_loading.widget.dart';
import 'package:dishful/common/widgets/pictures/dishful_blur_hash_picture.widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class DishfulUploadPicture extends ConsumerWidget {
  final Picture? initialValue;
  final StateProvider<_PictureUploader?> _pictureUploaderProvider;

  final _isLoadingProvider = StateProvider((_) => false);

  final FutureOr<void> Function(Picture) onUpload;
  final FutureOr<void> Function(Picture) onDelete;

  DishfulUploadPicture({
    Key? key,
    this.initialValue,
    required this.onUpload,
    required this.onDelete,
  })  : _pictureUploaderProvider = StateProvider(
          (_) => _PictureUploader.initialValue(initialValue: initialValue),
        ),
        super(key: key);

  /// Persist the state of the picture.
  ///
  /// This may involve doing nothing or deleting / uploading a picture
  /// to cloud storage.
  ///
  /// If no picture is selected and no [initialValue] was given, then
  /// we do nothing.
  ///
  /// If no picture is selected but an [initialValue] was given, then
  /// the [initialValue] is deleted.
  ///
  /// If neither of the above, then
  /// the [initialValue] is replaced with the selected value or in the case
  /// of no [initialValue] given, we upload a brand new picture.
  Future<void> save(WidgetRef ref) async {
    final _pictureUploader = ref.read(_pictureUploaderProvider);

    final noPicture = _pictureUploader == null && initialValue == null;

    if (noPicture) {
      return;
    }

    final deleted = _pictureUploader == null && initialValue != null;

    if (deleted) {
      final oldPicture = initialValue!;
      await oldPicture.delete();
      await onDelete(oldPicture);
      return;
    }

    final newPicture = await _pictureUploader!.upload();
    await onUpload(newPicture);
  }

  Future<void> _select(WidgetRef ref) async {
    ref.set(_isLoadingProvider, true);
    final _picker = ImagePicker();
    final file = await _picker.pickImage(source: ImageSource.gallery);

    final oldPictureUploader = ref.read(_pictureUploaderProvider);
    final newPictureUploader = await _createPictureUploader(
      file!,
      existingPictureId: oldPictureUploader?.pictureWithoutPath?.id,
    );

    ref.set(_pictureUploaderProvider, newPictureUploader);
    ref.set(_isLoadingProvider, false);
  }

  void _reset(WidgetRef ref) {
    ref.set(_pictureUploaderProvider, null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(_isLoadingProvider);
    final pictureUploader = ref.watch(_pictureUploaderProvider);
    final blurHashPicture = pictureUploader?.pictureWithoutPath;
    final noImage = pictureUploader?.pictureWithoutPath == null;

    final uploadButton = TextButton(
      child: Text(noImage ? "Upload" : "Change", style: context.bodySmall),
      onPressed: () => _select(ref),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(14)),
      ),
    );

    final deleteButton = TextButton(
      child: Text("Delete", style: context.bodySmall),
      onPressed: () => _reset(ref),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(14)),
      ),
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        if (blurHashPicture != null)
          DishfulBlurHashPicture(
            blurHash: blurHashPicture.blurHash,
            width: blurHashPicture.width,
            height: blurHashPicture.height,
          )
        else
          GestureDetector(
            onTap: () => _select(ref),
            child: SizedBox(
              height: context.height * 0.3,
              child: Container(color: Colors.white),
            ),
          ),
        if (isLoading)
          DishfulLoading(noBackground: true, size: 100)
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              uploadButton,
              if (!noImage) ...[Container(width: 16), deleteButton],
            ],
          )
      ],
    );
  }
}

Future<_PictureUploader> _createPictureUploader(
  XFile file, {
  required String? existingPictureId,
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
    id: existingPictureId,
    blurHash: blurHash.hash,
    width: resizedImage.width,
    height: resizedImage.height,
    isLocal: isLocal,
  );

  /// Store the [resizedImage] instead of the original [file].
  final resizedFile = XFile.fromData(imageToBytes(resizedImage));

  final pictureUploader = _PictureUploader(
    pictureWithoutPath: pictureWithoutPath,
    upload: () => pictureWithoutPath.upload(file: resizedFile),
  );

  return pictureUploader;
}

class _PictureUploader {
  final Future<Picture> Function() upload;
  final Picture? pictureWithoutPath;

  const _PictureUploader({
    required this.upload,
    required this.pictureWithoutPath,
  });

  _PictureUploader.initialValue({Picture? initialValue})
      : upload = (() => Future.value(initialValue)),
        pictureWithoutPath = initialValue;
}
