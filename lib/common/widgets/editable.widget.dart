import 'dart:typed_data';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:dishful/common/data/image.dart';
import 'package:dishful/common/data/intersperse.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/recipe_image.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/storage.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flash/flash.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';

class EditableScaffold extends ConsumerWidget {
  final isEditingProvider = StateProvider((_) => false);
  final menuItemsProvider = StateProvider((_) => <Widget>[]);

  final Widget? floatingActionButton;
  final Widget? body;
  final PreferredSizeWidget? appBar;

  EditableScaffold({this.body, this.appBar, this.floatingActionButton});

  static EditableScaffold? maybeOf(BuildContext context) {
    return context.findAncestorWidgetOfExactType<EditableScaffold>();
  }

  void startEditing(WidgetRef ref, List<Widget> menuItems) {
    ref.set(menuItemsProvider, menuItems);
    ref.set(isEditingProvider, true);
  }

  void stopEditing(WidgetRef ref) => ref.set(isEditingProvider, false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItems = ref.watch(menuItemsProvider);
    final isEditing = ref.watch(isEditingProvider);

    return Scaffold(
      body: body,
      appBar: appBar,
      floatingActionButton: isEditing
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: menuItems,
            )
          : floatingActionButton,
    );
  }
}

class EditableWidget<T> extends ConsumerWidget {
  final T Function() getValue;
  final void Function(T) setValue;
  final Future<void> Function(T) saveValue;
  final isSavingProvider = StateProvider((_) => false);
  final previousValues = <T>[];

  final Widget Function() defaultChildBuilder;
  final Widget Function(FocusNode) editableChildBuilder;
  final List<Widget> Function(Widget, Widget)? menuItemsBuilder;

  EditableWidget({
    required this.getValue,
    required this.setValue,
    required this.saveValue,
    required this.defaultChildBuilder,
    required this.editableChildBuilder,
    this.menuItemsBuilder,
  });

  Widget defaultSaveButton(
    WidgetRef ref,
    EditableScaffold editableScaffold,
    BuildContext context,
  ) =>
      FloatingActionButton(
        child: Consumer(
          builder: (_, ref, __) {
            final isSaving = ref.watch(isSavingProvider);

            return isSaving
                ? CircularProgressIndicator(color: Colors.white)
                : Icon(Icons.save);
          },
        ),
        onPressed: () async {
          ref.set(isSavingProvider, true);
          try {
            await saveValue(getValue());
            await context.showSuccessBar(content: Text("Successfully saved"));
            editableScaffold.stopEditing(ref);
            previousValues.removeLast();
          } catch (e) {
            context.showErrorBar(content: Text("Failed to save: $e"));
          }
          ref.set(isSavingProvider, false);
        },
      );

  Widget defaultCancelButton(
    WidgetRef ref,
    EditableScaffold editableScaffold,
  ) =>
      FloatingActionButton(
        child: Icon(Icons.cancel),
        onPressed: () {
          editableScaffold.stopEditing(ref);
          setValue(previousValues.removeLast());
        },
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editableScaffold = EditableScaffold.maybeOf(context);
    if (editableScaffold == null)
      throw "Editable must have an ancestor EditableScaffold";

    final isEditing = ref.watch(editableScaffold.isEditingProvider);
    final FocusNode focusNode = FocusNode();

    ref.listen<bool>(
      editableScaffold.isEditingProvider,
      (previous, next) {
        /// This must be done in this listener
        /// instead of the conditional below as it must only be
        /// called once per edit change.
        if (next) previousValues.add(getValue());
      },
    );

    if (isEditing) focusNode.requestFocus();

    final menuItems = (menuItemsBuilder != null
            ? menuItemsBuilder!(
                defaultSaveButton(ref, editableScaffold, context),
                defaultCancelButton(ref, editableScaffold),
              )
            : [
                defaultCancelButton(ref, editableScaffold),
                defaultSaveButton(ref, editableScaffold, context)
              ])
        .intersperse(Container(height: 12, width: 2))
        .toList();

    return isEditing
        ? editableChildBuilder(focusNode)
        : GestureDetector(
            child: defaultChildBuilder(),
            onLongPress: () => editableScaffold.startEditing(ref, menuItems),
          );
  }
}

class EditableTextField extends StatelessWidget {
  late final TextEditingController controller;
  final String? prefix;
  final TextStyle? style;
  final Future Function(String) saveValue;

  EditableTextField({
    Key? key,
    required this.saveValue,
    this.prefix,
    this.style,
    String? initialValue,
  }) : super(key: key) {
    controller = TextEditingController(text: initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return EditableWidget<String>(
      getValue: () => controller.text,
      setValue: (value) => controller.text = value,
      saveValue: saveValue,
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
    );
  }
}

class EditableImage extends ConsumerWidget {
  final RecipeImage? initialValue;
  final Future Function(RecipeImage?) saveValue;
  late final StateProvider<RecipeImage?> recipeImageProvider;

  EditableImage({
    Key? key,
    this.initialValue,
    required this.saveValue,
  }) : super(key: key) {
    recipeImageProvider = StateProvider((_) => initialValue);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeImage = ref.watch(recipeImageProvider);

    return EditableWidget<RecipeImage?>(
      getValue: () => ref.read(recipeImageProvider),
      setValue: (value) => ref.set(recipeImageProvider, value),
      saveValue: saveValue,
      defaultChildBuilder: () => recipeImage == null
          ? Text("No image")
          : OctoImage.fromSet(
              image: recipeImage.isLocal
                  ? XFileImage(XFile(recipeImage.path)) as ImageProvider
                  : CachedNetworkImageProvider(recipeImage.path),
              octoSet: OctoSet.blurHash(recipeImage.blurHash),
              width: recipeImage.width.toDouble(),
              height: recipeImage.height.toDouble(),
            ),
      editableChildBuilder: (focusNode) => Stack(
        children: [
          if (recipeImage != null)
            Align(
              alignment: Alignment.center,
              child: Image(
                image: XFileImage(
                  XFile.fromData(
                    imageToBytes(
                      BlurHash.decode(recipeImage.blurHash)
                          .toImage(recipeImage.width, recipeImage.height),
                    ),
                  ),
                ),
              ),
            ),
          Column(
            children: [
              if (initialValue != null && recipeImage != null)
                TextButton(
                  onPressed: () async {
                    await StorageService.delete(initialValue!.id);
                    ref.set(recipeImageProvider, null);
                  },
                  child: Text("Remove Image"),
                ),
              TextButton(
                focusNode: focusNode,
                onPressed: () async {
                  final _picker = ImagePicker();
                  final file =
                      await _picker.pickImage(source: ImageSource.gallery);

                  final data = await file!.readAsBytes();
                  final image = bytesToImage(data);

                  final resizedImage = normalizeImage(image);

                  final blurHash = BlurHash.encode(
                    resizedImage,
                    numCompX: blurImageComponents(resizedImage).item1,
                    numCompY: blurImageComponents(resizedImage).item2,
                  );

                  final blurImage = RecipeImage.create(
                    id: initialValue?.id,
                    blurHash: blurHash.hash,
                    width: resizedImage.width,
                    height: resizedImage.height,
                  );

                  final path = await StorageService.upload(
                    file,
                    blurImage.id,
                  );
                  final recipeImage = blurImage.copyWithPath(path);

                  ref.set(recipeImageProvider, recipeImage);
                },
                child: Text("Upload image"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
