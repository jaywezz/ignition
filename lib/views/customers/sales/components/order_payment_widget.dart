import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/order_details_controller.dart';
import 'package:soko_flow/controllers/orders_controller.dart';
import 'package:soko_flow/controllers/payment_controller.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/order_details/order_details.dart';
import 'package:soko_flow/views/customers/order_history_screen.dart';

class OrderPaymentWidget extends StatefulWidget {
  const OrderPaymentWidget({Key? key}) : super(key: key);

  @override
  State<OrderPaymentWidget> createState() => _OrderPaymentWidgetState();
}

class _OrderPaymentWidgetState extends State<OrderPaymentWidget> {
  TextEditingController amountController = TextEditingController();
  TextEditingController transactionIDController = TextEditingController();
  TextEditingController chequeNumberController = TextEditingController();
  String orderCode = "";
  String customerId = "";
  int _key = 0;
  // Initial Selected Value
  String dropdownvalue = 'Select Payment Method';
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailsController>(
      builder: (orderDetailsController) {
        return Column(
          children: [
            orderDetailsController.isLoading
                ? CircularProgressIndicator()
                : int.parse(orderDetailsController
                .orderData.balance!) !=
                0.00
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
                                      style: Styles.heading3(context).copyWith(color: Colors.orange)),
                                ],
                              )
                                  : paymentController.paymentMethod == PaymentMethods.Cheque
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Image.asset("assets/images/cheque.jpg", height: 40, width: 40,),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text("Cheque",
                                      style: Styles.heading3(context).copyWith(color: Colors.orange)),
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
                                  Text("Cash", style: Styles.heading3(context).copyWith(color: Colors.orange)),
                                ],
                              )
                                  :paymentController.paymentMethod == PaymentMethods.BankTransfer
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon(Icons.money, color: Colors.white,),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text("Bank To Bank Transfer", style: Styles.heading3(context).copyWith(color: Colors.orange)),
                                ],
                              )
                                  : Text(
                                  "Select payment method",
                                  style: Styles.heading3(context).copyWith(color: Colors.orange)),
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
                                  if (int.parse(amountController.text) > int.parse(orderDetailsController.orderData.balance!)) {
                                    amountController.text = orderDetailsController.orderData.balance!.toString();
                                    showCustomSnackBar("Amount entered is more than the pending amount", isError: true);
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
                                      borderSide: BorderSide(color: Colors.orange),
                                      borderRadius: BorderRadius.circular(10)), //label text of field
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Styles.appSecondaryColor),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                keyboardType: TextInputType.number,
                                //set it true, so that user will not able to edit text
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            paymentController.paymentMethod == PaymentMethods.Mpesa
                                ? Text("Transaction ID",
                              style: Styles.heading3(context).copyWith(color: Styles.appSecondaryColor),
                            )
                                : paymentController.paymentMethod == PaymentMethods.Cheque
                                ? Text("Cheque Number", style: Styles.heading3(context).copyWith(color: Styles.appSecondaryColor),)
                                : Text(""),
                            paymentController.paymentMethod == PaymentMethods.Mpesa
                                ? Container(
                              height: 50,
                              child: TextField(
                                controller: transactionIDController,
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Styles.appSecondaryColor,
                                  ), //icon of text field
                                  labelText: "Enter M-pesa Transaction ID",
                                  labelStyle: TextStyle(
                                      color: Colors.grey),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.orange),
                                      borderRadius: BorderRadius.circular(10)), //label text of field
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Styles.appSecondaryColor),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                //set it true, so that user will not able to edit text
                              ),
                            )
                                : Container(),
                            paymentController.paymentMethod ==
                                PaymentMethods.Cheque || paymentController.paymentMethod == PaymentMethods.BankTransfer
                                ? Container(
                              height: 50,
                              child: TextField(
                                controller: chequeNumberController,
                                decoration:
                                InputDecoration(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Styles.appSecondaryColor,
                                  ), //icon of text field
                                  labelText: paymentController.paymentMethod == PaymentMethods.BankTransfer?"Enter TransactionId":"Enter Cheque Number",
                                  labelStyle: TextStyle(
                                      color: Colors.grey),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.orange),
                                      borderRadius:
                                      BorderRadius.circular(10)), //label text of field
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Styles.appSecondaryColor),
                                      borderRadius:
                                      BorderRadius.circular(10)),
                                ),
                                //set it true, so that user will not able to edit text
                              ),
                            )
                                : Container(),
                            SizedBox(
                              height: 20,
                            ),
                            MaterialButton(
                              color: Styles.appSecondaryColor,
                              height: Responsive.isMobile(context) && Responsive.isMobileLarge(context) ? 40 : 60,
                              //SizeConfig.isTabletWidth ? 70 : 50,
                              child: orderDetailsController.isLoading ? CircularProgressIndicator()
                                  : Text(paymentController.paymentMethod == PaymentMethods.Cheque?"Upload Cheque Photo":"Submit Payment",
                                  style: Styles.buttonText2(context).copyWith(fontSize:15,color: Colors.white)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(defaultRadius1)),
                              onPressed: () {
                                print("amount: ${amountController.text}");
                                if(paymentController.paymentMethod == PaymentMethods.Cheque){
                                  showDialog(context: context, builder: (context){
                                    return ChequePhotoDialogWidget(amountController: amountController, transactionIDController: transactionIDController, chequeNumberController: chequeNumberController, orderCode: orderCode, customerId: customerId);
                                  });
                                }else{
                                  if (amountController.text == "") {
                                    showCustomSnackBar("Enter an amouunt", isError: true);
                                  } else if (paymentController.paymentMethod == PaymentMethods.Cheque && chequeNumberController.text == "") {
                                    showCustomSnackBar("Enter cheque Number", isError: true);
                                  } else if (paymentController.paymentMethod == PaymentMethods.Mpesa &&
                                      transactionIDController.text == "") {
                                    showCustomSnackBar("Enter M-pesa transactionID", isError: true);
                                  } else {
                                    paymentController.addOrderPayment(orderCode, amountController.text, transactionIDController.text,
                                        paymentController.paymentMethod.toString())
                                        .then((value) {
                                      amountController.clear();
                                      transactionIDController.clear();
                                      chequeNumberController.clear();
                                      orderDetailsController.getOrderDetails(orderCode);
                                      Get.find<OrdersController>().getSalesOrders(customerId);
                                      Get.find<OrdersController>().getVanOrders(customerId);
                                      setState(() {
                                        _key++;
                                      });
                                      Get.find<OrdersController>().update();
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
                : Container(),

            orderDetailsController.orderData.balance != orderDetailsController.orderData.priceTotal
                ?Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                decoration:BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(20)
                    ),
                    // border: Border.all(color: Styles.appYellowColor),
                    color: Styles.appSecondaryColor.withOpacity(.1)
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                      iconColor: Styles.appSecondaryColor,
                      textColor: Styles.appSecondaryColor,
                      controlAffinity: ListTileControlAffinity.trailing,
                      childrenPadding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                      expandedCrossAxisAlignment: CrossAxisAlignment.end,
                      maintainState: true,
                      title: Text('View Payments', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
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
                              Text("Method", style: Styles.heading4(context),),
                              IntrinsicHeight(
                                  child:Row(

                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                      Container(
                                          width: 50,
                                          child: Center(child: Text('Amount', style: Styles.heading4(context),))),
                                      VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                    ],
                                  )),
                              Text("Ref No.", style: Styles.heading4(context),),
                              Text("Date. ", style: Styles.heading4(context),),
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
                            children: orderDetailsController.orderPayments.map((e) =>  buildRow(
                                [
                                  Text(e.paymentMethod == "PaymentMethods.Mpesa"?"M-pesa"
                                      :e.paymentMethod == "PaymentMethods.Cash"? "Cash"
                                      :e.paymentMethod == "PaymentMethods.Cheque"? "Cheque":"", style: Styles.smallGreyText(context),),
                                  IntrinsicHeight(
                                      child:Row(

                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                          Container(
                                              width: 50,
                                              child: Center(child: Text(e.amount.toString(),))), VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                        ],
                                      )),
                                  Text(e.referenceNumber ?? "None", style: Styles.smallGreyText(context)),
                                  Text(DateFormat.yMd().format(e.paymentDate!).toString(), style: Styles.smallGreyText(context)),
                                ]
                            )).toList()
                        ),

                        Divider(thickness: 1,),


                      ]
                  ),
                ),
              ),
            ): Container(),
          ],
        );
      }
    );
  }
}
