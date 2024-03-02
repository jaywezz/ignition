import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/add_cart.dart';
import 'package:soko_flow/controllers/order_details_controller.dart';
import 'package:soko_flow/controllers/orders_controller.dart';
import 'package:soko_flow/controllers/payment_controller.dart';
import 'package:soko_flow/data/providers/client_provider.dart';
import 'package:soko_flow/models/distributors_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/order_history_screen.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");
  String orderCode = "";
  DistributorsModel? distributorsModel;
  String selectedStatus = "Not Delivered";
  String customerId = "";
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
  bool? nopayment;
  bool isLoading = false;
  bool showStatus = true;
  @override
  void initState() {
    // TODO: implement initState
    if (Get.arguments["orderCode"] != null) {
      setState(() {
        orderCode = Get.arguments["orderCode"];
      });
    }
    if (Get.arguments["showStatus"] != null) {
      setState(() {
        showStatus = Get.arguments["showStatus"];
      });
    }
    if (Get.arguments["distributor"] != null) {
      setState(() {
        distributorsModel = Get.arguments["distributor"];
      });
    }
    if (Get.arguments["customer_id"] != null) {
      setState(() {
        customerId = Get.arguments["customer_id"].toString();
      });
    }
    if (Get.arguments["nopayment"] != null) {
      setState(() {
        nopayment = Get.arguments["nopayment"];
      });
    }

    Get.find<OrderDetailsController>().getOrderDetails(orderCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailsController>(
        builder: (orderDetailsController) {
      return Scaffold(
        body: SafeArea(
          child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
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
                                'Order Details',
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
                        orderDetailsController.isLoading
                            ? CircularProgressIndicator()
                            : orderDetailsController.orderitems.isEmpty
                                ? Text(
                                    "No products in this order",
                                    style: Styles.smallGreyText(context),
                                  )
                                : Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.sp),
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
                                              Text(
                                                "Product",
                                                style: Styles.heading3(context),
                                              ),
                                              IntrinsicHeight(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  VerticalDivider(
                                                    color: Colors.grey.shade400,
                                                    thickness: 2,
                                                  ),
                                                  Container(
                                                      width: 50,
                                                      child: Center(
                                                          child: Text(
                                                        'Unit Price',
                                                        style: Styles.heading3(
                                                            context),
                                                      ))),
                                                  VerticalDivider(
                                                    color: Colors.grey.shade400,
                                                    thickness: 2,
                                                  ),
                                                ],
                                              )),
                                              Text(
                                                "Total",
                                                style: Styles.heading3(context),
                                              ),
                                            ]),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        Table(
                                            columnWidths: {
                                              0: FractionColumnWidth(0.5),
                                              1: FractionColumnWidth(0.30),
                                              2: FractionColumnWidth(0.25),
                                            },
                                            children:
                                                orderDetailsController
                                                    .orderitems
                                                    .map((e) => buildRow([
                                                          Text(
                                                            "${e.quantity!} ${e.productName!}",
                                                            style: Styles
                                                                .smallGreyText(
                                                                    context),
                                                          ),
                                                          IntrinsicHeight(
                                                              child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              VerticalDivider(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                thickness: 2,
                                                              ),
                                                              Container(
                                                                  width: 50,
                                                                  child: Center(
                                                                      child: Text(
                                                                          e.sellingPrice
                                                                              .toString(),
                                                                          style:
                                                                              Styles.smallGreyText(context)))),
                                                              VerticalDivider(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                thickness: 2,
                                                              ),
                                                            ],
                                                          )),
                                                          Text(
                                                              "${e.totalAmount.toString()}",
                                                              style: Styles
                                                                  .smallGreyText(
                                                                      context)),
                                                        ]))
                                                    .toList()),
                                      ],
                                    ),
                                  ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: defaultPadding(context) * 16,
                          padding: EdgeInsets.only(
                                  top: defaultPadding(context) * .7,
                                  left: defaultPadding(context) * 1.0,
                                  right: defaultPadding(context) * 1.0,
                                  bottom: defaultPadding(context)) *
                              1.5,
                          child: orderDetailsController.isLoading
                              ? Center(child: CircularProgressIndicator())
                              : Column(children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "SubTotal (Ksh)",
                                        style: Styles.normalText(context)
                                            .copyWith(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        formatCurrency.format(int.parse(
                                            orderDetailsController
                                                    .orderData.priceTotal ??
                                                "0".toString())),
                                        style: Styles.heading3(context),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Tax",
                                        style: Styles.normalText(context)
                                            .copyWith(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total (Ksh. )",
                                        style: Styles.heading3(context)
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        formatCurrency.format(int.parse(
                                            orderDetailsController
                                                    .orderData.priceTotal ??
                                                "0".toString())),
                                        style: Styles.heading3(context),
                                      )
                                    ],
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 10,
                                  ),
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
                                      Text(
                                        formatCurrency.format(int.parse(
                                                orderDetailsController
                                                        .orderData.priceTotal ??
                                                    "0") -
                                            int.parse(orderDetailsController
                                                    .orderData.balance ??
                                                "0")),
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
                                        formatCurrency.format(int.parse(
                                            orderDetailsController
                                                    .orderData.balance ??
                                                "0")),
                                        style: Styles.heading3(context)
                                            .copyWith(color: Colors.redAccent),
                                      )
                                    ],
                                  ),
                                ]),
                        ),
                        // Get.arguments["allowpayment"] == true
                            // ? FullWidthButton(
                            //     action: () {
                            //       Navigator.pop(context);
                            //     },
                            //     child: Text("Back",
                            //         style: Theme.of(context)
                            //             .textTheme
                            //             .titleLarge!
                            //             .copyWith(
                            //                 color: Styles.appBackgroundColor)),
                            //   )
                        // ?SizedBox():
                  distributorsModel!=null &&distributorsModel!.id == 1 || orderDetailsController.orderData.orderType == "Van sales"?orderDetailsController.isLoading
                                ? CircularProgressIndicator()
                                : int.parse(orderDetailsController.orderData.balance ?? "0") != 0.00
                                    ? GetBuilder<PaymentController>(
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
                                                controlAffinity: ListTileControlAffinity.trailing,
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
                                                                .paymentMethod ==
                                                            PaymentMethods.Mpesa
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              // Image.asset("assets/images/mpesat.png", height: 40, width: 40,),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              Text("M-Pesa",
                                                                  style: Styles
                                                                          .heading3(
                                                                              context)
                                                                      .copyWith(
                                                                          color:
                                                                          Colors.white)),
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
                                                                      style: Styles.heading3(
                                                                              context)
                                                                          .copyWith(
                                                                              color: Colors.white)),
                                                                ],
                                                              )
                                                            : paymentController
                                                                        .paymentMethod ==
                                                                    PaymentMethods
                                                                        .Cash
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      // Icon(Icons.money, color: Colors.white,),
                                                                      SizedBox(
                                                                        width:
                                                                            15,
                                                                      ),
                                                                      Text(
                                                                          "Cash",
                                                                          style:
                                                                              Styles.heading3(context).copyWith(color:Colors.white)),
                                                                    ],
                                                                  )
                                                                : paymentController
                                                                            .paymentMethod ==
                                                                        PaymentMethods
                                                                            .BankTransfer
                                                                    ? Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          // Icon(Icons.money, color: Colors.white,),
                                                                          SizedBox(
                                                                            width:
                                                                                15,
                                                                          ),
                                                                          Text(
                                                                              "Bank To Bank Transfer",
                                                                              style: Styles.heading3(context).copyWith(color: Colors.white)),
                                                                        ],
                                                                      )
                                                                    : Text("Select payment method",
                                                                        style: Styles.heading3(context).copyWith(
                                                                            color: Colors.white)),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                    onPressed: () {
                                                      Get.dialog(MethodPayments());
                                                    },
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                                        // border: Border.all(color: Styles.appYellowColor),
                                                        color: Styles
                                                            .appSecondaryColor),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text(
                                                    "Amount",
                                                    style: Styles.heading3(
                                                            context)
                                                        .copyWith(
                                                            color: Styles
                                                                .appSecondaryColor),
                                                  ),
                                                  // SizedBox(height: 5,),
                                                  Container(
                                                    height: 50,
                                                    child: TextField(
                                                      controller: amountController,
                                                      onChanged:
                                                          (String value) {
                                                        if (int.parse(
                                                                amountController.text) > int.parse(
                                                                orderDetailsController
                                                                    .orderData
                                                                    .balance!)) {
                                                          amountController
                                                                  .text =
                                                              orderDetailsController
                                                                  .orderData
                                                                  .balance!
                                                                  .toString();
                                                          showCustomSnackBar(
                                                              "Amount entered is more than the pending amount",
                                                              isError: true);
                                                        }
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color: Styles
                                                              .appSecondaryColor,
                                                        ), //icon of text field
                                                        labelText:
                                                            "Enter Amount",
                                                        labelStyle: TextStyle(
                                                            color: Colors.grey),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
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
                                                      keyboardType:
                                                          TextInputType.number,
                                                      //set it true, so that user will not able to edit text
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  paymentController
                                                              .paymentMethod ==
                                                          PaymentMethods.Mpesa
                                                      ? Text(
                                                          "Transaction ID",
                                                          style: Styles
                                                                  .heading3(
                                                                      context)
                                                              .copyWith(
                                                                  color: Styles
                                                                      .appSecondaryColor),
                                                        )
                                                      : paymentController
                                                                  .paymentMethod ==
                                                              PaymentMethods
                                                                  .Cheque
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
                                                  paymentController
                                                              .paymentMethod ==
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
                                                                  color: Colors
                                                                      .grey),
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
                                                  paymentController
                                                                  .paymentMethod ==
                                                              PaymentMethods
                                                                  .Cheque ||
                                                          paymentController
                                                                  .paymentMethod ==
                                                              PaymentMethods
                                                                  .BankTransfer
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
                                                              labelText: paymentController
                                                                          .paymentMethod ==
                                                                      PaymentMethods
                                                                          .BankTransfer
                                                                  ? "Enter TransactionId"
                                                                  : "Enter Cheque Number",
                                                              labelStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey),
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
                                                    color: Styles
                                                        .appSecondaryColor,
                                                    height: Responsive.isMobile(
                                                                context) &&
                                                            Responsive
                                                                .isMobileLarge(
                                                                    context)
                                                        ? 40
                                                        : 60,
                                                    //SizeConfig.isTabletWidth ? 70 : 50,
                                                    child: orderDetailsController
                                                            .isLoading
                                                        ? CircularProgressIndicator()
                                                        : Text(
                                                            paymentController
                                                                        .paymentMethod ==
                                                                    PaymentMethods
                                                                        .Cheque
                                                                ? "Upload Cheque Photo"
                                                                : "Submit Payment",
                                                            style: Styles
                                                                    .buttonText2(
                                                                        context)
                                                                .copyWith(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white)),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                defaultRadius1)),
                                                    onPressed: () {
                                                      print(
                                                          "amount: ${amountController.text}");
                                                      if (paymentController
                                                              .paymentMethod ==
                                                          PaymentMethods
                                                              .Cheque) {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return ChequePhotoDialogWidget(
                                                                  amountController:
                                                                      amountController,
                                                                  transactionIDController:
                                                                      transactionIDController,
                                                                  chequeNumberController:
                                                                      chequeNumberController,
                                                                  orderCode:
                                                                      orderCode,
                                                                  customerId:
                                                                      customerId);
                                                            });
                                                      } else {
                                                        if (amountController
                                                                .text ==
                                                            "") {
                                                          showCustomSnackBar(
                                                              "Enter an amouunt",
                                                              isError: true);
                                                        } else if (paymentController
                                                                    .paymentMethod ==
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
                                                          paymentController
                                                              .addOrderPayment(
                                                                  orderCode,
                                                                  amountController
                                                                      .text,
                                                                  transactionIDController
                                                                      .text,
                                                                  paymentController
                                                                      .paymentMethod
                                                                      .toString())
                                                              .then((value) {
                                                            amountController
                                                                .clear();
                                                            transactionIDController
                                                                .clear();
                                                            chequeNumberController
                                                                .clear();
                                                            orderDetailsController
                                                                .getOrderDetails(
                                                                    orderCode);
                                                            Get.find<
                                                                    OrdersController>()
                                                                .getSalesOrders(
                                                                    customerId);
                                                            Get.find<
                                                                    OrdersController>()
                                                                .getVanOrders(
                                                                    customerId);
                                                            setState(() {
                                                              _key++;
                                                            });
                                                            Get.find<
                                                                    OrdersController>()
                                                                .update();
                                                          });
                                                        }
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
                                      })
                                    : Container():SizedBox(),
                        distributorsModel!=null &&distributorsModel!.id == 1 || orderDetailsController.orderData.orderType == "Van sales"?orderDetailsController.orderData.balance != orderDetailsController.orderData.priceTotal
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      // border: Border.all(color: Styles.appYellowColor),
                                      color: Styles.appSecondaryColor
                                          .withOpacity(.1)),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent),
                                    child: ExpansionTile(
                                        iconColor: Styles.appSecondaryColor,
                                        textColor: Styles.appSecondaryColor,
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        childrenPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 1, horizontal: 20),
                                        expandedCrossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        maintainState: true,
                                        title: Text(
                                          'View Payments',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        // contents
                                        children: [
                                          Table(
                                            columnWidths: {
                                              0: FractionColumnWidth(0.20),
                                              1: FractionColumnWidth(0.30),
                                              2: FractionColumnWidth(0.25),
                                              3: FractionColumnWidth(0.25),
                                            },
                                            children: [
                                              buildRow([
                                                Text(
                                                  "Method",
                                                  style:
                                                      Styles.heading4(context),
                                                ),
                                                IntrinsicHeight(
                                                    child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    VerticalDivider(
                                                      color:
                                                          Colors.grey.shade400,
                                                      thickness: 2,
                                                    ),
                                                    Container(
                                                        width: 50,
                                                        child: Center(
                                                            child: Text(
                                                          'Amount',
                                                          style:
                                                              Styles.heading4(
                                                                  context),
                                                        ))),
                                                    VerticalDivider(
                                                      color:
                                                          Colors.grey.shade400,
                                                      thickness: 2,
                                                    ),
                                                  ],
                                                )),
                                                Text(
                                                  "Ref No.",
                                                  style:
                                                      Styles.heading4(context),
                                                ),
                                                Text(
                                                  "Date. ",
                                                  style:
                                                      Styles.heading4(context),
                                                ),
                                              ]),
                                            ],
                                          ),
                                          Table(
                                              columnWidths: {
                                                0: FractionColumnWidth(0.20),
                                                1: FractionColumnWidth(0.30),
                                                2: FractionColumnWidth(0.25),
                                                3: FractionColumnWidth(0.25),
                                              },
                                              children: orderDetailsController
                                                  .orderPayments
                                                  .map((e) => buildRow([
                                                        Text(
                                                          e.paymentMethod ==
                                                                  "PaymentMethods.Mpesa"
                                                              ? "M-pesa"
                                                              : e.paymentMethod ==
                                                                      "PaymentMethods.Cash"
                                                                  ? "Cash"
                                                                  : e.paymentMethod == "PaymentMethods.Cheque" ? "Cheque" : "",
                                                          style: Styles.smallGreyText(context),
                                                        ),
                                                        IntrinsicHeight(
                                                            child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: <Widget>[
                                                            VerticalDivider(
                                                              color: Colors.grey.shade400,
                                                              thickness: 2,
                                                            ),
                                                            Container(
                                                                width: 50,
                                                                child: Center(
                                                                    child: Text(e.amount.toString(),
                                                                ))),
                                                            VerticalDivider(
                                                              color: Colors.grey.shade400,
                                                              thickness: 2,
                                                            ),
                                                          ],
                                                        )),
                                                        Text(
                                                            e.referenceNumber ?? "None",
                                                            style: Styles.smallGreyText(context)),
                                                        Text(
                                                            DateFormat.yMd()
                                                                .format(e.paymentDate!).toString(),
                                                            style: Styles.smallGreyText(context)),
                                                      ]))
                                                  .toList()),
                                          Divider(
                                            thickness: 1,
                                          ),
                                        ]),
                                  ),
                                ),
                              )
                            : Container():SizedBox(),

                        // SizedBox(height: 10,),
                        // orderDetailsController.orderData.orderStatus != "Pending"?SizedBox():distributorsModel == null?SizedBox():distributorsModel!.id == 1?SizedBox():Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text("Supplier: ${distributorsModel!.name}", style: TextStyle(color: Colors.black54),)),
                        // orderDetailsController.orderData.orderStatus == "DELIVERED"?SizedBox():distributorsModel == null?SizedBox():distributorsModel!.id == 1?SizedBox():Row(
                        //   children: [
                        //     Checkbox(
                        //         value: partiallyDelivered,
                        //         onChanged: (value){
                        //           setState(() {
                        //             partiallyDelivered = value!;
                        //           });
                        //         }),
                        //     Text("Partially Delivered")
                        //   ],
                        // ),
                        // orderDetailsController.orderData.orderStatus == "Pending"?SizedBox(): distributorsModel == null?SizedBox():distributorsModel!.id != 1?isLoading?Center(child: CircularProgressIndicator()):FullWidthButton(
                        //     text: partiallyDelivered?"Mark as Partially Delivered":"Mark As Delivered",
                        //     action: ()async{
                        //       OrdersController ordersController = Get.find<OrdersController>();
                        //       setState(() {
                        //         isLoading = true;
                        //       });
                        //       try{
                        //         // await ref.read(clientProvider).post("/checkin/change/distributor/status", data:{
                        //         //   "order_code": orderCode,
                        //         //   "order_status": partiallyDelivered?"Partial delivery":"DELIVERED"
                        //         // });
                        //         await ordersController.getUserOrders();
                        //         showCustomSnackBar("Success", isError: false);
                        //         ordersController.update();
                        //         setState(() {
                        //           isLoading = false;
                        //         });
                        //       }catch(e){
                        //         showCustomSnackBar("An error occurred", isError: true);
                        //         setState(() {
                        //           isLoading = false;
                        //         });
                        //       }
                        //
                        //     }
                        // ):SizedBox(),
                        showStatus?orderDetailsController.orderData.distributor!=null?orderDetailsController.orderData.distributor!.id != 1 && orderDetailsController.orderData.orderStatus == "Pending Delivery" && orderDetailsController.orderData.orderType == "Pre Order"?Center(
                          child: Container(
                            width: double.infinity, // Make the container full width
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey[200],
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedStatus,
                                isExpanded: true, // Expand the dropdown to fill the container width
                                items: ["Complete Delivery", "Partial Delivery", "Not Delivered"].map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                onChanged: (selectedItem) {
                                  setState(() {
                                    selectedStatus = selectedItem!;
                                  });
                                },
                              ),
                            ),
                          ),):SizedBox():SizedBox():SizedBox(),
                        SizedBox(height: 20,),
                        showStatus?isLoading?Center(child: CircularProgressIndicator()):orderDetailsController.orderData.distributor!=null?orderDetailsController.orderData.distributor!.id != 1 && orderDetailsController.orderData.orderStatus == "Pending Delivery" && orderDetailsController.orderData.orderType == "Pre Order"?FullWidthButton(
                            text: "Change Delivery Status",
                            action: ()async{
                              OrdersController ordersController = Get.find<OrdersController>();
                              setState(() {
                                isLoading = true;
                              });
                              try{
                                await ref.read(clientProvider).post("/checkin/change/distributor/status", data:{
                                  "order_code": orderCode,
                                  "order_status": selectedStatus == "Partial Delivery"
                                      ?"Partial delivery"
                                      :selectedStatus == "Complete Delivery"?"DELIVERED"
                                      :"Not Delivered"
                                });
                                  await ordersController.getSalesOrders(customerId);
                                  await ordersController.getUserOrders();
                                showCustomSnackBar("Success", isError: false);
                                ordersController.update();

                                setState(() {
                                  isLoading = false;
                                });
                                Get.back();
                              }catch(e){
                                showCustomSnackBar("An error occurred", isError: true);
                                setState(() {
                                  isLoading = false;
                                });
                              }

                            }
                        ):SizedBox():SizedBox():SizedBox(),
                        SizedBox(height: 10,),
                        FullWidthButton(
                            text: "Back",
                            action: (){
                              Get.back();
                            })
                      ],
                    )),
              )),
        ),
      );
    });
  }
}

TableRow buildRow(List<Widget> cells) =>
    TableRow(children: cells.map((cell) => cell).toList());

class ChequePhotoDialogWidget extends ConsumerStatefulWidget {
  final TextEditingController amountController;
  final TextEditingController transactionIDController;
  final TextEditingController chequeNumberController;
  final String orderCode;
  final String customerId;
  const ChequePhotoDialogWidget({
    Key? key,
    required this.amountController,
    required this.transactionIDController,
    required this.chequeNumberController,
    required this.orderCode,
    required this.customerId,
  }) : super(key: key);

  @override
  ConsumerState<ChequePhotoDialogWidget> createState() =>
      _ChequePhotoDialogWidgetState();
}

class _ChequePhotoDialogWidgetState
    extends ConsumerState<ChequePhotoDialogWidget> {
  File? image;
  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 40);
    final pickedImageFile = File(pickedImage!.path);
    image = pickedImageFile;
    Navigator.pop(context);
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage!.path);
    image = pickedImageFile;
    setState(() {});
    Navigator.pop(context);
  }

  void _remove() {
    image = null;
    setState(() {});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(builder: (paymentController) {
      return AlertDialog(
        title: Text(
          "Take Photo of Receipt",
          textAlign: TextAlign.center,
          style: Styles.heading2(context),
        ),
        content: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Choose option',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Styles.appSecondaryColor),
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          InkWell(
                            onTap: _pickImageCamera,
                            splashColor: Colors.black,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.camera,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Camera',
                                  style: Styles.heading3(context),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: _pickImageGallery,
                            splashColor: Colors.black,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Gallery',
                                  style: Styles.heading3(context),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: _remove,
                            splashColor: Colors.black,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  'Remove',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          child: CircleAvatar(
            radius: defaultPadding(context) * 6.5,
            backgroundColor: Styles.appSecondaryColor,
            backgroundImage: image == null ? null : FileImage(image!),
            child: image == null
                ? CircleAvatar(
                    radius: defaultPadding(context) * 6,
                    backgroundColor: Styles.appBackgroundColor,
                    child: Icon(
                      Icons.camera_alt,
                      color: Styles.appSecondaryColor,
                      size: defaultPadding(context) * 5,
                    ),
                  )
                : null,
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.black, width: 0.5),
                          right: BorderSide(color: Colors.black, width: 1))),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: Styles.heading3(context)
                            .copyWith(color: Colors.black26),
                      )),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                    top: BorderSide(color: Colors.black, width: 0.5),
                  )),
                  child: TextButton(
                      onPressed: () async {
                        if (widget.amountController.text == "") {
                          showCustomSnackBar("Enter an amouunt", isError: true);
                        } else if (paymentController.paymentMethod ==
                                PaymentMethods.Cheque &&
                            widget.chequeNumberController.text == "") {
                          showCustomSnackBar("Enter cheque Number",
                              isError: true);
                        } else if (paymentController.paymentMethod ==
                                PaymentMethods.Mpesa &&
                            widget.transactionIDController.text == "") {
                          showCustomSnackBar("Enter M-pesa transactionID",
                              isError: true);
                        } else {
                          paymentController
                              .addOrderPayment(
                                  widget.orderCode,
                                  widget.amountController.text,
                                  widget.transactionIDController.text,
                                  paymentController.paymentMethod.toString())
                              .then((value) {
                            widget.amountController.clear();
                            widget.transactionIDController.clear();
                            widget.chequeNumberController.clear();
                            Get.find<OrderDetailsController>()
                                .getOrderDetails(widget.orderCode);
                            Get.find<OrdersController>()
                                .getSalesOrders(widget.customerId);
                            Get.find<OrdersController>()
                                .getVanOrders(widget.customerId);
                            Get.find<OrdersController>().update();
                          });
                        }
                      },
                      child: Text("Upload",
                          style: Styles.heading3(context)
                              .copyWith(color: Styles.appSecondaryColor))),
                ),
              ),
            ],
          )
        ],
      );
    });
  }
}
