import 'package:flutter/material.dart';

import '../../configs/constants.dart';
import '../../configs/styles.dart';

class SmallCounter extends StatefulWidget {
  const SmallCounter({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SmallCounterState();
}

class SmallCounterState extends State<SmallCounter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SmallBtn(
          action: () {
            setState(() {
              if (count != 1) count--;
            });
          },
          add: false,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text("$count", style: TextStyle(fontSize: 10))),
        SmallBtn(
          action: () {
            setState(() {
              count++;
            });
          },
        )
      ],
    );
  }
}

class SmallBtn extends StatelessWidget {
  final Function action;
  final bool add;

  const SmallBtn({Key? key, required this.action, this.add = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Center(
          child: Icon(
            add ? Icons.add : Icons.remove,
            color: Colors.white,
            size: 14,
          ),
        ),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Styles.appPrimaryColor,
            borderRadius: BorderRadius.circular(defaultRadius1 * 0.5)),
        padding: const EdgeInsets.all(4),
      ),
      onTap: () {
        action();
      },
    );
  }
}
