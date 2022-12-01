import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatefulWidget {
  final String? title;
  const CustomAppBar({Key? key,this.title}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(bottom: 56.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                widget.title??'',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 16.w,),
              InkWell(
                onTap: (){
                  Get.back();
                },
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black
                    ),
                    child: Icon(Icons.arrow_forward,color: Colors.white,size: 16.w,),
                  )
              )
            ],
          )
        ],
      ),
    );
  }
}

