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

  static String _getFilePath(String imageId, {String? userId}) {
    userId ??= AuthService.currentUser?.uid;
    return "$userId/${imageId}";
  }

  static Future<String> upload(
    XFile file,
    String imageId, {
    String? userId,
  }) async {
    final data = await file.readAsBytes();
    final path = _getFilePath(imageId, userId: userId);

    await _storage.ref(path).putData(data);

    return await _storage.ref(path).getDownloadURL();
  }

  static Future<void> delete(
    String imageId, {
    String? userId,
  }) async {
    final path = _getFilePath(imageId, userId: userId);
    await _storage.ref(path).delete();
  }
}
