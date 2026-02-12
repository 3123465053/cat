import 'package:flutter/material.dart';
import '../config/app_color.dart';

appBarExt(String title){
  return AppBar(title: Text(title),centerTitle: false,backgroundColor: AppColor.pageBackgroundColor);
}