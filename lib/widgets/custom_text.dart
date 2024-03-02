import 'package:flutter/material.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';

class CustomText extends StatelessWidget {
  final String txt;
  final Color? color;
  final double? txtSize;
  final FontWeight? txtWeight;
  const CustomText({
    Key? key,
    required this.txt,
    this.txtSize,
    this.color,
    this.txtWeight,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        color: color ?? Colors.black,
        fontSize: txtSize ?? defaultPadding(context),
        fontWeight: txtWeight ?? FontWeight.w400,
      ),
    );
  }
}
