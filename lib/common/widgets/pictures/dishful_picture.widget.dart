import 'package:cached_network_image/cached_network_image.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:dishful/common/domain/picture.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';

class DishfulPicture extends StatelessWidget {
  final Picture? picture;
  final double noImageIconSize;

  const DishfulPicture({
    Key? key,
    required this.picture,
    this.noImageIconSize = 64,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (picture?.path == null)
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Icon(
          Icons.hide_image,
          size: noImageIconSize,
        ),
      );

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
