import 'package:flutter/material.dart';
import 'package:dishful/common/services/db.service.dart';

void main() {
  Db hiveDb = getDb(DbProvider.hive);
}
