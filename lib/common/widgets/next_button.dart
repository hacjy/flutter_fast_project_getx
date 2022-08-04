import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/common/utils/layout.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class NextButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final Color color;
  final String text;

  const NextButton({
    Key? key,
    required this.onPressed,
    this.color = const Color.fromRGBO(168, 168, 168, 1),
    this.text = 'Next',
  }) : super(key: key);
  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  bool _isLoading = false;

  @override
  Widget build(_) => InkWell(
        onTap: _isLoading
            ? () {}
            : () async {
                _isLoading = true;
                setState(() {});
                try {
                  await widget.onPressed();
                } catch (e) {
                  _isLoading = false;
                }
                _isLoading = false;
                setState(() {});
              },
        child: Container(
          height: 88.w,
          margin: EdgeInsets.only(bottom: getBottomHeight(context)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _isLoading ? Colors.grey : widget.color,
            borderRadius: BorderRadius.circular(60.w),
          ),
          child: _buildChild(),
        ),
      );

  Widget _buildChild() => _isLoading
      ? LoadingAnimationWidget.waveDots(color: Colors.white, size: 80.w)
      : Text(
          widget.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32.sp,
            fontWeight: FontWeight.w500,
          ),
        );
}
