
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class SecureStorage{
  static  FlutterSecureStorage flutterSecureStorage=const FlutterSecureStorage();

  //删除所有
  static clean()async{
    // Delete all
    await flutterSecureStorage.deleteAll();
  }

  //获取自定义的设备id（用于恢复购买）
  static Future<String> getSecureDeviceId() async {
    String? deviceId = await flutterSecureStorage.read(key: "apple_id");
    if (deviceId == null||deviceId.isEmpty) {
      deviceId = const Uuid().v4();
      deviceId="custom$deviceId";
      //加了custom 表示自定义的id 不是真实的apple id
      await flutterSecureStorage.write(key: "apple_id", value:deviceId);
    }
    return deviceId;
  }

  static  setSecureDeviceId({required String deviceId })async{
    await flutterSecureStorage.write(key: "apple_id", value: deviceId);
  }
}