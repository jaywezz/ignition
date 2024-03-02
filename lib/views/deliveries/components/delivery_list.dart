// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:soko_flow/logic/controllers/user_deliveries_provider.dart';
// import 'package:soko_flow/widgets/cards/customer_list_card.dart';
// import 'package:soko_flow/widgets/cards/delivery_list.dart';

// class DeliveryList extends StatelessWidget {
//   DeliveryList();

//   @override
//   Widget build(BuildContext context) {
//     final deliveryCtrl =
//         Provider.of<UserDeliveriesProvider>(context, listen: false);

//     return FutureBuilder(
//         future: deliveryCtrl.fetchUserDeliveries(), // async work
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           print("User Deli Length: ${deliveryCtrl.deliverieslst}");
//           return ListView.builder(
//               shrinkWrap: true,
//               itemCount: deliveryCtrl.deliverieslst.length,
//               // mydeliveries.length,
//               itemBuilder: (context, index) {
//                 return DeliveryListCard(
//                   action: () {},
//                   children: [
//                     mydeliveries[index]['name'][0].toUpperCase(),
//                     mydeliveries[index]['name'],
//                     mydeliveries[index]['description'],
//                     mydeliveries[index]['price'],
//                     mydeliveries[index]['time'],
//                     mydeliveries[index]['date'],
//                   ],
//                 );
//               });
//         });
//   }

//   final List<Map> mydeliveries = [
//     {
//       'name': 'Maa Shop',
//       'description': '600 Cans of Coke Zero 500ML',
//       'price': 'Ksh.12,600',
//       'time': '9.00am',
//       'date': 'January 10, 2022'
//     },
//     {
//       'name': 'Pandora Ltd',
//       'description': '130 Cans of Monsters 250ML',
//       'price': 'Ksh.8,800',
//       'time': '11.00am'
//     },
//     {
//       'name': 'Pelican Bay',
//       'description': '20 Cans of Coke Zero 500ML',
//       'price': 'Ksh.5,600',
//       'time': '9.30am'
//     },
//     {
//       'name': "Peter's",
//       'description': '60 Cans of Coke Zero 500ML',
//       'price': 'Ksh.4,600',
//       'time': '12.00pm'
//     },
//     {
//       'name': 'Maa Shop',
//       'description': '600 Cans of Coke Zero 500ML',
//       'price': 'Ksh.12,600',
//       'time': '9.00am',
//       'date': 'January 10, 2022'
//     },
//     {
//       'name': 'Pandora Ltd',
//       'description': '130 Cans of Monsters 250ML',
//       'price': 'Ksh.8,800',
//       'time': '11.00am'
//     },
//     {
//       'name': 'Pelican Bay',
//       'description': '20 Cans of Coke Zero 500ML',
//       'price': 'Ksh.5,600',
//       'time': '9.30am'
//     },
//     {
//       'name': "Peter's",
//       'description': '60 Cans of Coke Zero 500ML',
//       'price': 'Ksh.4,600',
//       'time': '12.00pm'
//     },
//   ];
// }
