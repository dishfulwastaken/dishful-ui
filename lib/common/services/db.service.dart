library db;

import 'dart:async';

import 'package:dishful/common/data/env.dart';
import 'package:dishful/common/data/intersperse.dart';
import 'package:dishful/common/data/json.dart';
import 'package:dishful/common/domain/iteration.dart';
import 'package:dishful/common/domain/recipe.dart';
import 'package:dishful/common/domain/review.dart';
import 'package:dishful/common/domain/subscription.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:dishful/common/services/cloud.service.dart';
import 'package:dishful/common/services/storage.service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'db/db_hive.dart';
part 'db/db_firestore.dart';
part 'db/db_mock.dart';
part 'db/db.types.dart';

class DbService {
  static Db? _hiveDb;
  static Db? _firestoreDb;
  static final _mockDb = MockDb();

  static Future<void> initPrivateDb() async {
    _hiveDb = HiveDb();
    await _hiveDb!.init();
  }

  static Future<void> initPublicDb() async {
    _firestoreDb = FirestoreDb();
    await _firestoreDb!.init();
  }

  static Db get privateDb {
    assert(_hiveDb != null, 'DbService.initPrivateDb must be called first!');
    return _hiveDb!;
  }

  static Db get publicDb {
    assert(
        _firestoreDb != null, 'DbService.initPublicDb must be called first!');
    return _firestoreDb!;
  }

  static Db get mockDb => _mockDb;
}
