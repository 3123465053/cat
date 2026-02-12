import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

LoadingWidget({double? width}) {
  return SizedBox(
    width: width ?? 45,
    child: LoadingIndicator(
        indicatorType: Indicator.lineSpinFadeLoader,
        colors: const [Colors.grey],
        strokeWidth: 2,
        backgroundColor: Colors.transparent,
        pathBackgroundColor: Colors.transparent),
  );
}
