import 'package:get/get.dart';
import "package:flutter/material.dart";

bottomSheet({String? title,String? leftBtnText,String? rightBtnText,Function() ? onTapLeft,Function() ? onTapRight,Widget? leftIcon,Widget? rightIcon}) {
  return Get.bottomSheet(Container(
    width: Get.width,
    height: 200,
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Colors.grey.shade200),
                child: const Icon(
                  Icons.close,
                  color: Colors.black45,
                  size: 20,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
         Text(
          title??"标题".tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
                child: InkWell(
                  onTap: (){
                    if(onTapLeft!=null) {
                      onTapLeft();
                    }
                    Get.back();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey.shade100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(leftIcon!=null)
                          leftIcon,
                        //Icon(Icons.camera_alt,color: Colors.black87,),
                        SizedBox(width: 5),
                        Text(leftBtnText??"取消".tr),
                      ],
                    ),
                  ),
                )),
            const SizedBox(width: 20),
            Expanded(
                child: InkWell(
                  onTap: (){
                    if(onTapRight!=null) {
                      onTapRight();
                    }
                    Get.back();
                    },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey.shade100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(rightIcon!=null)
                          rightIcon,
                        const SizedBox(width: 5),
                        Text(rightBtnText??"确定".tr)
                      ],
                    ),
                  ),
                )),
            const SizedBox(width: 10),
          ],
        )
      ],
    ),
  ));
}
