import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/recipe_image.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/storage.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flash/flash.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';

final isEditingProvider = StateProvider((_) => false);

class EditableWidget extends ConsumerWidget {
  final Widget Function() defaultChildBuilder;
  final Widget Function(FocusNode) editableChildBuilder;
  final Future Function() onSave;
  final Future Function()? onEdit;

  EditableWidget({
    required this.defaultChildBuilder,
    required this.editableChildBuilder,
    required this.onSave,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(isEditingProvider);
    final FocusNode focusNode = FocusNode();

    final onFocusChange = () async {
      if (!focusNode.hasFocus) {
        ref.set(isEditingProvider, false);
        try {
          await onSave();
          await context.showSuccessBar(content: Text("Successfully updated."));
        } on Exception {
          await context.showErrorBar(content: Text("Failed to save..."));
        }
      } else if (onEdit != null) {
        await onEdit!();
      }
    };

    if (isEditing) {
      focusNode.requestFocus();
      focusNode.addListener(onFocusChange);
    }

    return isEditing
        ? editableChildBuilder(focusNode)
        : GestureDetector(
            child: defaultChildBuilder(),
            onLongPress: () => ref.set(isEditingProvider, true),
          );
  }
}

class EditableTextField extends StatelessWidget {
  late final TextEditingController controller;
  final String? prefix;
  final TextStyle? style;
  final Future Function(String) onSave;

  EditableTextField({
    Key? key,
    required this.onSave,
    this.prefix,
    this.style,
    String? initialValue,
  }) : super(key: key) {
    controller = TextEditingController(text: initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return EditableWidget(
      defaultChildBuilder: () =>
          Text("$prefix ${controller.text}", style: style),
      editableChildBuilder: (focusNode) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(prefix ?? "", style: style),
          Container(width: 2),
          Flexible(
            child: TextField(
              focusNode: focusNode,
              controller: controller,
              style: style,
              decoration: InputDecoration.collapsed(
                hintText: prefix,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
      onSave: () async => await onSave(controller.text),
    );
  }
}

class EditableImage extends ConsumerWidget {
  final Future Function(RecipeImage?) onSave;
  late final StateProvider<RecipeImage?> recipeImageProvider;

  EditableImage({
    Key? key,
    RecipeImage? initialValue,
    required this.onSave,
  }) : super(key: key) {
    recipeImageProvider = StateProvider((_) => initialValue);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeImage = ref.watch(recipeImageProvider);

    return EditableWidget(
      defaultChildBuilder: () => recipeImage == null
          ? Text("No image")
          : OctoImage.fromSet(
              image: recipeImage.isLocal
                  ? XFileImage(XFile(recipeImage.path)) as ImageProvider
                  : CachedNetworkImageProvider(
                      recipeImage.path,
                    ),
              octoSet: OctoSet.blurHash(recipeImage.blurHash),
              width: 200,
              height: 120,
            ),
      editableChildBuilder: (focusNode) => TextButton(
        focusNode: focusNode,
        onPressed: () async {
          final _picker = ImagePicker();
          final file = await _picker.pickImage(source: ImageSource.gallery);

          final data = await file!.readAsBytes();
          final image = img.decodeImage(data.toList())!;

          final blurComponentX = image.width > image.height ? 4 : 3;
          final blurComponentY = image.height > image.width ? 4 : 3;

          final blurHash = BlurHash.encode(
            image,
            numCompX: blurComponentX,
            numCompY: blurComponentY,
          );

          final blurImage = RecipeImage.create(
            blurHash: blurHash.hash,
            blurComponentX: blurComponentX,
            blurComponentY: blurComponentY,
          );

          final path = await StorageService.upload(
            file,
            blurImage.id,
          );
          final recipeImage = blurImage.copyWithPath(path);

          ref.set(recipeImageProvider, recipeImage);

          // final updatedRecipe = recipe.copyWith.image(
          //   [recipeImage],
          // );

          // await DbService.publicDb
          //     .recipeMeta()
          //     .update(updatedRecipe);
        },
        child: Text("Add image"),
      ),
      onSave: () async => await onSave(recipeImage),
    );
  }
}
