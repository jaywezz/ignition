// import 'package:flutter/material.dart';
// import 'package:soko_flow/widgets/cards/customer_detail_list_card.dart';
// import 'package:soko_flow/widgets/cards/customer_list_card.dart';
//
// class CustomerDetailList extends StatelessWidget {
//   CustomerDetailList({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         shrinkWrap: true,
//         itemCount: mycustomers.length,
//         itemBuilder: (context, index) {
//           return CustomerDetailListCard(
//             action: () {},
//             children: [
//               mycustomers[index]['name'][0].toUpperCase(),
//               mycustomers[index]['name'],
//               mycustomers[index]['location'],
//             ],
//           );
//         });
//   }
//
//   final List<Map> mycustomers = [
//     {
//       'location': '26 Olengurone  Rd, Kileleshwa Nairobi',
//       'name': 'Malaika Shop'
//     },
//   ];
// }
