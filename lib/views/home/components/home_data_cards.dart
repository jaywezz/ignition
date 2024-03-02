import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/utils/size_utils2.dart';

class DataCard extends StatefulWidget {
  final Color leadingColor;
  final Widget icon;
  final String cardName;
  final String targets;
  final String achieved;
  final String percentage;

  const DataCard(
      {Key? key,
      required this.leadingColor,
      required this.icon,
      required this.cardName,
      required this.targets,
      required this.achieved,
      required this.percentage})
      : super(key: key);

  @override
  State<DataCard> createState() => _DataCardState();
}

class _DataCardState extends State<DataCard> {
  double percentage = 0.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.isTablet(context)? 13:10.0.sp),
      child: Container(
        // height: 90,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            offset: const Offset(
              5.0,
              5.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ), //BoxShadow
          BoxShadow(
            color: Colors.white,
            offset: const Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ), //BoxShadow
        ], borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: 75.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  color: widget.leadingColor,
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0.sp),
                  child: Column(
                    children: [
                      widget.icon,
                      AutoSizeText(
                        widget.cardName,
                        style: Styles.heading4(context)
                            .copyWith(color: Colors.white),
                      )
                    ],
                  ),
                )),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 9.0.sp, vertical: 10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText("Targets",
                      style: Styles.heading2(context)
                          .copyWith(color: Colors.black54)),
                  SizedBox(
                    height: 6.h,
                  ),
                  AutoSizeText(widget.targets,
                      style: Styles.heading4(context)
                          .copyWith(color: Colors.grey.shade700))
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0.sp),
              child: VerticalDivider(
                color: Colors.black26,
                thickness: 2,
              ),
            ),

            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 10.0.sp, vertical: 15.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText("Achieved",
                      style: Styles.heading4(context)
                          .copyWith(color: Colors.black54)),
                  SizedBox(
                    height: 6.h,
                  ),
                  AutoSizeText(widget.achieved,
                      style: Styles.heading4(context)
                          .copyWith(color: Colors.grey.shade700))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
              child: Text(
                "(${widget.percentage} %)",
                style: Styles.heading4(context).copyWith(color: Colors.black54),
              ),
            )
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
            //   child: Container(
            //       decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           border: Border.all(color: widget.leadingColor, width: 2.w)
            //       ),
            //       child: Icon(Icons.arrow_forward, size: 17.sp, color: widget.leadingColor,)),
            // )
          ],
        ),
      ),
    );
  }
}
