// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:soko_flow/configs/styles.dart';

class ChatTextField extends StatelessWidget {
  String? title;
  TextEditingController? textEditingController;
  double? width;
  Widget? preIcon;
  double? height;
  Widget? suffixIcon;
  String? hintText;
  double? radius;
  bool? enabled;
  ChatTextField(
      {Key? key,
      this.radius,
      this.title,
      this.preIcon,
      this.enabled,
      this.hintText,
      this.suffixIcon,
      this.height,
      this.textEditingController,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 354,
      height: height ?? 95,
      child: TextFormField(
        controller: textEditingController,
        style: Theme.of(context).primaryTextTheme.bodyMedium!.copyWith(
              fontSize: 16,
              color: Styles.deepGreyColor,
              fontWeight: FontWeight.w400,
            ),
        decoration: InputDecoration(
          fillColor: Theme.of(context).primaryColor,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0XFFE6E6E6)),
              borderRadius: BorderRadius.circular(radius ?? 0)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0XFFE6E6E6)),
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 0.0)),
          ),
          prefixIcon: preIcon,
          suffixIcon: suffixIcon,
          //enabled: enabled ?? false,
          hintText: hintText,
          prefixIconColor: Color(0XFFA4A5A9),
          hintStyle: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
              fontSize: 14,
              color: Styles.deepGreyColor.withOpacity(0.1),
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
