import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:soko_flow/configs/constants.dart';

import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/find_me.dart';
import 'package:soko_flow/data/providers/deliveries/deliveries_provider.dart';
import 'package:soko_flow/models/derivery_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/currency_formatter.dart';
import 'package:soko_flow/views/customers/drive_to_customer.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/receive_stock/receive_stock_details_screen.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:soko_flow/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'detailed_delivery/detailed_delivery_screen.dart';

final deliveryTypeProvider = StateProvider<DeliveryTypes>((ref) => DeliveryTypes.Accepted);

class DeliveryScreen extends ConsumerStatefulWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends ConsumerState<DeliveryScreen> {
  List<DeliveriesModel> selectedDeliveries = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: selectedDeliveries.isEmpty
            ? SizedBox()
            : Container(
          height: MediaQuery.of(context).size.height * .1,
          padding: EdgeInsets.only(
              left: defaultPadding(context),
              right: defaultPadding(context),
              bottom: defaultPadding(context)),
          child: Column(children: [
            ref.watch(deliveriesNotifierProvider).isLoading
                ? CircularProgressIndicator()
                : FullWidthButton(
              action: () async {
                Get.to(ReceiveStockItems(deliveries: selectedDeliveries));
              },
              child: Text(
                "Next ( ${selectedDeliveries.length} Selected)",
                style: Styles.heading3(context)
                    .copyWith(color: Colors.white),
              ),
              // text: "Accept ${selectedDeliveries.length} Deliveries",
            ),
          ]),
        ),
        body: SafeArea(
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Container(
                padding: EdgeInsets.only(
                    left: defaultPadding(context),
                    right: defaultPadding(context),
                    bottom: defaultPadding(context)),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
                    borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(30))),
                child: Column(
                  children: [
                    SizedBox(
                      height: defaultPadding(context),
                    ),
                    Stack(
                      children: [
                        Material(
                          child: InkWell(
                            splashColor:
                            Theme.of(context).splashColor,
                            onTap: () {
                              Get.back();
                              // Get.back();
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Styles.darkGrey,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Deliveries',
                            style: Styles.heading2(context),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Material(
                            child: InkWell(
                              splashColor:
                              Theme.of(context).splashColor,
                              onTap: () =>
                                  Get.toNamed(RouteHelper.getInitial()),
                              child: Icon(
                                Icons.home_sharp,
                                size: defaultPadding(context) * 2,
                                color: Styles.appSecondaryColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: defaultPadding(context) * 1.3,
                    ),
                    SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.sp)
                          ),
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                action: () {
                                  ref.read(deliveryTypeProvider.state).state = DeliveryTypes.Accepted;
                                },
                                text: 'Accepted',
                                isSelected:  ref.watch(deliveryTypeProvider) == DeliveryTypes.Accepted,
                              ),
                              CustomButton(
                                action: () {
                                  ref.read(deliveryTypeProvider.state).state = DeliveryTypes.UnAccepted;
                                },
                                text: 'Unaccepted',
                                isSelected:  ref.watch(deliveryTypeProvider) == DeliveryTypes.UnAccepted,
                              ),

                              // CustomButton(
                              //   action: () {
                              //     ref.read(routesTypeProvider.state).state = ScheduleTypes.Routes;
                              //     ref.read(userRoutesNotifierProvider.notifier).filterUserRoutes();
                              //   },
                              //   text: 'Route',
                              //   isSelected: ref.watch(routesTypeProvider.state).state == ScheduleTypes.Routes,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),


                    ref.read(deliveryTypeProvider.state).state == DeliveryTypes.Accepted?ref.watch(acceptedDeliveriesProvider).when(data: (data){
                      if(data.isEmpty){
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("No deliveries", style: Styles.heading3(context).copyWith(color: Colors.black54)),
                          ),
                        );
                      }
                      return Expanded(
                          child: RefreshIndicator(
                            onRefresh: ()async{
                              return await ref.refresh(deliveriesProvider);
                            },
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:data.length,
                                // mydeliveries.length,
                                itemBuilder: (context, index) {
                                  double totalPrice = 0;
                                  data[index].deliveryItems.forEach((item) {
                                    totalPrice += double.parse(item.sellingPrice!) * double.parse(item.allocatedQuantity!);
                                  });

                                  return GestureDetector(
                                      onTap: () {
                                        Get.to(
                                            DetailedDeliveryScreen(delivery: data[index], initialScreen: 'user_deliveries',));
                                      },
                                      child: Card(
                                        elevation: 2,
                                        child: Container(
                                          child: Row(
                                            //crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                flex: 5,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.only(left: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(data[index].customer.customerName!, style: Styles.heading3(context),
                                                      ),
                                                      const SizedBox(height: 10,),
                                                      Text(data[index].deliveryNote ?? "No info..", style: Styles.smallGreyText(context),
                                                        maxLines: 3,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text("Kshs. ${formatCurrency.format(totalPrice)}", style: Styles.heading3(context).copyWith(color: Styles.appYellowColor),
                                                        maxLines: 3,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: Padding(padding: const EdgeInsets.only(left: 5),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(1.0),
                                                          child: data[index].deliveryStatus == "CANCELLED"
                                                              ? Text(
                                                            "Cancelled",
                                                            style: Styles.heading4(context)
                                                                .copyWith(color: Colors.redAccent),
                                                          )
                                                              : data[index].deliveryStatus == "Partial delivery"
                                                              ? Text(
                                                            "Partial",
                                                            style: Styles.heading4(context).copyWith(
                                                                color: Styles.appSecondaryColor),
                                                          )
                                                              :data[index].deliveryStatus== "DELIVERED"
                                                              ? Text(
                                                            "Delivered",
                                                            style: Styles.heading4(context)
                                                                .copyWith(color: Colors.white),
                                                          )
                                                              : Text(
                                                            "Pending",
                                                            style: Styles.heading4(context)
                                                                .copyWith(color: Colors.grey),
                                                          ),
                                                        ),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(5.sp)),
                                                            color: data[index].deliveryStatus == "CANCELLED"
                                                                ? Colors.redAccent.withOpacity(.3)
                                                                : data[index].deliveryStatus == "Partial delivery"
                                                                ? Styles.appSecondaryColor.withOpacity(.3)
                                                                : data[index].deliveryStatus == "DELIVERED"
                                                                ? Colors.green
                                                                : Colors.grey.withOpacity(.3)),
                                                      ),
                                                      // const SizedBox(
                                                      //   height: 30,
                                                      // ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                ref.watch(findMeProvider).whenData((value) {
                                                                  Navigator.of(context).push(
                                                                      MaterialPageRoute(builder: (context) =>
                                                                          CustomerTrackingPage(
                                                                            shopName:  data[index].customer.customerName!,
                                                                            sourceLocation: LatLng(value.latitude, value.longitude),
                                                                            destination: LatLng(double.parse(data[index].customer.latitude!), double.parse(data[index].customer.longitude!)),
                                                                          )));
                                                                });

                                                              },
                                                              icon: Icon(
                                                                Icons.directions_outlined,
                                                                size: 17,
                                                                color: Color(0XFFB01E68),
                                                              )),
                                                          GestureDetector(
                                                              onTap: () async {
                                                                print("calling");
                                                                final Uri launchUri = Uri(
                                                                  scheme: 'tel',
                                                                  path: data[index].customer.phoneNumber,
                                                                );
                                                                await launchUrl(launchUri);
                                                              },
                                                              child: Icon(
                                                                Icons.call,
                                                                size: 17,
                                                                color:  Color(0XFFB01E68),
                                                              )),
                                                        ],
                                                      ),

                                                      Text(
                                                        DateFormat.yMMMEd().format( data[index].createdAt).toString(),
                                                        style: Styles.heading4(context).copyWith(color: Colors.black),
                                                        maxLines: 3,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(
                                              defaultPadding(context) *
                                                  0.2),
                                          width: double.infinity,
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                      )
                                  );
                                }),
                          )
                        // child: DeliveryList(),
                      );
                    }, error: (error, stackTrace) => Text("An error occurred, try again later", style: Styles.heading3(context),), loading: (){
                      return CircularProgressIndicator();
                    }):ref.watch(deliveriesProvider).when(data: (data){
                      data = data.where((element) =>  element.deliveryStatus ==  "Waiting acceptance").toList();
                      for(DeliveriesModel delivery in data){
                        print("status2: ${delivery.deliveryStatus}");
                      }
                      if(data.isEmpty){
                        return RefreshIndicator(
                          onRefresh: ()async{
                            return await ref.refresh(deliveriesProvider);
                          },
                          child: ListView(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("No deliveries to accept", style: Styles.heading3(context).copyWith(color: Colors.black54)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }else{

                        return Expanded(
                          child: RefreshIndicator(
                            onRefresh: ()async{
                              return await ref.refresh(deliveriesProvider);
                            },
                            child: ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:data.length,
                                itemBuilder: (context, index) {
                                  double totalPrice = 0;
                                  data[index].deliveryItems.forEach((item) {
                                    totalPrice += double.parse(item.sellingPrice!) * double.parse(item.allocatedQuantity!);
                                  });
                                  return GestureDetector(
                                      onTap: () {
                                        print("clicked");
                                        if (selectedDeliveries.isEmpty) {
                                          Get.to(ReceiveStockItems(deliveries: [data[index]]));
                                        } else {
                                          if(selectedDeliveries.contains(data[index])) {
                                            print("removing");
                                            selectedDeliveries.remove(data[index]);
                                          } else {
                                            print("adding");
                                            selectedDeliveries.add(data[index]);
                                          }
                                        }
                                        setState(() {});
                                      },
                                      onLongPress: () {
                                        if(selectedDeliveries.contains(data[index])){
                                          //  Do nothing
                                        }else{
                                          selectedDeliveries.add(data[index]);
                                          setState(() {});
                                        }
                                      },
                                      child: Card(
                                        color: selectedDeliveries.contains(data[index])
                                            ? Styles.appSecondaryColor.withOpacity(.2)
                                            : null,
                                        elevation: 2,
                                        child: Container(
                                          child: Row(
                                            //crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                flex: 5,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const SizedBox(height: 10),
                                                      Row(
                                                        children: [
                                                          Text(data[index].customer.customerName!, style: Styles.heading3(context).copyWith(color:  selectedDeliveries.contains(data[index])?Colors.white:Colors.black),
                                                          ),
                                                          SizedBox(width: 10,),
                                                          data[index].type == "Van_sale"?Icon(
                                                            Icons.fire_truck,
                                                            color: Styles.appSecondaryColor,
                                                            size: 17,
                                                          ):Icon(
                                                            Icons.warehouse,
                                                            color: Styles.appSecondaryColor,
                                                            size: 17,
                                                          )

                                                        ],
                                                      ),
                                                      const SizedBox(height: 10,),
                                                      Text(data[index].deliveryNote ?? "No info..", style: Styles.smallGreyText(context).copyWith(color:  selectedDeliveries.contains(data[index])?Colors.white:Colors.black),
                                                        maxLines: 3,
                                                      ),
                                                      SizedBox(height: 5.h,),

                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text("Kshs. ${formatCurrency.format(totalPrice)}", style: Styles.heading3(context).copyWith(color: Styles.appYellowColor),
                                                        maxLines: 3,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: Padding(padding: const EdgeInsets.only(left: 5),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Row(
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  ref.watch(findMeProvider).whenData((value) {
                                                                    Navigator.of(context).push(
                                                                        MaterialPageRoute(builder: (context) =>
                                                                            CustomerTrackingPage(
                                                                              shopName:  data[index].customer.customerName!,
                                                                              sourceLocation: LatLng(value.latitude, value.longitude),
                                                                              destination: LatLng(double.parse(data[index].customer.latitude!), double.parse(data[index].customer.longitude!)),
                                                                            )));
                                                                  });

                                                                },
                                                                icon: Icon(
                                                                  Icons.directions_outlined,
                                                                  size: 17,
                                                                  color: Color(0XFFB01E68),
                                                                )),
                                                            GestureDetector(
                                                                onTap: () async {
                                                                  print("calling");
                                                                  final Uri launchUri = Uri(
                                                                    scheme: 'tel',
                                                                    path: data[index].customer.phoneNumber,
                                                                  );
                                                                  await launchUrl(launchUri);
                                                                },
                                                                child: Icon(
                                                                  Icons.call,
                                                                  size: 17,
                                                                  color:  Color(0XFFB01E68),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        DateFormat.yMMMEd().format( data[index].createdAt).toString(),
                                                        style: Styles.heading4(context).copyWith(fontSize:10,color:  selectedDeliveries.contains(data[index])?Colors.white:Colors.black), maxLines: 3,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.all(defaultPadding(context) * 0.2), width: double.infinity,),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                10)),
                                      )
                                  );

                                  // -------------------------
                                }),
                          ),
                        );
                      }
                    }, error: (error, stackTrace) {
                      print("stack: $stackTrace");
                      return  Text(error.toString(), style: Styles.heading3(context),);
                    },loading: (){
                      return CircularProgressIndicator();
                    }),



                    //========================================
                  ],
                )
            ),
          ),
        ));
  }
}




enum DeliveryTypes {Accepted, UnAccepted}