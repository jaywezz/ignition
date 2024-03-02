import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/constants.dart';

import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/controllers/find_me.dart';
import 'package:soko_flow/controllers/orders_controller.dart';
import 'package:soko_flow/controllers/payment_controller.dart';
import 'package:soko_flow/data/providers/deliveries/deliveries_provider.dart';
import 'package:soko_flow/data/repository/user_deriveries_repo.dart';
import 'package:soko_flow/logic/routes/routes.dart';
import 'package:soko_flow/models/derivery_model.dart';
import 'package:soko_flow/models/latest_allocations_model/latest_allocated_items_model.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/drive_to_customer.dart';
import 'package:soko_flow/views/customers/map_view.dart';
import 'package:soko_flow/views/customers/order_history_screen.dart';
import 'package:soko_flow/views/deliveries/detailed_delivery/components/confirm_and_deliver_screen.dart';
import 'package:soko_flow/views/deliveries/detailed_delivery/components/partial_delivery_widget.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/stock_requisition/select_stock_screen.dart';
import 'package:soko_flow/views/product_catalogue/components/allocation_history_products.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:soko_flow/widgets/inputs/custom_dropdown.dart';

import 'package:soko_flow/widgets/inputs/search_field.dart';

import '../../../routes/route_helper.dart';
import '../deliveries_screen.dart.bak';
import 'components/detailed_delivery_list.dart';

class DetailedDeliveryScreen extends ConsumerStatefulWidget {
  final String initialScreen;
  final DeliveriesModel delivery;
  const DetailedDeliveryScreen({Key? key, required this.delivery, required this.initialScreen}) : super(key: key);

  @override
  ConsumerState<DetailedDeliveryScreen> createState() => _DetailedDeliveryScreenState();
}

class _DetailedDeliveryScreenState extends ConsumerState<DetailedDeliveryScreen> {
  bool deliverPartially = false;
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");
  // String orderCode = "";
  // String customerId = "";
  // Initial Selected Value
  String dropdownvalue = 'Select Payment Method';
  int _key = 0;

  // List of items in our dropdown menu
  var paymentMethods = [
    'M-pesa',
    'Cash',
    'Cheque',
  ];
  bool isLoadingPayment = false;
  Position? position;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    ref.watch(findMeProvider).whenData((value) => position = value);
    super.didChangeDependencies();
  }

  TextEditingController amountController = TextEditingController();
  TextEditingController transactionIDController = TextEditingController();
  TextEditingController chequeNumberController = TextEditingController();
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

                deliverPartially?PartialDelivertWidget()
                    :Expanded(child: DeliveriesList(orderItems:widget.delivery.deliveryItems, deliveryStatus: widget.delivery.deliveryStatus, )),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Received(Ksh. )",
                      style: Styles.heading3(context)
                          .copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                          Styles.appSecondaryColor),
                    ),
                    Text(formatCurrency.format(int.parse(widget.delivery.order!.priceTotal!) - int.parse(widget.delivery.order!.balance!)),
                      style: Styles.heading3(context)
                          .copyWith(
                          color:
                          Styles.appSecondaryColor),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pending (Ksh. )",
                      style: Styles.heading3(context)
                          .copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent),
                    ),
                    Text(
                      formatCurrency.format(int.parse(widget.delivery.order!.balance!)),
                      style: Styles.heading3(context)
                          .copyWith(color: Colors.redAccent),
                    )
                  ],
                ),
                int.parse(widget.delivery.order!.balance!) > 0?widget.delivery.deliveryStatus == "cancelled"?SizedBox(): widget.delivery.deliveryStatus == "Partial delivery"?SizedBox():widget.delivery.deliveryStatus == "DELIVERED"?SizedBox():deliverPartially?SizedBox():GetBuilder<PaymentController>(
                    builder: (paymentController) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0.sp),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20)),
                              // border: Border.all(color: Styles.appYellowColor),
                              color: Styles.appSecondaryColor
                                  .withOpacity(.1)),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              key: new Key(_key.toString()),
                              iconColor: Styles.appSecondaryColor,
                              textColor: Styles.appSecondaryColor,
                              controlAffinity:
                              ListTileControlAffinity
                                  .trailing,
                              childrenPadding:
                              const EdgeInsets.symmetric(
                                  vertical: 1,
                                  horizontal: 20),
                              expandedCrossAxisAlignment:
                              CrossAxisAlignment.end,
                              maintainState: false,
                              title: Text(
                                'Add Payment',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              // contents
                              children: [
                                MaterialButton(
                                  color: Styles.appSecondaryColor,
                                  minWidth: double.infinity,
                                  height: Responsive.isMobile(
                                      context) &&
                                      Responsive
                                          .isMobileLarge(
                                          context)
                                      ? 40
                                      : 60,
                                  //SizeConfig.isTabletWidth ? 70 : 50,
                                  child: paymentController
                                      .paymentMethod == PaymentMethods.Mpesa ? Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                      // Image.asset("assets/images/mpesat.png", height: 40, width: 40,),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text("M-Pesa",
                                          style: Styles.heading3(context).copyWith(color: Colors.white)),
                                    ],
                                  )
                                      : paymentController.paymentMethod == PaymentMethods.Cheque
                                      ? Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: [
                                      // Image.asset("assets/images/cheque.jpg", height: 40, width: 40,),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text("Cheque", style: Styles.heading3(context).copyWith(color:Colors.white)),
                                    ],
                                  )
                                      : paymentController.paymentMethod == PaymentMethods.Cash
                                      ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Icon(Icons.money, color: Colors.white,),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text("Cash",
                                          style: Styles.heading3(context).copyWith(color: Colors.white)),
                                    ],
                                  )
                                      : Text("Select payment method",
                                      style: Styles.heading3(context).copyWith(color: Colors.white)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  onPressed: () {
                                    Get.dialog(MethodPayments());
                                  },
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(
                                              20)),
                                      // border: Border.all(color: Styles.appYellowColor),
                                      color:
                                      Styles.appSecondaryColor),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Amount",
                                  style: Styles.heading3(context)
                                      .copyWith(
                                      color: Styles
                                          .appSecondaryColor),
                                ),
                                // SizedBox(height: 5,),
                                Container(
                                  height: 50,
                                  child: TextField(
                                    controller: amountController,
                                    onChanged: (String value) {
                                      if (int.parse(
                                          amountController.text) > int.parse(widget.delivery.order!.balance!)) {
                                        amountController.text =widget.delivery.order!.balance!;
                                        showCustomSnackBar(
                                            "Amount entered is more than the pending amount",
                                            isError: true);
                                      }
                                    },
                                    decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Styles
                                            .appSecondaryColor,
                                      ), //icon of text field
                                      labelText: "Enter Amount",
                                      labelStyle: TextStyle(
                                          color: Colors.grey),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                              Colors.orange),
                                          borderRadius:
                                          BorderRadius.circular(
                                              10)), //label text of field
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Styles
                                                  .appSecondaryColor),
                                          borderRadius:
                                          BorderRadius
                                              .circular(10)),
                                    ),
                                    keyboardType:
                                    TextInputType.number,
                                    //set it true, so that user will not able to edit text
                                  ),
                                ),

                                SizedBox(
                                  height: 10,
                                ),
                                paymentController.paymentMethod ==
                                    PaymentMethods.Mpesa
                                    ? Text(
                                  "Transaction ID",
                                  style: Styles.heading3(
                                      context)
                                      .copyWith(
                                      color: Styles
                                          .appSecondaryColor),
                                )
                                    : paymentController
                                    .paymentMethod ==
                                    PaymentMethods.Cheque
                                    ? Text(
                                  "Cheque Number",
                                  style: Styles
                                      .heading3(
                                      context)
                                      .copyWith(
                                      color: Styles
                                          .appSecondaryColor),
                                )
                                    : Text(""),
                                paymentController.paymentMethod ==
                                    PaymentMethods.Mpesa
                                    ? Container(
                                  height: 50,
                                  child: TextField(
                                    controller:
                                    transactionIDController,
                                    decoration:
                                    InputDecoration(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Styles
                                            .appSecondaryColor,
                                      ), //icon of text field
                                      labelText:
                                      "Enter M-pesa Transaction ID",
                                      labelStyle: TextStyle(
                                          color:
                                          Colors.grey),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors
                                                  .orange),
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              10)), //label text of field
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Styles
                                                  .appSecondaryColor),
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              10)),
                                    ),
                                    //set it true, so that user will not able to edit text
                                  ),
                                )
                                    : Container(),
                                paymentController.paymentMethod ==
                                    PaymentMethods.Cheque
                                    ? Container(
                                  height: 50,
                                  child: TextField(
                                    controller:
                                    chequeNumberController,
                                    decoration:
                                    InputDecoration(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Styles
                                            .appSecondaryColor,
                                      ), //icon of text field
                                      labelText:
                                      "Enter Cheque Number",
                                      labelStyle: TextStyle(
                                          color:
                                          Colors.grey),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors
                                                  .orange),
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              10)), //label text of field
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Styles
                                                  .appSecondaryColor),
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              10)),
                                    ),
                                    //set it true, so that user will not able to edit text
                                  ),
                                )
                                    : Container(),
                                SizedBox(
                                  height: 20,
                                ),
                                MaterialButton(
                                  color: Styles.appYellowColor,
                                  height: Responsive.isMobile(
                                      context) &&
                                      Responsive
                                          .isMobileLarge(
                                          context)
                                      ? 40
                                      : 60,
                                  //SizeConfig.isTabletWidth ? 70 : 50,
                                  // child: orderDetailsController
                                  //     .isLoading
                                    child:isLoadingPayment
                                      ? CircularProgressIndicator()
                                      : Text("Submit Payment",
                                      style: Styles
                                          .buttonText2(
                                          context)
                                          .copyWith(
                                          color: Colors
                                              .white)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          defaultRadius1)),
                                  onPressed: () {
                                    print(
                                        "amount: ${amountController.text}");
                                    if (amountController.text == "") {
                                      showCustomSnackBar("Enter an amouunt", isError: true);
                                    } else if (paymentController.paymentMethod ==
                                        PaymentMethods
                                            .Cheque &&
                                        chequeNumberController
                                            .text ==
                                            "") {
                                      showCustomSnackBar(
                                          "Enter cheque Number",
                                          isError: true);
                                    } else if (paymentController
                                        .paymentMethod ==
                                        PaymentMethods
                                            .Mpesa &&
                                        transactionIDController
                                            .text ==
                                            "") {
                                      showCustomSnackBar(
                                          "Enter M-pesa transactionID",
                                          isError: true);
                                    } else {
                                      setState(() {
                                        isLoadingPayment = true;
                                      });
                                      paymentController.addOrderPayment(widget.delivery.orderCode, amountController.text, transactionIDController                                           .text, paymentController.paymentMethod.toString())
                                          .then((value) {
                                        amountController.clear();
                                        transactionIDController.clear();
                                        chequeNumberController
                                            .clear();
                                        // orderDetailsController
                                        //     .getOrderDetails(
                                        //     orderCode);
                                        Get.find<OrdersController>().getSalesOrders(widget.delivery.customer.id!.toString());
                                        Get.find<OrdersController>().getVanOrders(widget.delivery.customer.id!.toString());
                                        setState(() {
                                          _key++;
                                        });
                                        Get.find<
                                            OrdersController>()
                                            .update();
                                      });
                                      setState(() {
                                        isLoadingPayment = false;
                                      });
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }):SizedBox(),

              ],
            ),
          ),
        ),
      ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        //   child: FullWidthButton(
        //     action: () async{
        //       Navigator.of(context).push(
        //           MaterialPageRoute(
        //               builder: (context) =>
        //                   CustomerTrackingPage(
        //                     shopName: widget.delivery.customer.customerName!,
        //                     sourceLocation: LatLng(position!.latitude, position!.longitude),
        //                     destination: LatLng(double.parse(widget.delivery.customer.latitude!), double.parse(widget.delivery.customer.longitude!)),
        //                   )));
        //     },
        //     text: "View Customer on Map",
        //   ),
        // ):
        bottomNavigationBar:widget.delivery.deliveryStatus == "DELIVERED"?Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0.sp, horizontal: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check, color: Colors.green, size: 25.sp,),
            SizedBox(width: 30.w,),
            Text("Delivery made on :  ", style: Styles.heading3(context).copyWith(color: Colors.green),),
            Text(DateFormat.yMMMd().format(widget.delivery.updatedAt), style: Styles.heading3(context),)
            
          ],
        ),
      ):widget.delivery.deliveryStatus == "Partial delivery"?Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0.sp, horizontal: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check, color: Styles.appSecondaryColor, size: 25.sp,),
            SizedBox(width: 30.w,),
            Text("Delivered Partially on :  ", style: Styles.heading3(context).copyWith(color: Styles.appSecondaryColor),),
            Text(DateFormat.yMMMd().format(widget.delivery.updatedAt), style: Styles.heading3(context),)

          ],
        ),
      ):widget.delivery.deliveryStatus == "cancelled"?Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0.sp, horizontal: 20.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.close, color: Colors.redAccent, size: 25.sp,),
            SizedBox(width: 30.w,),
            Text("Delivery Cancelled on :  ", style: Styles.heading3(context).copyWith(color: Colors.redAccent),),
            Text(DateFormat.yMMMd().format(widget.delivery.updatedAt), style: Styles.heading3(context),)

          ],
        ),
      ):Container(
        height: deliverPartially?MediaQuery.of(context).size.height * .20:MediaQuery.of(context).size.height * .25,
        padding: EdgeInsets.only(
            left: defaultPadding(context),
            right: defaultPadding(context),
            bottom: defaultPadding(context)),
        child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Styles.appSecondaryColor,
                    value: deliverPartially,
                    onChanged: (bool? value) {
                      if(value == true){
                        print("populating cart");
                        ref.watch(deliveryCartProvider).clear();
                        for(DeliveryItemModel item in widget.delivery.deliveryItems){
                          ref.watch(deliveryCartProvider).add(
                            DeliveryCartModel(
                              productId: item.productId,
                              productName: item.productName,
                              sellingPrice: item.sellingPrice,
                              allocatedQuantity: int.parse(item.allocatedQuantity!),
                              qty: int.parse(item.allocatedQuantity!),
                            )
                          );
                        }
                        print("length :${ref.watch(deliveryCartProvider).length}");
                      }else{
                        print("removing from cart");
                        ref.watch(deliveryCartProvider).clear();
                        print("length :${ref.watch(deliveryCartProvider).length}");
                      }
                      setState(() {
                        deliverPartially= value!;
                      });
                    },
                  ),
                  Text("Deliver Partially", style: Styles.heading3(context),)
                ],
              ),
          // deliverPartially?SizedBox(height: 10,):SizedBox(),
              ref.watch(deliveriesNotifierProvider).isLoading?CircularProgressIndicator():FullWidthButton(
          action: () async{
            if(deliverPartially){
               Get.to(ConfirmPartialDelivery(delivery: widget.delivery,));
            }else{
              if(await checkDeliveryItems()){
                await ref.watch(deliveriesNotifierProvider.notifier).makeFullDelivery(widget.delivery.deliveryItems, widget.delivery.deliveryCode);
              }
              else{
                Fluttertoast.showToast(msg: "You do not have enough items to complete delivery", backgroundColor: Colors.blue);
              }
              // showCustomSnackBar("Delivered successfully", isError: false);
            }

          },
          text: deliverPartially?"Next":"Deliver with Current Stock",
        ),
              SizedBox(height: 10,),
              deliverPartially?SizedBox():InkWell(
                onTap: () {
                  Get.to(StockRequisition());
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Request Stock",
                      style: Styles.heading3(context).copyWith(color: Colors.blue),
                    ),
                  ),
                ),
              ),
          SizedBox(height: 10,),
              deliverPartially?SizedBox():InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return CancellationReasonWidget(deliveryCode: widget.delivery.deliveryCode,);
                },
              );
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Cancel Delivery",
                  style: Styles.heading3(context).copyWith(color: Colors.redAccent),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  checkDeliveryItems()async{
    StockHistoryController stockHistoryController = Get.put(StockHistoryController(stockHistoryRepository: Get.find()));
    await stockHistoryController.getLatestAllocations(false);
    bool hasEnoughItems = true;
    for(DeliveryItemModel item in widget.delivery.deliveryItems){
      print(item.productId);
      for(LatestAllocationModel alloc in stockHistoryController.lstLatestAllocations){
        print("Item Name: ${alloc.productName} and ${alloc.id} qty: ${alloc.allocatedQty}");
      }
      List<LatestAllocationModel> allocation = stockHistoryController.lstLatestAllocations.where((element) => element.productName! == item.productName).toList();
      print(allocation);
      if(allocation.isEmpty){
        hasEnoughItems = false;
        print("false");
      }else if(int.parse(allocation[0].allocatedQty!) >= int.parse(item.allocatedQuantity!)){
        hasEnoughItems= true;
        print("true");
      }else{
        hasEnoughItems = false;
        print("else faLSE");
      }
    }

    return hasEnoughItems;
  }
}

class CancellationReasonWidget extends ConsumerStatefulWidget {
  final String deliveryCode;
  const CancellationReasonWidget({Key? key, required this.deliveryCode}) : super(key: key);

  @override
  ConsumerState<CancellationReasonWidget> createState() => _CancellationReasonWidgetState();
}

class _CancellationReasonWidgetState extends ConsumerState<CancellationReasonWidget> {
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
            Center(child: Text("Provide reason for cancelling order", style: Styles.heading3(context),)),
            SizedBox(height: 20.h,),
            DefaultDropDownFiled(
                value: "Closed shop",
                title: "Delivery cancel reason",
                itemsLists:["Insufficient cash", "Closed shop", "Damaged goods", "Customer changed order", "Incorrectly captured order"],
                onChanged: (value){
                  cancelReason = value!;
                }),
            SizedBox(
              height: 20.h,
            ),
            Text("Provide a Detailed Reason", style: Styles.heading3(context),),
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

              child: Text("Cancel delivery", style: Styles.heading3(context).copyWith(color: Colors.white),),
                action: ()async{
                setState(() {
                  isLoading = true;
                });
                  if(cancelReason == ""){
                    showCustomSnackBar("Select delivery reason",isError: true);
                  }else{
                    var data = {
                      "cancellation_reason": cancelReason,
                      "detailed_reason": detailedReasonController.text
                    };
                    try{
                      final responseModel = await ref.read(deliveriesRepositoryProvider).cancelDelivery(data, widget.deliveryCode);
                      showCustomSnackBar("Delivery Cancelled", isError: false);
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

