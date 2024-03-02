import 'package:flutter/material.dart';

import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/utils/size_utils.dart';
import 'package:soko_flow/utils/size_utils2.dart';

class DefaultInputField extends StatelessWidget {
  final String? hintText;
  //final String? labelText;
  final Widget? prefix;
  final bool password;
  final bool hide;
  final Function? toggleHide;
  final bool textCenter;
  final Widget? suffix;
  final bool enabled;
  final bool inputtype;
  var validator;
  var onsave;
  var controller;

  DefaultInputField(
      {Key? key,
      this.hintText,
      //this.labelText,
      this.prefix,
      this.inputtype = false,
      this.password = false,
      this.hide = true,
      this.toggleHide,
      this.textCenter = false,
      this.suffix,
      this.onsave,
      this.validator,
      this.controller,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive.isMobile(context) ? 50 : 60,
      //SizeConfig.isTabletWidt
      //h ? 60 : 50,
      child: TextFormField(
        controller: controller,
        keyboardType: inputtype == true ? TextInputType.phone : null,
        style: Styles.normalText(context),
        textAlign: textCenter ? TextAlign.center : TextAlign.start,
        obscureText: hide,
        validator: validator,
        onSaved: onsave,
        decoration: InputDecoration(
          //labelText: labelText,
          enabled: enabled,
          prefixIcon: prefix,
          hintText: hintText,
          suffixIcon: suffix ??
              (password
                  ? IconButton(
                      icon: Icon(
                        hide ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        toggleHide!();
                      },
                    )
                  : null),
          border: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Styles.defaultInputFieldColor, width: 1)),
          focusColor: Styles.defaultInputFieldColor,
          // disabledBorder: InputBorder.none,
          // enabledBorder: UnderlineInputBorder(
          //     borderSide:
          //         BorderSide(color: Styles.defaultInputFieldColor, width: 1)),
          // OutlineInputBorder(
          // borderRadius: BorderRadius.circular(defaultRadius1),
          // borderSide:
          //     BorderSide(color: Styles.defaultInputFieldColor, width: .7)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: Styles.defaultInputFieldColor, width: 0.7)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: Styles.defaultInputFieldColor, width: 0.7)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: Styles.appPrimaryColor, width: 0.9)),
        ),
      ),
    );
  }
}
