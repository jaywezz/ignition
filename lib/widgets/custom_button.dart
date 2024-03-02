import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {Key? key,
      required this.text,
      this.isSelected = true,
      required this.action})
      : super(key: key);
  final String text;
  final bool isSelected;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          action();
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: defaultPadding(context) / 4),
          decoration: BoxDecoration(
              color: isSelected ? Styles.appGreenColor : null,
              border: isSelected
                  ? null
                  : Border.all(width: 1.w, color: Styles.appGreenColor),
              borderRadius: BorderRadius.circular(20.sp)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.sp),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style:
                  isSelected ? Styles.bttxt2(context).copyWith(color: Colors.white) : Styles.bttxt2(context).copyWith(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
