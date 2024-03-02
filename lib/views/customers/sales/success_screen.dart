import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/payment_controller.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/currency_formatter.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:http/http.dart' as http;
import 'package:soko_flow/views/customers/components/methodPayments.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  int? customerId;
  String? customerName;
  String? customerAddress;
  String? customerEmail;
  String? customerPhone;
  String? checkingCode;

  bool isLoading = false;

  int _key =0;

  // Initial Selected Value
  String dropdownvalue = 'Select Payment Method';

  // List of items in our dropdown menu
  // PaymentMethods? _paymentMethods = PaymentMethods.Mpesa;
  TextEditingController amountController = TextEditingController();
  TextEditingController transactionIDController = TextEditingController();
  TextEditingController chequeNumberController = TextEditingController();



  String order_id = "";
  double total_amount = 0;
  double paid = 0;

  Future getCustomerData() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    checkingCode = await prefs.getString('checkinCode');
    customerId = await prefs.getInt('customerId');
    customerName = await prefs.getString('customerName');
    customerAddress =await prefs.getString('customerAddress');
    customerEmail = await prefs.getString('customerEmail');
    customerPhone = await prefs.getString('customerPhone');
  }
  
  removeCheckinPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('checkinCode');
    prefs.remove('customerId');
    prefs.remove('customerName');
    prefs.remove('customerAddress');
    prefs.remove('customerEmail');
    prefs.remove('customerPhone');
  }

  showSnackBar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
    );
  }
  Future _customerCheckout(String checkinCode) async {
    try {
      final response = await http.get(Uri.parse(
          "http://172.104.245.14/sokoflowadmin/api/checkin/${checkinCode}/out"));
      print("Response StatusCode---> ${response.statusCode}");
      if (response.statusCode == 200) {
        showSnackBar(
            "Success",
            "You have successfully checked out.",
            // Colors.blue,
            Styles.appPrimaryColor);

        await removeCheckinPrefs();
        
        return json.decode(response.body);
      } else {
        showSnackBar(
          "Failed",
          "Checkout failed, Please try again.....",
          Colors.red,
        );
      }
    } catch (e) {
      showSnackBar("Exception", "${e.toString()}", Colors.red);
      return Future.error(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if(Get.arguments['order_id'] != null){
      setState(() {
        order_id = Get.arguments['order_id'];
      });

      print(order_id);
    }
    if(Get.arguments['total_amount'] != null){
      setState(() {
       total_amount = Get.arguments['total_amount'];
      });
    }
    setState(() {
      isLoading = true;
    });
    getCustomerData().then((value) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading? CircularProgressIndicator():Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.only(
                left: defaultPadding(context),
                right: defaultPadding(context),
                bottom: defaultPadding(context)),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
                borderRadius:
                BorderRadius.only(bottomLeft: Radius.circular(30))),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: defaultPadding(context),
                    ),
                    Stack(
                      children: [
                        Material(
                          child: InkWell(
                            splashColor: Theme.of(context).splashColor,
                            onTap: () => Get.toNamed(
                                RouteHelper.getCustomerDetails()),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Styles.darkGrey,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Order Success',
                            style: Styles.heading2(context),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Material(
                            child: InkWell(
                              splashColor: Theme.of(context).splashColor,
                              onTap: () async{
                                await _customerCheckout(checkingCode!);
                                Get.offNamed(RouteHelper.getInitial());
                              },
                              child: Icon(
                                Icons.home_sharp,
                                size: defaultPadding(context) * 2,
                                color: Styles.appPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: defaultPadding(context),
                    ),
                    Text(
                      'Successfully placed order',
                      style: Styles.heading2(context),
                    ),
                    SizedBox(
                      height: defaultPadding(context),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.shop,
                          color: Styles.appPrimaryColor,
                        ),
                        SizedBox(
                          width: defaultPadding(context),
                        ),
                        Text(
                          'Shop',
                          style: Styles.heading4(context),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_city_rounded,
                          color: Styles.appPrimaryColor,
                        ),
                        SizedBox(
                          width: defaultPadding(context),
                        ),
                        Text(
                          customerAddress!,
                          style: Styles.heading4(context),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Styles.appPrimaryColor,
                        ),
                        SizedBox(
                          width: defaultPadding(context),
                        ),
                        Text(
                          'Owner: ${customerEmail}',
                          style: Styles.heading4(context),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.credit_card,
                          color: Styles.appPrimaryColor,
                        ),
                        SizedBox(
                          width: defaultPadding(context),
                        ),
                        Text(
                          'Credit Limit: 3,789',
                          style: Styles.heading4(context),
                        )
                      ],
                    ),

                    Center(child: Lottie.asset('lottie/done.json', height: MediaQuery.of(context).size.height *.2)),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total (Ksh. )", style: Styles.heading2(context).copyWith(fontWeight: FontWeight.bold,),),
                          Text(formatCurrency.format(total_amount), style: Styles.heading1(context).copyWith(color: Styles.appYellowColor,),)
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(20.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text("Paid (Ksh. )", style: Styles.heading2(context).copyWith(fontWeight: FontWeight.bold,),),
                    //       Text(formatCurrency.format(paid), style: Styles.heading1(context).copyWith(color: Styles.appPrimaryColor,),)
                    //     ],
                    //   ),
                    // ),

                    total_amount != 0.0?GetBuilder<PaymentController>(
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
                                      child:isLoading?CircularProgressIndicator():Text("Submit Payment", style: Styles.buttonText2(context).copyWith(color: Colors.white)),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(defaultRadius1)),
                                      onPressed: () {
                                        print("amount: ${amountController.text}");
                                        if(amountController.text == ""){
                                          showCustomSnackBar("Enter an amount", isError: true);
                                        }else if(paymentController.paymentMethod == PaymentMethods.Cheque && chequeNumberController.text == ""){
                                          showCustomSnackBar("Enter cheque Number", isError: true);
                                        }
                                        else if(paymentController.paymentMethod == PaymentMethods.Mpesa && transactionIDController.text == ""){
                                          showCustomSnackBar("Enter M-pesa transactionID", isError: true);
                                        }else{
                                          print("order id: ${order_id}");
                                          paymentController.addOrderPayment(order_id,
                                              amountController.text, transactionIDController.text,
                                              paymentController.paymentMethod.toString()).then((value) {
                                            amountController.clear();
                                            transactionIDController.clear();
                                            chequeNumberController.clear();
                                            // setState(() {
                                            //   paid = paid + int.parse(transactionIDController.text);
                                            // });
                                            Get.offNamed(RouteHelper.orderDetailsScreen(), arguments: {
                                              "orderCode": order_id,
                                              "customer_id": Get.arguments['customer_id'].toString()
                                            });
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
                    ):Container(),


                    SizedBox(height: 30,),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: MaterialButton(
                        color: Styles.appPrimaryColor,
                        height: Responsive.isMobile(context) && Responsive.isMobileLarge(context)
                            ? 40
                            : 60,
                        //SizeConfig.isTabletWidth ? 70 : 50,
                        child: Text("Go back to Customer", style: Styles.buttonText2(context).copyWith(color: Colors.orange)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () {
                          Get.offNamed(
                              RouteHelper.getCustomerDetails());
                        },
                      ),
                    )



                  ],
                ),
              ),
            ))
      ),
    );
  }
}


class MethodPayments extends StatefulWidget {
  const MethodPayments({Key? key}) : super(key: key);

  @override
  State<MethodPayments> createState() => _MethodPaymentsState();
}

class _MethodPaymentsState extends State<MethodPayments> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(
        builder: (paymentController) {
          return AlertDialog(
            title: Text(
              "Payment Methods", style: Styles.heading2(context),
            ),
            content: Container(
              width: double.maxFinite,
              height: 150,
              child: ListView(
                children: [
                  ListTile(
                    title: Text('M-pesa', style: Styles.heading3(context),),
                    leading: Radio<PaymentMethods>(
                      activeColor: Styles.appPrimaryColor,
                      value: PaymentMethods.Mpesa,
                      groupValue: paymentController.paymentMethod,
                      onChanged: (PaymentMethods? value) {
                        print("on changed pressed");
                        // setState(() {
                        //   _paymentMethods = value;
                        // });
                        paymentController.paymentMethod = PaymentMethods.Mpesa;
                        paymentController.update();
                        print("the payment method : ${paymentController.paymentMethod}");
                      },
                    ),
                    trailing: Image.asset("assets/images/mpesat.png", height: 30, width: 30,),
                  ),
                  ListTile(
                    title: Text('Cash', style: Styles.heading3(context)),
                    leading: Radio<PaymentMethods>(
                      activeColor: Styles.appPrimaryColor,
                      value: PaymentMethods.Cash,
                      groupValue: paymentController.paymentMethod,
                      onChanged: (PaymentMethods? value) {
                        // setState(() {
                        //   _paymentMethods = value;
                        // });

                        paymentController.paymentMethod = value!;
                        paymentController.update();
                      },
                    ),
                    trailing:Icon(Icons.money),
                  ),

                  ListTile(
                    title: Text('Cheque', style: Styles.heading3(context)),
                    leading: Radio<PaymentMethods>(
                      activeColor: Styles.appPrimaryColor,
                      value: PaymentMethods.Cheque,
                      groupValue: paymentController.paymentMethod,
                      onChanged: (PaymentMethods? value) {
                        // setState(() {
                        //   _paymentMethods = value;
                        // });
                        paymentController.paymentMethod = value!;
                        paymentController.update();
                      },
                    ),
                    trailing: Image.asset("assets/images/cheque.jpg", height: 30, width: 30),
                  ),

                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Done", style: Styles.heading3(context).copyWith(color: Styles.appYellowColor),),
                onPressed: () => Get.back(),
              ),
            ],
          );
        }
    );
  }
}




