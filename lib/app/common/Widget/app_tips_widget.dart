import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

//app提示性组件
class AppTipsWidget{
  static showToast(String toastText) {
    Fluttertoast.showToast(
      msg: toastText,
      gravity: ToastGravity.CENTER,
      backgroundColor: Color.fromRGBO(167, 167, 167, 1),
      textColor: Colors.white,
      fontSize: 12.0,
    );
  }


}