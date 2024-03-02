import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/constants.dart';

import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/controllers/orders_controller.dart';
import 'package:soko_flow/controllers/payment_controller.dart';
import 'package:soko_flow/data/providers/deliveries/deliveries_provider.dart';
import 'package:soko_flow/data/repository/user_deriveries_repo.dart';
import 'package:soko_flow/logic/routes/routes.dart';
import 'package:soko_flow/models/derivery_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/order_history_screen.dart';
import 'package:soko_flow/views/deliveries/detailed_delivery/components/confirm_and_deliver_screen.dart';
import 'package:soko_flow/views/deliveries/detailed_delivery/components/detailed_delivery_list.dart';
import 'package:soko_flow/views/deliveries/detailed_delivery/components/partial_delivery_widget.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/receive_stock/receive_delivery_items_widget.dart';
import 'package:soko_flow/views/product_catalogue/components/allocation_history_products.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:soko_flow/widgets/inputs/custom_dropdown.dart';

import 'package:soko_flow/widgets/inputs/search_field.dart';

class ReceiveStockItems extends ConsumerStatefulWidget {
  final List<DeliveriesModel> deliveries;
  const ReceiveStockItems({Key? key, required this.deliveries}) : super(key: key);

  @override
  ConsumerState<ReceiveStockItems> createState() => _ReceiveStockItemsState();
}

class _ReceiveStockItemsState extends ConsumerState<ReceiveStockItems> {

  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");
  List<DeliveryItemModel> deliveryItems = [];
  List<String> deliveryCodes = [];

  @override
  void initState() {
    // TODO: implement initState
    for(DeliveriesModel delivery in widget.deliveries){
      deliveryItems.addAll(delivery.deliveryItems);
      deliveryCodes.add(delivery.deliveryCode);
    }
    setState(() {});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          //color: Styles.appBackgroundColor,
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
                        splashColor: Theme.of(context).splashColor,
                        onTap: () {
                          Get.back();
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
                          splashColor: Theme.of(context).splashColor,
                          onTap: () => Get.toNamed(RouteHelper.getInitial()),
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

                Expanded(child: ReceiveDeliveryItemsWidget(orderItems:deliveryItems)),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:Container(
        height: MediaQuery.of(context).size.height * .15,
        padding: EdgeInsets.only(
            left: defaultPadding(context),
            right: defaultPadding(context),
            bottom: defaultPadding(context)),
        child: Column(
            children: [
              ref.watch(deliveriesNotifierProvider).isLoading?CircularProgressIndicator():FullWidthButton(
                action: () async{
                  await ref.watch(deliveriesNotifierProvider.notifier).acceptDelivery(deliveryCodes);
                },
                text: "Accept Deliver",
              ),

              SizedBox(height: 10,),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return RejectReasonWidget(deliveryCodes:deliveryCodes ,);
                    },
                  );
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Decline Delivery",
                      style: Styles.heading3(context).copyWith(color: Colors.redAccent),
                    ),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}

class RejectReasonWidget extends ConsumerStatefulWidget {
  final List<String> deliveryCodes;
  const RejectReasonWidget({Key? key, required this.deliveryCodes}) : super(key: key);

  @override
  ConsumerState<RejectReasonWidget> createState() => _RejectReasonWidgetState();
}

class _RejectReasonWidgetState extends ConsumerState<RejectReasonWidget> {
  bool isLoading = false;
  String cancelReason = "";
  TextEditingController detailedReasonController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text("Provide reason for rejecting delivery", style: Styles.heading3(context),)),
            SizedBox(height: 20.h,),
            DefaultDropDownFiled(
                value: "Damaged products",
                title: "Reject delivery reason",
                itemsLists:["Vehicle not in good Condition", "Wrong Products", "Wrong Quantities", "Damaged products"],
                onChanged: (value){
                  cancelReason = value!;
                }),
            SizedBox(
              height: 20.h,
            ),
            Text("Provide a Detailed Reason (Optional)", style: Styles.heading3(context),),
            SizedBox(
              height: 20.h,
            ),
            TextField(
              controller: detailedReasonController,
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 10,
              decoration: InputDecoration(
                errorStyle: TextStyle(
                  fontSize: Responsive.isMobile(context) ? 10 : 6.sp,
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: Responsive.isMobile(context) ? 2 : 10.sp,
                    horizontal: 10.sp),
                hintStyle:
                Styles.heading3(context).copyWith(color: Colors.black26),
                fillColor: Colors.grey.withOpacity(.1),
                filled: false,
                border: OutlineInputBorder(
                    borderRadius:BorderRadius.circular(10.r),
                    borderSide:
                    BorderSide(color: Colors.grey.shade400, width: .7.h)),
                errorBorder: OutlineInputBorder(
                    borderRadius:BorderRadius.circular(10.r),
                    borderSide: BorderSide(width: 0.7.h)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey, width: 0.7.h)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide:
                    BorderSide(color: Colors.grey.shade400, width: 0.7.h)),
                focusedBorder: OutlineInputBorder(
                    borderRadius:BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey, width: 0.9.h)),
              ),
            ),

            SizedBox(height: 20.h,),
            isLoading?CircularProgressIndicator.adaptive():FullWidthButton(

                child: Text("Reject delivery", style: Styles.heading3(context).copyWith(color: Colors.white),),
                action: ()async{
                  setState(() {
                    isLoading = true;
                  });
                  if(cancelReason == ""){
                    showCustomSnackBar("Select Reject reason",isError: true);
                    setState(() {
                      isLoading = false;
                    });
                  }else{
                    try{
                      final responseModel = await ref.read(deliveriesRepositoryProvider).rejectDelivery(widget.deliveryCodes, cancelReason);
                      showCustomSnackBar("Delivery Rejected", isError: false);
                      ref.refresh(deliveriesProvider);
                      Get.close(2);
                    }catch(e){
                      showCustomSnackBar(e.toString());
                    }

                    setState(() {
                      isLoading = false;
                    });

                  }

                  // Get.close(2);
                })
          ],
        ),
      ),
    );
  }
}

