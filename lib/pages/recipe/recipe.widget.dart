import 'package:cached_network_image/cached_network_image.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:dishful/common/data/providers.dart';
import 'package:dishful/common/domain/recipe_image.dart';
import 'package:dishful/common/domain/recipe_meta.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/storage.service.dart';
import 'package:dishful/common/test.dart';
import 'package:dishful/pages/recipe/recipe_iterations.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:image/image.dart' as img;

class RecipePage extends ConsumerWidget {
  late final AsyncValueProvider<RecipeMeta> recipeProvider;

  RecipePage(String id) {
    recipeProvider = getProvider(DbService.publicDb.recipeMeta(), id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeValue = ref.watch(recipeProvider);

    return recipeValue.toWidget(
      data: (recipe) {
        return Scaffold(
          appBar: AppBar(title: Text(recipe.name)),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await DbService.publicDb
                  .recipeIteration(recipe.id)
                  .create(randomRecipeIteration(recipe.id));
            },
            child: const Icon(Icons.plus_one_rounded),
          ),
          body: Column(
            children: [
              recipe.image.isEmpty
                  ? TextButton(
                      onPressed: () async {
                        final _picker = ImagePicker();
                        final file = await _picker.pickImage(
                            source: ImageSource.gallery);

                        final data = await file!.readAsBytes();
                        final image = img.decodeImage(data.toList())!;

                        final blurComponentX =
                            image.width > image.height ? 4 : 3;
                        final blurComponentY =
                            image.height > image.width ? 4 : 3;

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

                        final updatedRecipe = recipe.copyWith.image(
                          [recipeImage],
                        );

                        await DbService.publicDb
                            .recipeMeta()
                            .update(updatedRecipe);
                      },
                      child: Text("Add image"))
                  : OctoImage.fromSet(
                      image: recipe.image.first.isLocal
                          ? XFileImage(XFile(recipe.image.first.path))
                              as ImageProvider
                          : CachedNetworkImageProvider(
                              recipe.image.first.path,
                            ),
                      octoSet: OctoSet.blurHash(recipe.image.first.blurHash),
                      width: 200,
                      height: 120,
                    ),
              Text('Your iterations:'),
              RecipeIterations(recipe.id),
            ],
          ),
        );
      },
    );
  }
}
