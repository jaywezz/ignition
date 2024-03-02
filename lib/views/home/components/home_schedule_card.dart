import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/customer_checking_controller.dart';
import 'package:soko_flow/controllers/customer_provider.dart';
import 'package:soko_flow/models/customer_model/customer_model.dart';
import 'package:soko_flow/models/route_schedule_model.dart';
import 'package:soko_flow/views/customers/components/customer_details.dart';
import 'package:soko_flow/views/customers/map_view.dart';

import '../../../models/customer_checkin.dart';

class HomeScheduleCard extends ConsumerStatefulWidget {
  final UserRouteModel todaySchedules;
  const HomeScheduleCard({Key? key, required this.todaySchedules}) : super(key: key);

  @override
  ConsumerState<HomeScheduleCard> createState() => _HomeScheduleCardState();
}

class _HomeScheduleCardState extends ConsumerState<HomeScheduleCard> {
  var startDate = DateTime.now();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final customersProvider = ref.watch(customerNotifierProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 5.0.sp),
      child: Container(
        width:
        MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Styles.appSecondaryColor,
            borderRadius: BorderRadius.all(
                Radius.circular(10.sp))),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 15.0.sp,
              vertical: 5.sp),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.todaySchedules.customerName!,
                    style: Styles.heading3(context).copyWith(color: Colors.white),
                  ),
                  Align(
                    alignment:
                    Alignment.centerRight,
                    child: isLoading? SizedBox(height: 15, width: 15, child: CircularProgressIndicator(
                      strokeWidth: 2,
                      backgroundColor: Colors.black26,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Styles.appPrimaryColor, //<-- SEE HERE
                      ),
                    ),):PopupMenuButton<int>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 20,
                      ),
                      itemBuilder: (context) =>
                      [
                        PopupMenuItem(
                          value: 1,
                          // row with 2 children
                          child: Row(
                            children: [
                              Icon(Icons.pedal_bike, color: Styles.appYellowColor),
                              const SizedBox(
                                width: 10,
                              ),
                              Text("Visit Customer", style: Styles.heading4(context),
                              )
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          // row with 2 children
                          child: Row(
                            children: [
                              Icon(Icons.map, color: Styles.appYellowColor),
                              const SizedBox(
                                width: 10,
                              ),
                              Text("View on Map", style: Styles.heading4(context),
                              )
                            ],
                          ),
                        ),
                        // PopupMenuItem(
                        //   value: 3,
                        //   // row with 2 children
                        //   child: Row(
                        //     children: [
                        //       Icon(Icons.event, color: Styles.appYellowColor,),
                        //       const SizedBox(
                        //         width: 10,
                        //       ),
                        //       Text("Reschedule", style: Styles.heading4(context),)
                        //     ],
                        //   ),
                        // ),
                      ],
                      offset: const Offset(0, 40),
                      color: Colors.white,
                      elevation: 2,
                      // on selected we show the dialog box
                      onSelected: (value) async {
                        setState(() {
                          isLoading = true;
                        });
                        print("on click ${widget.todaySchedules.account}");
                        CustomerDataModel customer = CustomerDataModel(
                          id: int.parse(widget.todaySchedules.account.toString()),
                          customerName: widget.todaySchedules.customerName!,
                          latitude: widget.todaySchedules.latitude,
                          longitude: widget.todaySchedules.longitude,
                          phoneNumber: widget.todaySchedules.telephone,
                          email: widget.todaySchedules.email,
                        );
                        // if value 1 show dialog
                        if (value == 1) {
                          var checkinController = Get.find<CustomerCheckingController>();
                          Position position = await customersProvider.getGeoLocationPosition();

                          String cstIndex =
                          widget.todaySchedules.account.toString();
                          print('index: $cstIndex');
                          print(cstIndex.runtimeType);
                          CustomerCheckinModel
                          checkinCode = await checkinController.createCheckinSession(
                            // "${controller.lstcustomers[index].id!.toString()}",
                              position.latitude.toString(),
                              position.longitude.toString(),
                              // "4158",
                              cstIndex,
                              "xtUxiU");
                          await checkinController.addCheckingData(checkinCode.checkingCode!,
                            widget.todaySchedules.account!,
                            widget.todaySchedules.customerName!,
                            widget.todaySchedules.address!,
                            widget.todaySchedules.email ?? "",
                            widget.todaySchedules.telephone!,
                            widget.todaySchedules.latitude ?? "0.0",
                            widget.todaySchedules.longitude ?? "0.0",
                            // widget.todaySchedules.customerName?? ""
                          );
                          Get.to(CustomerDetailsScreen(customer: customer));
                        }
                        if (value == 2) {
                          Get.to(
                              CustomerMapView(customer: [customer]));
                        }
                        if (value == 3) {}
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.todaySchedules.name!, style: Styles.heading4(context).copyWith(color: Colors.white70),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${DateFormat.Hm().format(startDate)}"
                            " - ${DateFormat.Hm().format(DateTime(startDate.year, startDate.month, startDate.day, startDate.hour, startDate.minute + 30))}",
                        style: Styles.heading4(context).copyWith(color: Colors.white),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
