import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/add_cart.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/controllers/orders_controller.dart';
import 'package:soko_flow/controllers/payment_controller.dart';
import 'package:soko_flow/data/providers/deliveries/deliveries_provider.dart';
import 'package:soko_flow/models/derivery_model.dart';
import 'package:soko_flow/models/latest_allocations_model/latest_allocated_items_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/order_history_screen.dart';
import 'package:soko_flow/views/customers/sales/components/new_sales_order_list.dart';
import 'package:soko_flow/views/customers/sales/components/van_sales_order_list.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:soko_flow/widgets/inputs/custom_dropdown.dart';
import 'package:soko_flow/widgets/inputs/default_text_field.dart';

class ConfirmPartialDelivery extends ConsumerStatefulWidget {
  final DeliveriesModel delivery;
  const ConfirmPartialDelivery({Key? key, required this.delivery}) : super(key: key);

  @override
  ConsumerState<ConfirmPartialDelivery> createState() => _ConfirmPartialDeliveryState();
}

class _ConfirmPartialDeliveryState extends ConsumerState<ConfirmPartialDelivery> {
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");
  TextEditingController discountController = TextEditingController();

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

  TextEditingController amountController = TextEditingController();
  TextEditingController transactionIDController = TextEditingController();
  TextEditingController chequeNumberController = TextEditingController();
  String partialDeliveryReason = "";

  String screen_name = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  double totalCartPrice = 0.0;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    ref.watch(deliveryCartProvider).forEach((item) {
      setState(() {});
      totalCartPrice += item.totalPrice();
    });
    super.didChangeDependencies();
  }
  bool offerDiscount = false;
  bool isLoadingPayment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: GetBuilder<AddToCartController>(builder: (addCartController) {
            return SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(
                      left: defaultPadding(context),
                      right: defaultPadding(context),
                      bottom: defaultPadding(context)),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/bg.png',
                          ),
                          fit: BoxFit.cover),
                      borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(30))),
                  child: GetBuilder<AddToCartController>(
                      builder: (addCartController) {
                        return Column(
                          children: [
                            SizedBox(
                              height: defaultPadding(context),
                            ),
                            Stack(
                              children: [
                                Material(
                                  child: InkWell(
                                    splashColor: Theme.of(context).splashColor,
                                    onTap: () => Navigator.pop(context),
                                    child: Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Styles.darkGrey,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Make Delivery',
                                    style: Styles.heading2(context),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Material(
                                    child: InkWell(
                                      splashColor: Theme.of(context).splashColor,
                                      onTap: () =>
                                          Get.toNamed(RouteHelper.getInitial()),
                                      child: Icon(
                                        Icons.home_sharp,
                                        size: defaultPadding(context) * 2,
                                        color: Styles.appPrimaryColor,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: defaultPadding(context) * 1.3,
                            ),
                             ConfirmDeliveryList(),
                            SizedBox(
                              height: 20.h,
                            ),
                            SizedBox(
                              height: 40.h,
                            ),

                            GetBuilder<PaymentController>(
                                builder: (paymentController) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0.sp),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          // border: Border.all(color: Styles.appYellowColor),
                                          color: Styles.appPrimaryColor
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
                                              child: paymentController.paymentMethod == PaymentMethods.Mpesa ? Row(
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
                                                  : paymentController
                                                  .paymentMethod ==
                                                  PaymentMethods
                                                      .Cheque
                                                  ? Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  // Image.asset("assets/images/cheque.jpg", height: 40, width: 40,),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text("Cheque",
                                                      style: Styles
                                                          .heading3(
                                                          context)
                                                          .copyWith(
                                                          color:Colors.white)),
                                                ],
                                              )
                                                  : paymentController.paymentMethod == PaymentMethods.Cash
                                                  ? Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  // Icon(Icons.money, color: Colors.white,),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text("Cash",
                                                      style: Styles.heading3(
                                                          context)
                                                          .copyWith(
                                                          color:Colors.white)),
                                                ],
                                              ):paymentController.paymentMethod == PaymentMethods.BankTransfer
                                                  ? Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  // Icon(Icons.money, color: Colors.white,),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text("Bank To Bank Transfer",
                                                      style: Styles.heading3(
                                                          context)
                                                          .copyWith(
                                                          color:Colors.white)),
                                                ],
                                              )
                                                  : Text(
                                                  "Select payment method",
                                                  style: Styles
                                                      .heading3(
                                                      context)
                                                      .copyWith(
                                                      color: Colors.white)),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      30)),
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
                                                      amountController
                                                          .text) >
                                                      int.parse(totalCartPrice.toString())) {
                                                    amountController.text ="0";
                                                    showCustomSnackBar(
                                                        "Amount entered is more than the total amount",
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
                                              height: Responsive.isMobile(context) && Responsive.isMobileLarge(context) ? 40 : 60,
                                              //SizeConfig.isTabletWidth ? 70 : 50,
                                              // child: orderDetailsController
                                              //     .isLoading
                                              child:isLoadingPayment? CircularProgressIndicator()
                                                  : Text("Submit Payment",
                                                  style: Styles.buttonText2(context).copyWith(color: Colors.white)),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius1)),
                                              onPressed: () {
                                                print("amount: ${amountController.text}");
                                                if (amountController.text == "") {
                                                  showCustomSnackBar("Enter an amouunt", isError: true);
                                                } else if (paymentController.paymentMethod == PaymentMethods.Cheque && chequeNumberController.text == "") {
                                                  showCustomSnackBar("Enter cheque Number", isError: true);
                                                } else if (paymentController.paymentMethod == PaymentMethods.Mpesa && transactionIDController.text == "") {
                                                  showCustomSnackBar(
                                                      "Enter M-pesa transactionID",
                                                      isError: true);
                                                } else {
                                                  setState(() {
                                                    isLoadingPayment = true;
                                                  });
                                                  paymentController.addOrderPayment(
                                                      widget.delivery.orderCode, amountController.text, transactionIDController.text,
                                                      paymentController.paymentMethod.toString()).then((value) {
                                                    amountController.clear();
                                                    transactionIDController.clear();
                                                    chequeNumberController.clear();
                                                    // orderDetailsController
                                                    //     .getOrderDetails(
                                                    //     orderCode);
                                                    Get.find<OrdersController>().getSalesOrders(widget.delivery.customer.id.toString());
                                                    Get.find<OrdersController>().getVanOrders(widget.delivery.customer.id.toString());
                                                    setState(() {
                                                      _key++;
                                                    });
                                                    Get.find<OrdersController>().update();
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
                                }),
                            SizedBox(height: 20.h,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: DefaultDropDownFiled(
                                  value: "Closed shop",
                                  title: "Reason For Partial Delivery",
                                  itemsLists:["Insufficient cash", "Closed shop", "Damaged goods", "Customer changed order", "Incorrectly captured order"],
                                  onChanged: (value){
                                    setState(() {
                                      partialDeliveryReason = value!;
                                    });
                                  }),
                            ),
                            SizedBox(height: 20.h,),
                            Container(
                              // height: defaultPadding(context) * 13.5,
                              padding: EdgeInsets.symmetric(horizontal: 10.sp),
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "SubTotal (Ksh)",
                                      style: Styles.normalText(context).copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      formatCurrency
                                          .format(totalCartPrice),
                                      style: Styles.heading3(context),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Tax",
                                      style: Styles.normalText(context).copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      '0.0',
                                      style: Styles.heading3(context),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total (Ksh. )",
                                      style: Styles.heading2(context)
                                          .copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      formatCurrency
                                          .format(totalCartPrice),
                                      style: Styles.heading1(context).copyWith(
                                        color: Styles.appSecondaryColor,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(height: 20.h,),

                              ref.watch(deliveriesNotifierProvider).isLoading
                                    ? Center(
                                    child: Platform.isAndroid
                                        ? CircularProgressIndicator(
                                        color: Styles.appSecondaryColor)
                                        : CupertinoActivityIndicator())
                                    : FullWidthButton(
                                  action: () async {
                                    print("reason: ${partialDeliveryReason}  ");
                                    if(partialDeliveryReason == ""){
                                      showCustomSnackBar("Select reason for partial delivery");
                                    }else{
                                      if(await checkDeliveryItems()){
                                        ref.watch(deliveriesNotifierProvider.notifier).makePartialDelivery(partialDeliveryReason, widget.delivery.deliveryCode);
                                      }
                                      else{
                                        Fluttertoast.showToast(msg: "You do not have enough items to complete delivery", backgroundColor: Colors.blue);
                                      }
                                    }
                                  },
                                  text: "Complete Partial Delivery",
                                ),
                              ]),
                            )
                          ],
                        );
                      })),
            );
          }),
        ),
      ),
    );
  }

  checkDeliveryItems()async{
    StockHistoryController stockHistoryController = Get.put(StockHistoryController(stockHistoryRepository: Get.find()));
    await stockHistoryController.getLatestAllocations(false);
    bool hasEnoughItems = true;
    for(DeliveryCartModel item in ref.read(deliveryCartProvider)){
      List<LatestAllocationModel> allocation = stockHistoryController.lstLatestAllocations.where((element) => element.productName! == item.productName).toList();
      if(allocation.isEmpty){
        hasEnoughItems = false;
        print("false");
      }else if(int.parse(allocation[0].allocatedQty!) >= item.qty!){
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


class ConfirmDeliveryList extends ConsumerStatefulWidget {

  const ConfirmDeliveryList({Key? key,}) : super(key: key);

  @override
  ConsumerState<ConfirmDeliveryList> createState() => _ConfirmDeliveryListState();
}

class _ConfirmDeliveryListState extends ConsumerState<ConfirmDeliveryList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      child: Column(
        children: [
          Table(
            columnWidths: {
              0: FractionColumnWidth(0.5),
              1: FractionColumnWidth(0.30),
              2: FractionColumnWidth(0.25),
            },
            children: [
              buildRow([
                Text("Product", style: Styles.heading3(context),),
                IntrinsicHeight(
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                        Container(
                            width: 50,
                            child: Center(child: Text('Price', style: Styles.heading3(context),))),
                        VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                      ],
                    )
                ),
                Text("Quantity", style: Styles.heading3(context),),
              ]),

            ],
          ),
          Divider(thickness: 1,),
          Table(
              columnWidths: {
                0: FractionColumnWidth(0.5),
                1: FractionColumnWidth(0.30),
                2: FractionColumnWidth(0.25),
              },
              children: ref.watch(deliveryCartProvider).map((e) =>  buildRow(
                  [
                    Text(e.productName!, style: Styles.smallGreyText(context),),
                    IntrinsicHeight(
                        child:Row(

                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                            Container(
                                width: 50,
                                child: Center(child: Text(e.sellingPrice!, style: Styles.smallGreyText(context)))), VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                          ],
                        )),
                    Text("${e.qty.toString()}", style: Styles.smallGreyText(context)),
                  ]
              )).toList()
          ),



        ],
      ),
    );
  }
}

TableRow buildRow(List<Widget> cells) => TableRow(
    children: cells.map((cell) => cell).toList()
);


