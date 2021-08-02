library db;

import 'dart:async';

import 'package:dishful/common/domain/recipe.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'db/db_hive.dart';
part 'db/db_firebase.dart';
part 'db/db_mock.dart';
part 'db/db.types.dart';

Db getDb(DbProvider? provider) {
  switch (provider) {
    case DbProvider.hive:
      return HiveDb();
    case DbProvider.firebase:
      return FirebaseDb();
    default:
      return MockDb();
  }
}
