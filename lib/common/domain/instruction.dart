import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/instruction.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class Instruction extends Serializable {
  final String id;
  final int position;
  final String? title;
  final String description;
  final Duration? timer;

  Instruction({
    required this.id,
    required this.position,
    this.title,
    required this.description,
    this.timer,
  });

  Instruction.create({
    required this.position,
    this.title,
    required this.description,
    this.timer,
  }) : id = uuid.v1();
}

class InstructionSerializer extends Serializer<Instruction> {
  const InstructionSerializer();
  Instruction fromJson(Json json) => _$InstructionFromJson(json);
  Json toJson(Instruction data) => _$InstructionToJson(data);
}

class NullableInstructionSerializer extends Serializer<Instruction?> {
  const NullableInstructionSerializer();
  Instruction? fromJson(Json json) => _$InstructionFromJson(json);
  Json toJson(Instruction? data) =>
      data == null ? {} : _$InstructionToJson(data);
}
