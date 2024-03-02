import 'package:flutter/cupertino.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';

class TabButton extends StatelessWidget {
  const TabButton({Key? key, required this.text, this.isSelected = true})
      : super(key: key);
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: defaultPadding(context) / 4),
        decoration: BoxDecoration(
            color: isSelected ? null : Styles.appPrimaryColor,
            border: isSelected
                ? Border.all(width: 1, color: Styles.appPrimaryColor)
                : null,
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: isSelected ? Styles.bttxt1(context) : Styles.bttxt2(context),
          ),
        ),
      ),
    );
  }
}
