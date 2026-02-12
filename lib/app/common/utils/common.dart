
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import '../constant/name_list.dart';

class CommonUtils{
  //随机生成英文名字
  static String ranndomName({List? nameStrList}){
    String name = "";
    final random = Random();
    int randInt = random.nextInt(nameStrList!=null?nameStrList.length:nameList.length);
    name = nameStrList!=null?nameStrList[randInt]:nameList[randInt];
    return name;
  }

 static Future<File> writeImageToTemp(List<int> bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/share_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    return file.writeAsBytes(bytes);
  }

  static String getCountryCode() {
    var local = Get.locale; //当前app内使用的语言
    if (local != null) {
      return local.countryCode ?? "CN";
    }
    return "CN";
  }

}