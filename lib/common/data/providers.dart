import 'package:dishful/common/services/db.service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StreamProvider<T> getProvider<T extends Serializable>(Client<T> client) =>
    StreamProvider<T>((ref) {
      return client.watch();
    });
