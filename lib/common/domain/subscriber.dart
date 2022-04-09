import 'package:dishful/common/data/datetime.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/subscriber.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class Subscriber extends Serializable {
  final String id;
  final DateTime? subscribedUntil;

  bool get isCurrentlySubscribed {
    if (subscribedUntil == null) return false;

    return subscribedUntil!.isAfterNow;
  }

  Subscriber({
    required this.id,
    this.subscribedUntil,
  });

  Subscriber.create({
    String? id,
    this.subscribedUntil,
  }) : id = id ?? uuid.v1();
}

class SubscriberSerializer extends Serializer<Subscriber> {
  const SubscriberSerializer();
  Subscriber fromJson(Json json) => _$SubscriberFromJson(json);
  Json toJson(Subscriber data) => _$SubscriberToJson(data);
}
