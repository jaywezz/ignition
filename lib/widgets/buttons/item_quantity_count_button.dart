import 'package:flutter/material.dart';

class ItemQuantityButtonCount extends StatelessWidget {
  final Function onPress;
  final IconData? icon;

  const ItemQuantityButtonCount({Key? key, required this.onPress, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        height: 19,
        width: 19,
        child: RawMaterialButton(
          constraints: BoxConstraints.tightFor(
            width: 18,
            height: 18,
          ),
          // elevation: 6.0,
          onPressed: () {
            onPress();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          fillColor: Color.fromARGB(255, 239, 239, 239),
          child: Icon(
            icon,
            color: Colors.black,
            size: 18,
          ),
        ),
      ),
    );
  }
}
