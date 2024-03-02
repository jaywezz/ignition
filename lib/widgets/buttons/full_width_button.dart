import 'package:flutter/material.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/utils/size_utils.dart';
import 'package:soko_flow/utils/size_utils2.dart';

class FullWidthButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? color;

  final double? width, height, textSize;
  final Function action;

  const FullWidthButton(
      {Key? key,
      this.text,
      this.child,
      this.height,
      this.textSize,
      this.color,
      required this.action,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color ?? Styles.appSecondaryColor,
      minWidth: width ?? double.infinity,
      height: Responsive.isMobile(context) && Responsive.isMobileLarge(context)
          ? height ?? 50
          : 70,
      //SizeConfig.isTabletWidth ? 70 : 50,
      child: child ??
          Text("$text",
              style: Styles.buttonText2(context)
                  .copyWith(fontSize: textSize ?? 20)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultRadius1)),
      onPressed: () {
        action();
      },
    );
  }
}
