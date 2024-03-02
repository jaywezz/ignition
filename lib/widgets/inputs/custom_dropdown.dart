import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soko_flow/configs/styles.dart';

import '../../utils/size_utils2.dart';

class DefaultDropDownFiled extends StatelessWidget {
  final String value;
  final String title;
  final String? hintText;
  List<String> itemsLists;
  final void Function(String? value) onChanged;
  Color? fillColor;
  DefaultDropDownFiled(
      {Key? key,
      required this.value,
      required this.title,
      this.hintText,
      required this.itemsLists,
      required this.onChanged})
      : super(key: key);

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
          height: Responsive.isMobile(context) ? 45.h : 55.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white, //background color of dropdown button
              border: Border.all(
                  color: Styles.darkGrey
                      .withOpacity(.3)), //border of dropdown button
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: DropdownButtonFormField(
              isExpanded: true,
              decoration: InputDecoration(
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,

                // prefixIcon: Container(
                //     height: 10,
                //   width: 10,
                //   decoration: BoxDecoration(
                //     color: Styles.appYellowColor,
                //       shape: BoxShape.circle
                //   ),
                //     child: Icon(Icons.add, color: Colors.redAccent, size: 1
                //       ,)
                // ),
              ),
              hint: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_drop_down),
                  ),
                ],
              ), // Not necessary for Option 1
              style: Styles.heading1(context).copyWith(color: Colors.black54),
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
                          .copyWith(color: Colors.black45),
                    ),
                  ),
                );
              }).toList(),
              icon: const Padding(
                  //Icon at tail, arrow bottom is default icon
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black38,
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
