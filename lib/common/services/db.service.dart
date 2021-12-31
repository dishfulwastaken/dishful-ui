library db;

import 'dart:async';

import 'package:dishful/common/data/json.dart';
import 'package:dishful/common/domain/recipe_ingredient.dart';
import 'package:dishful/common/domain/recipe_iteration.dart';
import 'package:dishful/common/domain/recipe_meta.dart';
import 'package:dishful/common/domain/recipe_review.dart';
import 'package:dishful/common/domain/recipe_step.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'db/firebase_options.dart';

part 'db/db_hive.dart';
part 'db/db_firebase.dart';
part 'db/db_mock.dart';
part 'db/db.types.dart';

final _hiveDb = HiveDb();
final _firebaseDb = FirebaseDb();
final _mockDb = MockDb();

class DbService {
  static Future<void> init() async {
    await _hiveDb.init();
    await _firebaseDb.init();
    await _mockDb.init();
  }

  static Future<void> close() async {
    await _hiveDb.close();
    await _firebaseDb.close();
    await _mockDb.close();
  }

  static Db getDb(DbProvider? provider) {
    switch (provider) {
      case DbProvider.hive:
        return _hiveDb;
      case DbProvider.firebase:
        return _firebaseDb;
      default:
        return _mockDb;
    }
  }
}
