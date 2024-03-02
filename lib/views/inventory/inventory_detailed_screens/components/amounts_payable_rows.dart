import 'package:flutter/material.dart';

class AmountsPayableRow extends StatelessWidget {
  final String amount;
  final String title;
  const AmountsPayableRow({Key? key, required this.amount, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Text(
          amount.toString(),
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
