import 'dart:typed_data';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:dishful/common/data/image.dart';
import 'package:flutter/material.dart';

class DishfulBlurHashPicture extends StatelessWidget {
  final String? blurHash;
  final int? width;
  final int? height;
  final void Function()? onDecode;

  const DishfulBlurHashPicture({
    Key? key,
    this.blurHash,
    this.width,
    this.height,
    this.onDecode,
  })  : assert(blurHash != null && width != null && height != null ||
            blurHash == null && width == null && height == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (blurHash == null)

      /// Give the container dimensions so that if placed in a [FittedBox], it
      /// can use [BoxFit.fill]. This is a common use case for
      /// [DishfulBlurHashPicture].
      return Container(color: Colors.white, width: 100, height: 100);

    Uint8List bytes = imageToBytes(
      BlurHash.decode(blurHash!).toImage(width!, height!),
    );

    if (onDecode != null) onDecode!();

    return Image.memory(bytes);
  }
}
