// 翻译类，实现`Translations`接口
import 'package:get/get.dart';

import 'en_US.dart';
import 'zh_CN.dart'; // 导入简体中文翻译

class MyAppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': zhCN, // 使用简体中文翻译
        'en_US': enUS
      };
}
