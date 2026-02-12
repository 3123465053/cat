import 'package:flutter/material.dart';

class CloseWidget extends StatelessWidget {
  CloseWidget({super.key,this.size,this.color,this.onTap});

  double? size;
  Color? color;
  Function() ? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(onTap!=null){
          onTap!();
        }
      },
      child: Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          border: Border.all(color: color ?? Colors.grey, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        child: Icon(Icons.close, size: 20, color: color ?? Colors.grey),
      ),
    );
  }
}
