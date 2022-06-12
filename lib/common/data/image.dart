import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:tuple/tuple.dart';

/// Compute the blur image components for the given [image].
///
/// The recommended components are 4, 3 respectively, but
/// it is also recommended that if the width < height, the
/// X component should be smaller than the Y component.
///
/// Therefore the components we use are 4, 3 for wider images
/// and 3, 4 for taller images.
Tuple2<int, int> blurImageComponents(Image image) => Tuple2(
      image.width > image.height ? 4 : 3,
      image.width < image.height ? 4 : 3,
    );

/// Scale down the [image] if it's height exceeds
/// [maxHeight] or it's width exceeds [maxWidth].
///
/// This should be done before any expensive operations,
/// e.g. blur hash encoding.
Image normalizeImage(
  Image image, {
  int maxWidth = 500,
  int maxHeight = 500,
}) {
  final isPortrait = image.width < image.height;
  final isOverMax =
      isPortrait ? image.height > maxHeight : image.width > maxWidth;

  if (isOverMax)
    return isPortrait
        ? copyResize(image, height: maxHeight)
        : copyResize(image, width: maxWidth);

  return image;
}

/// Convert the given [bytes] into an [Image].
///
/// Flutter cannot use raw bytes, so this function must be used
/// to create fully encoded images with their correct headers.
Image bytesToImage(Uint8List bytes) => decodeImage(bytes)!;

/// Convert the given [Image] into [bytes].
///
/// Similar to above, flutter needs the image to have all of
/// the correct headers.
Uint8List imageToBytes(Image image) => Uint8List.fromList(encodePng(image));
