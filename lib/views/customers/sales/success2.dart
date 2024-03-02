import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/add_cart.dart';
import 'package:soko_flow/controllers/order_details_controller.dart';
import 'package:soko_flow/controllers/orders_controller.dart';
import 'package:soko_flow/controllers/payment_controller.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/order_history_screen.dart';
import 'package:soko_flow/views/customers/sales/components/loading_widget.dart';
import 'package:soko_flow/views/customers/sales/components/new_sales_order_list.dart';
import 'package:soko_flow/views/customers/sales/components/van_sales_order_list.dart';

import '../../../widgets/buttons/full_width_button.dart';

class Success2 extends StatefulWidget {
  const Success2({Key? key}) : super(key: key);

  @override
  State<Success2> createState() => _Success2State();
}



class _Success2State extends State<Success2> {

  final formatCurrency = new NumberFormat.currency(locale: "en_US",
      symbol: "");
  String orderCode = "";
  String customerId = "";
  // Initial Selected Value
  String dropdownvalue = 'Select Payment Method';
  int _key =0;

  // List of items in our dropdown menu

  TextEditingController amountController = TextEditingController();
  TextEditingController transactionIDController = TextEditingController();
  TextEditingController chequeNumberController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    if(Get.arguments["orderCode"] !=null){
      setState(() {
        orderCode = Get.arguments["orderCode"];
      });
    }
    if(Get.arguments["customer_id"] !=null){
      setState(() {
        customerId = Get.arguments["customer_id"];
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
                  child:  SingleChildScrollView(
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
                                      onTap: () => Get.toNamed(RouteHelper.getInitial()),
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


                            SizedBox(height: 10,),

                           GetBuilder<PaymentController>(
                                builder: (paymentController) {
                                  return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      decoration:BoxDecoration(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(20)
                                          ),
                                          // border: Border.all(color: Styles.appYellowColor),
                                          color: Styles.appPrimaryColor.withOpacity(.1)
                                      ),

                                      child: Theme(
                                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                        child: ExpansionTile(
                                          key: new Key(_key.toString()),
                                          iconColor: Styles.appPrimaryColor,
                                          textColor: Styles.appPrimaryColor,
                                          controlAffinity: ListTileControlAffinity.trailing,
                                          childrenPadding:
                                          const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                                          expandedCrossAxisAlignment: CrossAxisAlignment.end,
                                          maintainState: false,
                                          title: Text('Add Payment', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                          // contents
                                          children: [

                                            MaterialButton(
                                              color: Styles.appPrimaryColor,
                                              minWidth: double.infinity,
                                              height: Responsive.isMobile(context) && Responsive.isMobileLarge(context)
                                                  ? 40
                                                  : 60,
                                              //SizeConfig.isTabletWidth ? 70 : 50,
                                              child: paymentController.paymentMethod == PaymentMethods.Mpesa
                                                  ?Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  // Image.asset("assets/images/mpesat.png", height: 40, width: 40,),
                                                  SizedBox(width: 15,),
                                                  Text("M-Pesa", style: Styles.heading3(context).copyWith(color: Colors.orange)),
                                                ],

                                              )
                                                  :paymentController.paymentMethod == PaymentMethods.Cheque
                                                  ?Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  // Image.asset("assets/images/cheque.jpg", height: 40, width: 40,),
                                                  SizedBox(width: 15,),
                                                  Text("Cheque", style: Styles.heading3(context).copyWith(color: Colors.orange)),
                                                ],
                                              ):paymentController.paymentMethod == PaymentMethods.Cash
                                                  ?Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  // Icon(Icons.money, color: Colors.white,),
                                                  SizedBox(width: 15,),
                                                  Text("Cash", style: Styles.heading3(context).copyWith(color: Colors.orange)),
                                                ],
                                              ):Text("Select payment method", style: Styles.heading3(context).copyWith(color: Colors.orange)),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30)),
                                              onPressed: () {
                                                Get.dialog(
                                                    MethodPayments()
                                                );
                                              },
                                            ),
                                            Container(
                                              decoration:BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(20)
                                                  ),
                                                  // border: Border.all(color: Styles.appYellowColor),
                                                  color: Styles.appPrimaryColor
                                              ),

                                            ),
                                            SizedBox(height: 15,),
                                            Text("Amount", style: Styles.heading3(context).copyWith(color: Styles.appPrimaryColor),),
                                            // SizedBox(height: 5,),
                                            Container(
                                              height: 50,
                                              child: TextField(
                                                controller: amountController,
                                                onChanged: (String value){
                                                  if(int.parse(amountController.text) > int.parse(orderDetailsController.orderData.balance!)){
                                                    amountController.text = orderDetailsController.orderData.balance!.toString();
                                                    showCustomSnackBar("Amount entered is more than the pending amount", isError: true);
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  icon: Icon(Icons.edit, color: Styles.appPrimaryColor,), //icon of text field
                                                  labelText: "Enter Amount",
                                                  labelStyle: TextStyle(color: Colors.grey),
                                                  enabledBorder: OutlineInputBorder(

                                                      borderSide: BorderSide(color: Colors.orange),
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),//label text of field
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Styles.appPrimaryColor),
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                ),
                                                keyboardType:TextInputType.number,
                                                //set it true, so that user will not able to edit text
                                              ),
                                            ),

                                            SizedBox(height: 10,),
                                            paymentController.paymentMethod == PaymentMethods.Mpesa
                                                ?Text("Transaction ID", style: Styles.heading3(context).copyWith(color: Styles.appPrimaryColor),)
                                                : paymentController.paymentMethod == PaymentMethods.Cheque? Text("Cheque Number", style: Styles.heading3(context).copyWith(color: Styles.appPrimaryColor),): Text(""),
                                            paymentController.paymentMethod == PaymentMethods.Mpesa
                                                ?Container(
                                              height: 50,
                                              child: TextField(
                                                controller: transactionIDController,
                                                decoration: InputDecoration(
                                                  icon: Icon(Icons.edit, color: Styles.appPrimaryColor,), //icon of text field
                                                  labelText: "Enter M-pesa Transaction ID",
                                                  labelStyle: TextStyle(color: Colors.grey),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.orange),
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),//label text of field
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Styles.appPrimaryColor),
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                ),
                                                //set it true, so that user will not able to edit text
                                              ),
                                            ): Container(),
                                            paymentController.paymentMethod == PaymentMethods.Cheque ?Container(
                                              height: 50,
                                              child: TextField(
                                                controller: chequeNumberController,
                                                decoration: InputDecoration(
                                                  icon: Icon(Icons.edit, color: Styles.appPrimaryColor,), //icon of text field
                                                  labelText: "Enter Cheque Number",
                                                  labelStyle: TextStyle(color: Colors.grey),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.orange),
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),//label text of field
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: Styles.appPrimaryColor),
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                ),
                                                //set it true, so that user will not able to edit text
                                              ),
                                            ): Container(),
                                            SizedBox(height: 20,),
                                            MaterialButton(
                                              color: Styles.appYellowColor,
                                              height: Responsive.isMobile(context) && Responsive.isMobileLarge(context)
                                                  ? 40
                                                  : 60,
                                              //SizeConfig.isTabletWidth ? 70 : 50,
                                              child: orderDetailsController.isLoading?CircularProgressIndicator():Text("Submit Payment", style: Styles.buttonText2(context).copyWith(color: Colors.white)),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(defaultRadius1)),
                                              onPressed: () {
                                                print("amount: ${amountController.text}");
                                                if(amountController.text == ""){
                                                  showCustomSnackBar("Enter an amouunt", isError: true);
                                                }else if(paymentController.paymentMethod == PaymentMethods.Cheque && chequeNumberController.text == ""){
                                                  showCustomSnackBar("Enter cheque Number", isError: true);
                                                }
                                                else if(paymentController.paymentMethod == PaymentMethods.Mpesa && transactionIDController.text == "") {
                                                  showCustomSnackBar(
                                                      "Enter M-pesa transactionID",
                                                      isError: true);
                                                }else{
                                                  paymentController.addOrderPayment(orderCode,
                                                      amountController.text, transactionIDController.text,
                                                      paymentController.paymentMethod.toString()).then((value) {
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
                                              },
                                            ),
                                            SizedBox(height: 10,),



                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                           )


                          ],

                        )
                    ),
                  )
              ),
            ),
          );
        }
    );
  }
}


