import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:dishful/common/data/strings.dart';
import 'package:dishful/common/data/image.dart';
import 'package:dishful/common/domain/recipe_meta.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:dishful/common/services/route.service.dart';
import 'package:dishful/common/widgets/editable.widget.dart';
import 'package:flutter/material.dart';
import 'package:parallax_animation/parallax_animation.dart';

class RecipesCard extends StatelessWidget {
  final RecipeMeta _recipe;

  RecipesCard(this._recipe);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => RouteService.goToRecipe(context, _recipe.id),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.width * 0.80,
            maxHeight: context.height * 0.5,
          ),
          child: ParallaxWidget(
            overflowWidthFactor: 1.2,
            background: Stack(
              fit: StackFit.expand,
              children: [
                FittedBox(
                  fit: BoxFit.fill,
                  child: _recipe.image.get == null
                      ? Container(
                          color: Colors.grey.shade300,
                          width: 100,
                          height: 100,
                        )
                      : Image.memory(
                          imageToBytes(
                            BlurHash.decode(_recipe.image.get!.blurHash)
                                .toImage(
                              100,
                              200,
                            ),
                          ),
                        ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: _recipe.image.get == null
                      ? Icon(
                          Icons.hide_image,
                          size: 64,
                        )
                      : Hero(
                          tag: "recipe-page-${_recipe.id}",
                          child: EditableImage(
                            initialValue: _recipe.image.get,
                            saveValue: (_) async {},
                          ),
                        ),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 28,
                  ),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _recipe.name,
                        style: context.headlineSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${_recipe.iterationCount} Iterations  |  ${_recipe.status.name.toTitleCase()}",
                        style: context.bodyMedium?.copyWith(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 18,
                  ),
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () async {
                      await DbService.publicDb.recipeMeta().delete(_recipe.id);
                    },
                    icon: Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
