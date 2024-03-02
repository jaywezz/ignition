import 'package:flutter/material.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/utils/size_utils2.dart';

class PillButton extends StatelessWidget {
  final bool selected;
  final Function action;
  final String text;
  final double? width;

  const PillButton(
      {Key? key,
      required this.selected,
      required this.action,
      required this.text,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      height: Responsive.isTablet(context) ? 50 : 35,
      minWidth: width,
      onPressed: () {
        action();
      },
      child: Text(
        text,
        style: Styles.normalText(context).copyWith(
          color: !selected ? Styles.appPrimaryColor : Colors.white,
        ),
      ),
      color: selected ? Styles.appPrimaryColor : Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(defaultPadding(context) * 2)),
    );
  }
}
