import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soko_flow/configs/styles.dart';

//import 'package:flutter_form_builder/flutter_form_builder.dart';



class FormDropDownField extends StatelessWidget {
  final String value;
  final String title;
  final String? hintText;
  final List<String> itemsLists;
  final void Function(String? value) onChanged;
  Color? fillColor;
  FormDropDownField({Key? key, required this.value, required this.title, this.hintText, required this.onChanged, required this.itemsLists}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Styles.heading3(context).copyWith(color: Colors.black54),
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          height: 40.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white, //background color of dropdown button
              border: Border.all(
                  color: Styles.greyColor
                      .withOpacity(.3)), //border of dropdown button
              borderRadius: BorderRadius.circular(10.sp),
            ),
            child: DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              hint: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_drop_down),
                  ),
                ],
              ), // Not necessary for Option 1
              style: Styles.heading1(context),
              value: value,
              onChanged: onChanged,
              items: itemsLists.map((String? value) {
                return DropdownMenuItem(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      value!,
                      style: Styles.heading3(context)
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                );
              }).toList(),
              icon: const Padding(
                //Icon at tail, arrow bottom is default icon
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Icon(Icons.keyboard_arrow_down)),
            ),
          ),
        ),
      ],
    );
  }
}
