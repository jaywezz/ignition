import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/models/orders_details_model.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/components/customer_details.dart';
//import 'package:soko_flow/views/customers/customer_details.dart';

class PaymentListCard extends StatefulWidget {
  const PaymentListCard({Key? key}) : super(key: key);

  @override
  _PaymentListCardState createState() => _PaymentListCardState();
}

class _PaymentListCardState extends State<PaymentListCard> {
  bool _value = false;
  int val = -1;
  setlectedValue(value) {
    setState(() {
      val = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: DataTable(
          horizontalMargin: 10,
          dividerThickness: 0.5,
          columnSpacing: 20,
          border: const TableBorder(
            top: BorderSide(color: Colors.grey, width: 0.5),
            bottom: BorderSide(color: Colors.grey, width: 0.5),
            left: BorderSide(color: Colors.grey, width: 0.5),
            right: BorderSide(color: Colors.grey, width: 0.5),
            horizontalInside:
            BorderSide(color: Colors.grey, width: 0.5),
            verticalInside: BorderSide(color: Colors.grey, width: 0.5),
          ),
          columns:  [
            DataColumn(label: Text("#", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
            DataColumn(label: Text("Ref No.", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
            DataColumn(label: Text("Payment Method", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
            DataColumn(label: Text("Amount", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
            DataColumn(label: Text("Date Paid", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
          ],
          rows: List.generate(samplePaymentList.length,
                  (index) => productDataRow(samplePaymentList[index], index, context))),
    );
  }


  DataRow productDataRow(PaymentModel paymentData, index, BuildContext context) {
    return DataRow(
        selected: true,
        cells: [
          DataCell(Text((index + 1).toString())),
          DataCell(Text(paymentData.referenceNumber!)),
          DataCell(Text(paymentData.paymentMethod!)),
          DataCell(Text(paymentData.amount!)),
          // DataCell(Text(paymentData.balance!)),
          DataCell(Text(DateFormat.yMEd().format(paymentData.paymentDate!))),
          // DataCell(IconButton(
          //     onPressed: () {
          //
          //     },
          //     icon: Icon(
          //       Icons.info_outline_rounded,
          //       color: Styles.appPrimaryColor,
          //     ))),
        ]);
  }
}

final List<PaymentModel> samplePaymentList = [
  PaymentModel(
    amount: '100',
    balance: '50',
    bankCharges: 2.5,
    paymentDate: DateTime(2023, 7, 15),
    paymentMethod: 'Credit Card',
    referenceNumber: 'ABC123',
    orderId: 'ORD001',
    userId: 1,
    createdAt: DateTime(2023, 7, 15),
    updatedAt: DateTime(2023, 7, 15),
  ),
  PaymentModel(
    amount: '50',
    balance: '25',
    bankCharges: 1.5,
    paymentDate: DateTime(2023, 7, 16),
    paymentMethod: 'PayPal',
    referenceNumber: 'XYZ456',
    orderId: 'ORD002',
    userId: 2,
    createdAt: DateTime(2023, 7, 16),
    updatedAt: DateTime(2023, 7, 16),
  ),
  PaymentModel(
    amount: '200',
    balance: '100',
    bankCharges: 3.0,
    paymentDate: DateTime(2023, 7, 17),
    paymentMethod: 'Google Pay',
    referenceNumber: 'DEF789',
    orderId: 'ORD003',
    userId: 3,
    createdAt: DateTime(2023, 7, 17),
    updatedAt: DateTime(2023, 7, 17),
  ),
  // Add more PaymentModel objects as needed...
  PaymentModel(
    amount: '75',
    balance: '30',
    bankCharges: 2.0,
    paymentDate: DateTime(2023, 7, 18),
    paymentMethod: 'Venmo',
    referenceNumber: 'GHI456',
    orderId: 'ORD004',
    userId: 4,
    createdAt: DateTime(2023, 7, 18),
    updatedAt: DateTime(2023, 7, 18),
  ),
  PaymentModel(
    amount: '120',
    balance: '60',
    bankCharges: 1.8,
    paymentDate: DateTime(2023, 7, 19),
    paymentMethod: 'Credit Card',
    referenceNumber: 'JKL123',
    orderId: 'ORD005',
    userId: 5,
    createdAt: DateTime(2023, 7, 19),
    updatedAt: DateTime(2023, 7, 19),
  ),
  // Add more PaymentModel objects as needed...
];
