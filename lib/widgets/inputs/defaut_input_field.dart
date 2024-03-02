import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/utils/size_utils2.dart';

class DefaultInputField extends StatelessWidget {
  final String? hintText;
  final Widget? prefix;
  final bool password;
  final bool isroundedPrefix;
  final bool hide;
  final Function? toggleHide;
  final bool textCenter;
  final Widget? suffix;
  final bool enabled;
  final bool inputtype;
  final double? height;
  final String title;
  final bool hasTitle;
  final dynamic validator;
  final dynamic onSaved;
  final Function()? onTap;
  final Function(String value)? onChanged;
  final bool? readOnly;
  final String? initVal;
  final TextEditingController? textEditingController;
  final BorderRadius? borderRadius;
  var inputFormatters;

  DefaultInputField(
      {Key? key,
      required this.title,
      this.hintText,
      this.height,
      this.prefix,
      this.inputtype = false,
      this.password = false,
      this.isroundedPrefix = true,
      this.hasTitle = true,
      this.hide = false,
      this.toggleHide,
      this.validator,
      this.onSaved,
      this.onChanged,
      this.onTap,
      this.inputFormatters,
      this.textCenter = false,
      this.suffix,
      this.textEditingController,
      this.borderRadius,
      this.enabled = true,
      this.readOnly,
      this.initVal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hasTitle
              ? Text(
                  title,
                  style: Styles.heading3(context)
                      .copyWith(color: Colors.black54),
                )
              : Container(),
          const SizedBox(
            height: 8,
          ),
          Container(
            margin: EdgeInsets.only(top: 0.h),
            height:
                Responsive.isMobile(context) ? height ?? 65.h : height ?? 65.h,
            child: TextFormField(
              //autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: textEditingController,
              cursorColor: Styles.appPrimaryColor,
              validator: validator,
              onSaved: onSaved,
              onChanged: onChanged,
              onTap: onTap,

              initialValue: initVal,
              readOnly: readOnly ?? false,
              inputFormatters: inputFormatters,

              keyboardType: inputtype == true ? TextInputType.phone : null,
              style: TextStyle(
                fontSize: Responsive.isMobile(context) ? 16.sp : 16.sp,
                color: Colors.black54,
              ),

              textAlign: textCenter ? TextAlign.center : TextAlign.start,
              obscureText: hide,

              decoration: InputDecoration(
                errorStyle: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 10 : 6.sp,
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: Responsive.isMobile(context) ? 2 : 10.sp,
                    horizontal: 10.sp),
                suffixIcon: suffix,
                prefixIcon: prefix,
                //constraints: BoxConstraints(minHeight: 55.h, maxHeight: 70.h),
                enabled: enabled,
                helperText: "",
                hintText: hintText,
                hintStyle:
                    Styles.heading3(context).copyWith(color: Colors.black26),
                fillColor: Colors.grey.withOpacity(.1),
                filled: readOnly ?? false,
                border: OutlineInputBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                    borderSide:
                        BorderSide(color: Colors.grey.shade400, width: .7.h)),
                errorBorder: OutlineInputBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                    borderSide: BorderSide(width: 0.7.h)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey, width: 0.7.h)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                    borderSide:
                        BorderSide(color: Colors.grey.shade400, width: 0.7.h)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey, width: 0.9.h)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
