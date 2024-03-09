import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soko_flow/utils/size_utils2.dart';

class Styles {
  //colors
  static Color appPrimaryColor = const Color(0xFFF44F22);
  static Color appSecondaryColor = const Color(0xFF162743);
  static Color appSecondaryColorLight = const Color(0xFFFFCACF);
  static Color appYellowColor = const Color(0xFFFED700);
  static Color appPurpleColor = const Color(0xFFF44F22);
  static Color appbrownColor = const Color(0xFF803914);
  static Color appGreenColor = const Color(0xFFffCF45);
  static Color appButtonColor = const Color.fromARGB(255, 139, 19, 10);

  static Color deepBlueColor = const Color(0XFF092C4C);
  static Color inputFillColor = const Color(0XFFF2F5FF);
  static Color greyColor = const Color(0XFFA0A0A0);
  static Color blueishColor = const Color(0XFF0071BC);
  static Color deepGreyColor = Color(0XFF707070);

  //add background color
  static Color appBackgroundColor = const Color(0xFFE9E9E9); //for main app
  static Color appBackgroundColor2 = const Color(0xFFF9F6FF); //for welcome
  static Color appBackgroundColor3 = const Color(0xFFEAEBEE); // auth pages
  static Color darkGrey = const Color(0xFF000000); // auth pages

  //widget colors
  static Color cardColor = Colors.white;
  static Color authBackgroundColor = const Color(0xFFF3F2F6);

  static Color defaultInputFieldColor = Colors.grey;
  static Color activeInputFieldColor = appPrimaryColor;

  static Color graphDarkColor = const Color(0xFF15807a);
  static Color graphLightColor = const Color(0xFF15807a).withOpacity(.2);

  //texts

  //headings
  static TextStyle display5(BuildContext context) {
    return GoogleFonts.openSans(
        textStyle: TextStyle(
            color: darkGrey,
            fontSize: Responsive.isTablet(context)
                ? 18.sp
                : (Responsive.isMobileLarge(context) ? 18.sp : 26.sp),
            fontWeight: FontWeight.w600));
  }

  static TextStyle heading1(BuildContext context) {
    return GoogleFonts.openSans(
       textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
         color: darkGrey,
             // fontSize: Responsive.isTablet(context)
             //     ? 16.sp
             //     : (Responsive.isTall(context) ? 18.sp : 24.sp),
             fontWeight: FontWeight.w600
       )
        // textStyle: TextStyle(
        //     color: darkGrey,
        //     fontSize: Responsive.isTablet(context)
        //         ? 16.sp
        //         : (Responsive.isTall(context) ? 18.sp : 24.sp),
        //     fontWeight: FontWeight.w600)
    );
  }

  static TextStyle heading2(BuildContext context) {
    return GoogleFonts.openSans(
      textStyle:  Theme.of(context).textTheme.titleMedium!.copyWith(
        color: darkGrey,
            // fontSize: Responsive.isTablet(context)
            //     ? 12.sp
            //     : (Responsive.isTall(context) ? 12.sp : 18.sp),
            fontWeight: FontWeight.bold
      )
        // textStyle: TextStyle(
        //     color: darkGrey,
        //     fontSize: Responsive.isTablet(context)
        //         ? 12.sp
        //         : (Responsive.isTall(context) ? 12.sp : 18.sp),
        //     fontWeight: FontWeight.bold)
    );
  }

  static TextStyle heading3(BuildContext context) {
    return heading2(context).copyWith(
      fontSize: Responsive.isTablet(context)
          ? 10.sp
          : (Responsive.isTall(context) ? 14.sp : 13.sp),
    );
  }

  static TextStyle heading4(BuildContext context) {
    return heading2(context).copyWith(
      fontSize: Responsive.isTablet(context)
          ? 10.sp
          : (Responsive.isTall(context) ? 13.sp : 12.sp),
    );
  }

  static TextStyle normalText(BuildContext context) {
    return GoogleFonts.openSans(
      textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Colors.grey.shade900,
      )
    //     textStyle: TextStyle(
    //   color: Colors.grey.shade900,
    //   fontSize: Responsive.isTablet(context)
    //       ? 13.sp
    //       : (Responsive.isTall(context) ? 15.sp : 15.sp),
    // )
    );
  }

  static TextStyle smallGreyText(BuildContext context) {
    return GoogleFonts.openSans(
      textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
        color: Colors.grey.shade700,
      )
    //     textStyle: TextStyle(
    //   color: Colors.grey.shade700,
    //   fontSize: Responsive.isTablet(context)
    //       ? 15.sp
    //       : (Responsive.isTall(context) ? 14.sp : 15.sp),
    // )
    );
  }

  static TextStyle buttonText1(BuildContext context) {
    return heading2(context)
        .copyWith(color: Colors.white, fontWeight: FontWeight.normal);
  }

  static TextStyle buttonText2(BuildContext context) {
    return heading2(context)
        .copyWith(color: Colors.white, fontWeight: FontWeight.w700);
  }

  static TextStyle bttxt1(BuildContext context) {
    return heading3(context).copyWith(
      color: Styles.appSecondaryColor,
      fontSize: Responsive.isTablet(context)
          ? 11.sp
          : (Responsive.isTall(context) ? 13.sp : 13.sp),
    );
  }

  static TextStyle bttxt2(BuildContext context) {
    return heading3(context).copyWith(
      color: Styles.appBackgroundColor,
      fontSize: Responsive.isTablet(context)
          ? 11.sp
          : (Responsive.isTall(context) ? 14.sp : 14.sp),
    );
  }
}
