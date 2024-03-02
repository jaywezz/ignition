import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soko_flow/configs/styles.dart';

class LeadPillButton extends StatelessWidget {
  final bool selected;
  final Function action;
  final String text;
  final double? width;

  const LeadPillButton(
      {Key? key,
        required this.selected,
        required this.action,
        required this.text,
        this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        action();
      },
      child: Column(
        children: [
          Center(
            child: AutoSizeText(text,
                maxLines: 1,
                style: Styles.heading3(context).copyWith(
                    color: selected ? Styles.appSecondaryColor : Colors.grey)),
          ),
          const SizedBox(
            height: 2,
          ),
          Container(
            height: 5,
            color: selected ? Styles.appSecondaryColor : Colors.transparent,
          )

        ],
      ),
    );
  }
}
