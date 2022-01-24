import 'package:cross_file/cross_file.dart';
import 'package:dishful/common/data/env.dart';
import 'package:dishful/common/services/auth.service.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'cloud.service.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<void> init() async {
    assert(CloudService.ready, "CloudService.init must be called first!");

    if (Env.isMock) _storage.useStorageEmulator("localhost", 9199);
  }

  static Future<String> upload(
    XFile file,
    String imageId, {
    String? userId,
  }) async {
    userId ??= AuthService.currentUser?.uid;
    final data = await file.readAsBytes();
    final path = "$userId/${imageId}";

    await _storage.ref(path).putData(data);

    return await _storage.ref(path).getDownloadURL();
  }
}
