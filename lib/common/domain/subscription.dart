import 'package:dishful/common/data/datetime.dart';
import 'package:dishful/common/services/db.service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:uuid/uuid.dart';

part 'generated/subscription.g.dart';

final uuid = Uuid();

@CopyWith()
@JsonSerializable()
class Subscription extends Serializable {
  final String id;
  final DateTime? subscribedUntil;

  bool get isCurrentlySubscribed {
    if (subscribedUntil == null) return false;

    return subscribedUntil!.isAfterNow;
  }

  Subscription({
    required this.id,
    this.subscribedUntil,
  });

  Subscription.create({
    String? id,
    this.subscribedUntil,
  }) : id = id ?? uuid.v1();
}

class SubscriptionSerializer extends Serializer<Subscription> {
  const SubscriptionSerializer();
  Subscription fromJson(Json json) => _$SubscriptionFromJson(json);
  Json toJson(Subscription data) => _$SubscriptionToJson(data);
}
