
import 'package:flutter_tts/flutter_tts.dart';

class AppUtils{

  static flutterTTSInit()async{
     FlutterTts flutterTts = FlutterTts();
    // await flutterTts.setLanguage("en-US"); // 中文
     await flutterTts.setLanguage("zh-CN");
     await flutterTts.setSpeechRate(0.5);   // 语速 0~1
     await flutterTts.setVolume(1.0);       // 音量
     await flutterTts.setPitch(1.0);        // 音调
  }

}