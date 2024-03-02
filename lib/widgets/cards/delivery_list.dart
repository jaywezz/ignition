// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:soko_flow/configs/constants.dart';
// import 'package:soko_flow/configs/styles.dart';
// import 'package:soko_flow/services/navigation_services.dart';
// import 'package:soko_flow/utils/size_utils2.dart';
// import 'package:soko_flow/views/deliveries/detailed_delivery/detailed_delivery_screen.dart';
//
// class DeliveryListCard extends StatelessWidget {
//   DeliveryListCard({Key? key, this.children, this.action}) : super(key: key);
//   var children;
//   var action;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         action();
//         Get.to(DetailedDeliveryScreen());
//       },
//       child: Card(
//         elevation: 5,
//         child: Container(
//           child: Row(
//             //crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(
//                 flex: 5,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         children[1],
//                         style: Styles.heading2(context),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         children[2],
//                         style: Styles.smallGreyText(context),
//                         maxLines: 3,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         children[3],
//                         style: Styles.heading3(context)
//                             .copyWith(color: Styles.appYellowColor),
//                         maxLines: 3,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Flexible(
//                 flex: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 5),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // const SizedBox(
//                       //   height: 10,
//                       // ),
//                       Icon(
//                         Icons.more_vert,
//                         color: Colors.black,
//                         size: 30.0,
//                       ),
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       Text(
//                         children[4],
//                         style: Styles.heading4(context)
//                             .copyWith(color: Colors.black),
//                         maxLines: 3,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           padding: EdgeInsets.all(defaultPadding(context) * 0.2),
//           width: double.infinity,
//         ),
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(defaultPadding(context))),
//       ),
//     );
//   }
// }
