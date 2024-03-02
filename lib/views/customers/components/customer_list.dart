// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:skeletons/skeletons.dart';
//
// import 'package:soko_flow/views/errors/empty_failure_no_internet_view.dart';
// import 'package:soko_flow/widgets/cards/customer_list_card.dart';
//
// class CustomerList extends GetView {
//   CustomerList({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (controller.isDataProcessing.value == true) {
//         return SkeletonListView();
//       } else {
//         if (controller.lstcustomers.isNotEmpty) {
//           //print(controller.lstTask);
//           print("There are ${controller.lstcustomers.length} Customers");
//           return ListView.builder(
//               controller: controller.scrollController,
//               itemCount: controller.lstcustomers.length,
//               itemBuilder: ((context, index) {
//                 if (index == controller.lstcustomers.length - 1 &&
//                     controller.isMoreDataAvailable.value == true) {
//                   return Center(
//                     child: Platform.isAndroid
//                         ? const CircularProgressIndicator()
//                         : const CupertinoActivityIndicator(),
//                   );
//                 }
//
//                 return CustomerListCard(
//                   action: () {
//                     //Get.to(CustomerDetailsScreen());
//                   },
//                   children: [
//                     controller.lstcustomers[index].customerName![0]
//                         .toUpperCase(),
//                     //mycustomers[index]['name'][0].toUpperCase(),
//                     controller.lstcustomers[index].customerName!,
//                     //mycustomers[index]['name'],
//                     controller.lstcustomers[index].address ?? "Nairobi",
//                     //mycustomers[index]['location'],
//                   ],
//                 );
//               }));
//         } else {
//           return SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: EmptyFailureNoInternetView(
//               image: 'lottie/failure_lottie.json',
//               title: 'Error',
//               description: "Error Occurred",
//               buttonText: "Retry",
//               onPressed: () {
//                 controller.getCustomers(20);
//               },
//             ),
//           );
//         }
//       }
//     });
//
//     //     controller.obx(
//     //   (state) => ListView.builder(
//     //     controller: controller.scrollController,
//     //     physics: BouncingScrollPhysics(),
//     //     shrinkWrap: true,
//     //     itemCount: state!.length,
//     //     itemBuilder: (context, index) {
//     //       print("There are ${controller.lstcustomers.length} Customers");
//     //       if (index == controller.lstcustomers.length - 1 &&
//     //           controller.isMoreDataAvailable.value == true) {
//     //         return SkeletonListTile();
//     //       }
//     //       return CustomerListCard(
//     //         action: () {},
//     //         children: [
//     //           state[index].customerName![0].toUpperCase(),
//     //           //mycustomers[index]['name'][0].toUpperCase(),
//     //           state[index].customerName!,
//     //           //mycustomers[index]['name'],
//     //           state[index].address!,
//     //           //mycustomers[index]['location'],
//     //         ],
//     //       );
//     //     },
//     //   ),
//     //   onLoading: SkeletonListView(),
//     //   onError: (error) => SingleChildScrollView(
//     //     physics: BouncingScrollPhysics(),
//     //     child: EmptyFailureNoInternetView(
//     //       image: 'lottie/failure_lottie.json',
//     //       title: 'Error',
//     //       description: error.toString(),
//     //       buttonText: "Retry",
//     //       onPressed: () {
//     //         controller.getCustomers(20);
//     //       },
//     //     ),
//     //   ),
//     //   onEmpty: EmptyFailureNoInternetView(
//     //     image: 'lottie/empty_lottie.json',
//     //     title: 'Content unavailable',
//     //     description: 'Content not found',
//     //     buttonText: "Retry",
//     //     onPressed: () {
//     //       controller.getCustomers(20);
//     //     },
//     //   ),
//     // );
//   }
//
//   final List<Map> mycustomers = [
//     {'location': '23 Olengurone  Rd, Kileleshwa Nairobi', 'name': 'Maa Shop'},
//     {'location': 'Juja Rd, Nairobi', 'name': 'Kenya Mpya Supermarket'},
//     {'location': '634 Kenyatta Rd, Juja', 'name': 'Pandora'},
//     {'location': 'Jamia Mall, Nairobi', 'name': 'Malaika Mbili'},
//     {'location': '8th Street Eastleigh, Nairobi', 'name': 'Nani\'s Place'},
//     {'location': 'Jumba kTom Mboya Street, Nairobi', 'name': 'Kibeti Kubwa'},
//     {'location': '876 Kilimani Rd, Nairobi', 'name': 'Lenga Bazuu'},
//     {'location': 'Prestige Plaza, Ngong Rd Nairobi', 'name': 'Bonny\'s'},
//     {'location': 'Kenyatta Ave, Nairobi', 'name': 'Chota Profits'},
//     {'location': '901 Statehouse Rd, Nairobi', 'name': 'Dunia Ndogo'},
//     {'location': 'Moktar Dada Rd, Nairobi', 'name': 'Kaka Kola'},
//   ];
// }
