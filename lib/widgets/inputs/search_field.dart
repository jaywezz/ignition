import 'package:flutter/material.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/utils/size_utils2.dart';

class LargeSearchField extends StatelessWidget {
  final String? hintText;
  //Coder Pass
  final bool outline;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final IconData? suffixIcon;
  final bool isleadingIcon;
  final TextEditingController? controller;
  final void Function(String value)? onChanged;
  final void Function()? onTap;

  const LargeSearchField({
    Key? key,
    this.hintText,
    this.outline = false,
    this.leadingIcon,
    this.suffixIcon,
    this.isleadingIcon = false,
    this.trailingIcon,
    this.onChanged,
    this.onTap,
    this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity - (defaultPadding(context) * (1.2 * 2)),
      height: Responsive.isMobile(context) ? 60 : 75,
      child: TextFormField(
        onTap: onTap,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 100),
          hintText: hintText ?? "Search ",
          hintStyle: Styles.normalText(context).copyWith(color: Colors.grey),
          prefixIcon: Container(
            decoration: BoxDecoration(
              color: isleadingIcon ? Styles.appYellowColor : null,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(leadingIcon ?? Icons.search_sharp,
                  color: isleadingIcon ? Colors.white : Colors.black,
                  size: Responsive.isMobile(context) ? 20 : 30),
            ),
            margin: EdgeInsets.only(left: 20, right: defaultPadding(context)),
          ),
          suffixIcon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(suffixIcon ?? null,
                  color: Colors.black26,
                  size: Responsive.isMobile(context) ? 30 : 40),
            ),
            margin: EdgeInsets.only(left: 20, right: defaultPadding(context)),
          ),
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(defaultRadius1 * 3),
                bottomLeft: Radius.circular(defaultRadius1 * 3)),
            borderSide: BorderSide(
                color: outline ? Colors.grey.shade300 : Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(defaultRadius1 * 3)),
            borderSide: BorderSide(
                width: 2,
                color: outline ? Colors.black.withOpacity(0.3) : Colors.white),
          ),
          filled: true,
        ),
        expands: false,
        maxLines: 1,
        minLines: 1,
      ),
    );
  }
}
