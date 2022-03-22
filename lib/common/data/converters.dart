import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';

class Uint8ListConverter implements JsonConverter<Uint8List?, List> {
  const Uint8ListConverter();

  @override
  Uint8List? fromJson(List json) {
    return Uint8List.fromList(json.map((value) => value as int).toList());
  }

  @override
  List toJson(Uint8List? object) {
    if (object == null) {
      return [];
    }

    return object.toList();
  }
}
