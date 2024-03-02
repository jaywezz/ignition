import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/components/customer_details.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../views/customers/components/edit_customer_details.dart';
import '../../views/customers/drive_to_customer.dart';
//import 'package:soko_flow/views/customers/customer_details.dart';

class CustomerListCard extends StatefulWidget {
  CustomerListCard(
      {Key? key,
      this.children,
      this.action,
      this.trackingaction,
      this.phoneNumber,
      this.isCurrentCustomer,
        required this.hasGeoData,
      this.isCloseCustomer,
        required this.distance
      })
      : super(key: key);
  var children;
  var action;
  var phoneNumber;
  var isCurrentCustomer;
  var isCloseCustomer;
  var trackingaction;
  bool hasGeoData;
  double distance;

  @override
  State<CustomerListCard> createState() => _CustomerListCardState();
}

class _CustomerListCardState extends State<CustomerListCard> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    // print("has geo data: $hasGeoData");
    return GestureDetector(
      onTap: () async{
        setState(() {
          isLoading = true;
        });
        await widget.action();
        setState(() {
          isLoading = false;
        });

        // Navigate.instance.toRoute(const CustomerDetailsScreen());
      },
      child: Card(
        elevation: 5,
        child: Container(
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: Responsive.isMobile(context) ? 70.h : 60.h,
                child: Center(
                  child: Text(
                    widget.children[0],
                    style: Styles.buttonText2(context),
                  ),
                ),
                width: Responsive.isMobile(context) ? 60.w : 60.w,
                decoration: BoxDecoration(
                    color: widget.isCloseCustomer
                        ? Styles.appYellowColor
                        : widget.isCurrentCustomer||widget.distance < 0.5
                            ? Colors.green
                            : Colors.grey,
                    borderRadius:
                        BorderRadius.circular(defaultPadding(context))),
              ),
              Flexible(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.children[1],
                        overflow: TextOverflow.ellipsis,
                        style: Styles.heading3(context),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.children[2],
                        style: Styles.smallGreyText(context)
                            .copyWith(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 3,
                  ),
                isLoading?Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        backgroundColor: Colors.black26,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Styles.appPrimaryColor, //<-- SEE HERE
                        )),
                  ),
                ): widget.hasGeoData?IconButton(
                      onPressed: () {
                        widget.trackingaction();
                      },
                      icon: Icon(
                        Icons.directions_outlined,
                        color: Color(0XFFB01E68),
                      )):IconButton(
                      onPressed: () {
                        Get.to(EditDetailsScreen());
                      },
                      icon: Icon(
                        Icons.warning_amber_outlined,
                        color: Colors.red,
                        size: 17,
                      )),
                  GestureDetector(
                      onTap: () async {
                        print("calling");
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path: widget.phoneNumber,
                        );
                        await launchUrl(launchUri);
                        // var whatsapp = "+254799005059";
                        // var whatsappURl_android = "whatsapp://send?phone=" +
                        //     whatsapp +
                        //     "&text=hello";
                        // var whatappURL_ios =
                        //     "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
                        // if (Platform.isIOS) {
                        //   // for iOS phone only
                        //   if (await canLaunch(whatappURL_ios)) {
                        //     await launch(whatappURL_ios,
                        //         forceSafariVC: false);
                        //   } else {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //         SnackBar(
                        //             content:
                        //                 new Text("whatsapp no installed")));
                        //   }
                        // } else {
                        //   // android , web
                        //   if (await canLaunch(whatsappURl_android)) {
                        //     await launch(whatsappURl_android);
                        //   } else {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //         SnackBar(
                        //             content:
                        //                 new Text("whatsapp no installed")));
                        //   }
                        // }
                      },
                      child: Icon(
                        Icons.call,
                        color:  Color(0XFFB01E68),
                      ))
                ],
              )
            ],
          ),
          padding: EdgeInsets.all(defaultPadding(context) * 0.2),
          width: double.infinity,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultPadding(context))),
      ),
    );
  }
}
