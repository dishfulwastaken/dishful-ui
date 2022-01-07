library db;

import 'dart:async';

import 'package:dishful/common/data/json.dart';
import 'package:dishful/common/domain/recipe_ingredient.dart';
import 'package:dishful/common/domain/recipe_iteration.dart';
import 'package:dishful/common/domain/recipe_meta.dart';
import 'package:dishful/common/domain/recipe_review.dart';
import 'package:dishful/common/domain/recipe_step.dart';
import 'package:dishful/common/services/cloud.service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'db/db_hive.dart';
part 'db/db_firebase.dart';
part 'db/db_mock.dart';
part 'db/db.types.dart';

class DbService {
  static Db? _hiveDb;
  static Db? _firebaseDb;
  static final _mockDb = MockDb();

  static Future<void> initPrivateDb() async {
    _hiveDb = HiveDb();
    await _hiveDb!.init();
  }

  static Future<void> initPublicDb() async {
    _firebaseDb = FirebaseDb();
    await _firebaseDb!.init();
  }

  static Db get privateDb {
    assert(_hiveDb != null, 'DbService.initPrivateDb must be called first!');
    return _hiveDb!;
  }

  static Db get publicDb {
    assert(_firebaseDb != null, 'DbService.initPublicDb must be called first!');
    return _firebaseDb!;
  }

  static Db get mockDb => _mockDb;
}
