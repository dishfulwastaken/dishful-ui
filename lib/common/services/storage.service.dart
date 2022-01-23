import 'package:dishful/common/data/env.dart';

import 'cloud.service.dart';

class StorageService {
  static Future<void> init() async {
    assert(CloudService.ready, "CloudService.init must be called first!");

    // TODO: configure emulator
    // if (Env.isMock) _functions.useFunctionsEmulator("localhost", 5001);
  }
}
