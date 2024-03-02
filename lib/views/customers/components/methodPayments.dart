//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import 'package:soko_flow/configs/styles.dart';
// import 'package:soko_flow/controllers/payment_controller.dart';
//
// class MethodPayments extends StatefulWidget {
//   const MethodPayments({Key? key}) : super(key: key);
//
//   @override
//   State<MethodPayments> createState() => _MethodPaymentsState();
// }
//
// class _MethodPaymentsState extends State<MethodPayments> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<PaymentController>(
//         builder: (paymentController) {
//           return AlertDialog(
//             title: Text(
//               "Payment Methods", style: Styles.heading2(context),
//             ),
//             content: Container(
//               width: double.maxFinite,
//               height: 150,
//               child: ListView(
//                 children: [
//                   ListTile(
//                     title: Text('M-pesa', style: Styles.heading3(context),),
//                     leading: Radio<PaymentMethods>(
//                       activeColor: Styles.appPrimaryColor,
//                       value: PaymentMethods.Mpesa,
//                       groupValue: paymentController.paymentMethod,
//                       onChanged: (PaymentMethods? value) {
//                         print("on changed pressed");
//                         // setState(() {
//                         //   _paymentMethods = value;
//                         // });
//                         paymentController.paymentMethod = PaymentMethods.Mpesa;
//                         paymentController.update();
//                         print("the payment method : ${paymentController.paymentMethod}");
//                       },
//                     ),
//                     trailing: Image.asset("assets/images/mpesat.png", height: 30, width: 30,),
//                   ),
//                   ListTile(
//                     title: Text('Cash', style: Styles.heading3(context)),
//                     leading: Radio<PaymentMethods>(
//                       activeColor: Styles.appPrimaryColor,
//                       value: PaymentMethods.Cash,
//                       groupValue: paymentController.paymentMethod,
//                       onChanged: (PaymentMethods? value) {
//                         // setState(() {
//                         //   _paymentMethods = value;
//                         // });
//
//                         paymentController.paymentMethod = value!;
//                         paymentController.update();
//                       },
//                     ),
//                     trailing:Icon(Icons.money),
//                   ),
//
//                   ListTile(
//                     title: Text('Cheque', style: Styles.heading3(context)),
//                     leading: Radio<PaymentMethods>(
//                       activeColor: Styles.appPrimaryColor,
//                       value: PaymentMethods.Cheque,
//                       groupValue: paymentController.paymentMethod,
//                       onChanged: (PaymentMethods? value) {
//                         // setState(() {
//                         //   _paymentMethods = value;
//                         // });
//                         paymentController.paymentMethod = value!;
//                         paymentController.update();
//                       },
//                     ),
//                     trailing: Image.asset("assets/images/cheque.jpg", height: 30, width: 30),
//                   ),
//
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 child: Text("Done", style: Styles.heading3(context).copyWith(color: Styles.appYellowColor),),
//                 onPressed: () => Get.back(),
//               ),
//             ],
//           );
//         }
//     );
//   }
// }
//
//
//
