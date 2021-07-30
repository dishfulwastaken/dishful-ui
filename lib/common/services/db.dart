import 'package:dishful/common/domain/recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BoxName {
  static const _base = 'dishful_storage';
  static const recipe = '${_base}_recipe';
  static const recipeIteration = '${_base}_recipe_iteration';
  static const recipeIngredient = '${_base}_recipe_ingredient';
  static const recipeStep = '${_base}_recipe_step';
  static const recipeReview = '${_base}_recipe_review';
}

Future<void> setUpDb() async {
  await Hive.initFlutter();
}

void closeDb() async {
  await Hive.close();
}

typedef E FromMapFunction<E extends DataClass>(Map<String, dynamic> map);
typedef Widget DbListener<E extends DataClass>(
    BuildContext context, List<E> data);

abstract class DataClass<E> {
  String get id;
  Map<String, dynamic> toMap();
}

class Client<T extends DataClass> {
  Box<Map<String, dynamic>>? box;
  late FromMapFunction<T> fromMap;

  void init({
    required String boxName,
    required FromMapFunction<T> fromMap,
  }) async {
    this.fromMap = fromMap;
    bool notOpen = !Hive.isBoxOpen(boxName);

    box = notOpen ? await Hive.openBox(boxName) : Hive.box(boxName);
  }

  List<T> getAll() {
    var data = box!.values.map(fromMap).toList();
    return data;
  }

  T? get(String id) {
    var dataAsMap = box!.get(id);
    if (dataAsMap == null) return null;
    T data = fromMap(dataAsMap);
    return data;
  }

  void post(T data) {
    var dataAsMap = data.toMap();
    box!.put(data.id, dataAsMap);
  }

  T put(String id, Map<String, dynamic> overrides) {
    var oldDataAsMap = box!.get(id);
    var newDataAsMap = {...oldDataAsMap ?? {}, ...overrides};
    box!.put(id, newDataAsMap);
    var newData = fromMap(newDataAsMap);
    return newData;
  }

  void delete(String id) {
    box!.delete(id);
  }

  Widget listener(DbListener<T> callback) {
    return ValueListenableBuilder(
      valueListenable: box!.listenable(),
      builder: (BuildContext context, Box<Map<String, dynamic>> box, _) {
        List<T> data = getAll();
        return callback(context, data);
      },
    );
  }
}

class Db {
  static Client<E> _build<E extends DataClass>(
    String boxName,
    dynamic fromMap,
  ) {
    return Client<E>()..init(boxName: boxName, fromMap: fromMap);
  }

  static Client<Recipe> get recipe => _build(
        BoxName.recipe,
        Recipe.fromMap,
      );
  static Client<RecipeIteration> get recipeIteration => _build(
        BoxName.recipeIteration,
        RecipeIteration.fromMap,
      );
  static Client<RecipeIngredient> get recipeIngredient => _build(
        BoxName.recipeIngredient,
        RecipeIngredient.fromMap,
      );
  static Client<RecipeStep> get recipeStep => _build(
        BoxName.recipeStep,
        RecipeStep.fromMap,
      );
  static Client<RecipeReview> get recipeReview => _build(
        BoxName.recipeReview,
        RecipeReview.fromMap,
      );
}

void main() {
  Db.recipe.listener((context, data) => Container());
}
