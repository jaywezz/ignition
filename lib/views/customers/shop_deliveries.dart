// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:skeletons/skeletons.dart';
// import 'package:soko_flow/configs/constants.dart';
// import 'package:soko_flow/configs/styles.dart';
// import 'package:soko_flow/database/models/customer_deliveries.dart';
// import 'package:soko_flow/database/models/customer_model.dart';
// import 'package:soko_flow/database/models/products_by_category_model.dart';
// import 'package:soko_flow/database/models/products_model.dart';
// import 'package:soko_flow/logic/controllers/customer_provider.dart';
// import 'package:soko_flow/logic/controllers/products_provider.dart';
// import 'package:soko_flow/logic/routes/routes.dart';
// import 'package:soko_flow/services/navigation_services.dart';
// import 'package:soko_flow/utils/size_utils2.dart';
// import 'package:soko_flow/views/errors/empty_failure_no_internet_view.dart';
// import 'package:soko_flow/widgets/buttons/full_width_button.dart';
// import 'package:soko_flow/widgets/buttons/van_sales_tab_button.dart';
// import 'package:soko_flow/widgets/custom_button.dart';
// import 'package:soko_flow/widgets/inputs/search_field.dart';

// class Deliveries extends StatefulWidget {
//   const Deliveries({Key? key}) : super(key: key);

//   @override
//   State<Deliveries> createState() => _DeliveriesState();
// }

// class _DeliveriesState extends State<Deliveries> {
//   int initPosition = 0;
//   List<String> options = [];
//   var newCategoryID;
//   var isLoading = false;
//   tabOptions(BuildContext context) async {
//     options.clear();
//     var controller = [
//       "All",
//       "Past 1 Month",
//       "Last 3 Months",
//       "Last 6 Months",
//       "Last 1 Year"
//     ];
//     for (var i = 0; i < controller.length; i++) {
//       options.add(controller[i]);
//     }
//     await options;
//   }

//   var productsInit;
//   var productsCategoryInit;
//   @override
//   void initState() {
//     setState(() {});
//     getInitialData(context);
//     super.initState();
//     tabOptions(context);
//   }

//   getInitialData(BuildContext context) {
//     final controller =
//         Provider.of<ProductCategoryProvider>(context, listen: false);
//     productsInit = controller.fetchProducts();
//     // productsCategoryInit = controller.fetchProductsByCategory(newCategoryID);
//   }

//   refreshFutureBuild(var catId) async {
//     Provider.of<ProductCategoryProvider>(context, listen: false)
//         .fetchProductCategory();
//     Provider.of<ProductCategoryProvider>(context, listen: false)
//         .fetchProductsByCategory(catId);
//   }

//   final bool isSelected = false;
//   @override
//   Widget build(BuildContext context) {
//     final controller =
//         Provider.of<ProductCategoryProvider>(context, listen: false);

//     return Scaffold(
//         body: SafeArea(
//       child: SizedBox(
//         height: double.infinity,
//         width: double.infinity,
//         child: Container(
//             padding: EdgeInsets.only(
//                 left: defaultPadding(context),
//                 right: defaultPadding(context),
//                 bottom: defaultPadding(context)),
//             decoration: const BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
//                 borderRadius:
//                     BorderRadius.only(bottomLeft: Radius.circular(30))),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: defaultPadding(context),
//                 ),
//                 Stack(
//                   children: [
//                     Material(
//                       child: InkWell(
//                         splashColor: Theme.of(context).splashColor,
//                         onTap: () => Navigator.pop(context),
//                         child: Icon(
//                           Icons.arrow_back_ios_new,
//                           color: Styles.darkGrey,
//                         ),
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Malaika Mbili Shop',
//                         style: Styles.heading2(context),
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: Material(
//                         child: InkWell(
//                           splashColor: Theme.of(context).splashColor,
//                           onTap: () => Get.toNamed(AppRoutes.home),
//                           child: Icon(
//                             Icons.home_sharp,
//                             size: defaultPadding(context) * 2,
//                             color: Styles.appPrimaryColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: defaultPadding(context),
//                 ),
//                 Text(
//                   'Deliveries',
//                   style: Styles.heading2(context),
//                 ),
//                 SizedBox(
//                   height: defaultPadding(context),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: defaultPadding(context) * 1.8),
//                   child: const LargeSearchField(
//                     hintText: 'Search By Product Name',
//                     outline: true,
//                   ),
//                 ),
//                 Expanded(
//                   child: FutureBuilder(
//                     future: controller.fetchProductCategory(),
//                     builder: (builder, AsyncSnapshot snapshot) {
//                       return CustomTabView(
//                         initPosition: initPosition,
//                         itemCount: options.length,
//                         tabBuilder: (context, index) {
//                           return Tab(
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 15,
//                               ),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(50),
//                                   border: Border.all(
//                                       color: Styles.appPrimaryColor, width: 1)),
//                               child: Align(
//                                 alignment: Alignment.center,
//                                 child: Text(options[index]),
//                               ),
//                             ),
//                           );
//                         },
//                         pageBuilder: (context, index) {
//                           if (options[index] == "All") {
//                             return FutureBuilder(
//                                 future: productsInit,
//                                 builder: (builder, snapshot) {
//                                   if (snapshot.hasError) {
//                                     return SingleChildScrollView(
//                                       physics: BouncingScrollPhysics(),
//                                       child: EmptyFailureNoInternetView(
//                                         image: 'lottie/failure_lottie.json',
//                                         title: 'No Deliveries',
//                                         description: "Error Occurred",
//                                         buttonText: "Retry",
//                                         onPressed: () {
//                                           Provider.of<ProductCategoryProvider>(
//                                                   context,
//                                                   listen: false)
//                                               .fetchProductCategory();
//                                           Provider.of<ProductCategoryProvider>(
//                                                   context,
//                                                   listen: false)
//                                               .fetchProducts();
//                                         },
//                                       ),
//                                     );
//                                   } else {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.done) {
//                                       if (snapshot.hasData) {
//                                         var data =
//                                             (snapshot.data as List<Product>)
//                                                 .toList();

//                                         Map<String, List<Product>> prodSorted =
//                                             {};
//                                         for (var i = 0; i < data.length; i++) {
//                                           if (prodSorted
//                                               .containsKey(data[i].category)) {
//                                             prodSorted[data[i].category]!
//                                                 .add(data[i]);
//                                           } else {
//                                             prodSorted[data[i]
//                                                 .category
//                                                 .toString()] = [data[i]];
//                                           }
//                                         }
//                                         print(prodSorted);
//                                         print(prodSorted.length);
//                                         return ListView.builder(
//                                             shrinkWrap: true,
//                                             itemCount: 200,
//                                             itemBuilder: (context, index) {
//                                               return Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Expanded(
//                                                       child: Align(
//                                                         alignment:
//                                                             Alignment.topLeft,
//                                                         child: Text(
//                                                             'Dasani ${index}',
//                                                             style: Styles
//                                                                 .smallGreyText(
//                                                                     context)),
//                                                       ),
//                                                     ),
//                                                     Expanded(
//                                                       child: Align(
//                                                         alignment:
//                                                             Alignment.center,
//                                                         child: Text('1L',
//                                                             style: Styles
//                                                                 .smallGreyText(
//                                                                     context)),
//                                                       ),
//                                                     ),
//                                                     Expanded(
//                                                       child: Align(
//                                                         alignment: Alignment
//                                                             .centerRight,
//                                                         child: Text('Ksh 2320',
//                                                             style: Styles
//                                                                 .smallGreyText(
//                                                                     context)),
//                                                       ),
//                                                     ),
//                                                   ]);
//                                             });
//                                       } else {
//                                         return SkeletonListView();
//                                       }
//                                     } else {
//                                       return SkeletonListView();
//                                     }
//                                   }
//                                 });
//                           } else {
//                             return FutureBuilder(
//                                 future: controller.fetchProducts(),
//                                 builder: (builder, snapshot) {
//                                   if (snapshot.hasError) {
//                                     return SingleChildScrollView(
//                                       physics: BouncingScrollPhysics(),
//                                       child: EmptyFailureNoInternetView(
//                                         image: 'lottie/failure_lottie.json',
//                                         title: 'No Deliveries',
//                                         description: "Error Occurred",
//                                         buttonText: "Retry",
//                                         onPressed: () {
//                                           setState(() {
//                                             isLoading = true;
//                                           });
//                                           refreshFutureBuild(
//                                             newCategoryID != null
//                                                 ? newCategoryID.toString()
//                                                 : controller.categorylst
//                                                     .where((element) =>
//                                                         element.name ==
//                                                         options[index])
//                                                     .first
//                                                     .id
//                                                     .toString(),
//                                           );
//                                         },
//                                       ),
//                                     );
//                                   } else {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.done) {
//                                       if (snapshot.hasData) {
//                                         var data =
//                                             (snapshot.data as List<Products>)
//                                                 .toList();
//                                         return ListView.builder(
//                                             shrinkWrap: true,
//                                             itemCount: 1,
//                                             itemBuilder: (context, index) {
//                                               return Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Expanded(
//                                                       child: Align(
//                                                         alignment:
//                                                             Alignment.topLeft,
//                                                         child: Text(
//                                                             'Dasani ${index}',
//                                                             style: Styles
//                                                                 .smallGreyText(
//                                                                     context)),
//                                                       ),
//                                                     ),
//                                                     Expanded(
//                                                       child: Align(
//                                                         alignment:
//                                                             Alignment.center,
//                                                         child: Text('1L',
//                                                             style: Styles
//                                                                 .smallGreyText(
//                                                                     context)),
//                                                       ),
//                                                     ),
//                                                     Expanded(
//                                                       child: Align(
//                                                         alignment: Alignment
//                                                             .centerRight,
//                                                         child: Text('Ksh 2320',
//                                                             style: Styles
//                                                                 .smallGreyText(
//                                                                     context)),
//                                                       ),
//                                                     ),
//                                                   ]);
//                                             });
//                                       } else {
//                                         return SkeletonListView();
//                                       }
//                                     } else {
//                                       return SkeletonListView();
//                                     }
//                                   }
//                                 });
//                           }
//                         },
//                         onPositionChange: (index) {
//                           print("Current Position: $index");
//                           if (index > 0) {
//                             var _trialCategoryID =
//                                 Provider.of<ProductCategoryProvider>(context,
//                                         listen: false)
//                                     .categorylst
//                                     .where((element) =>
//                                         element.name == options[index])
//                                     .first
//                                     .id;
//                             setState(() {
//                               newCategoryID = _trialCategoryID;
//                             });
//                           }
//                           initPosition = index;
//                         },
//                         onScroll: (position) =>
//                             print("Current Position: $position"),
//                         stub: Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                       );
//                     },
//                   ),
//                 )
//               ],
//             )),
//       ),
//     ));
//   }
// }

// //Implementation

// class CustomTabView extends StatefulWidget {
//   final int itemCount;
//   final IndexedWidgetBuilder tabBuilder;
//   final IndexedWidgetBuilder pageBuilder;
//   final Widget stub;
//   final ValueChanged<int> onPositionChange;
//   final ValueChanged<double> onScroll;
//   final int initPosition;

//   CustomTabView({
//     required this.itemCount,
//     required this.tabBuilder,
//     required this.pageBuilder,
//     required this.stub,
//     required this.onPositionChange,
//     required this.onScroll,
//     required this.initPosition,
//   });

//   @override
//   _CustomTabsState createState() => _CustomTabsState();
// }

// class _CustomTabsState extends State<CustomTabView>
//     with TickerProviderStateMixin {
//   late TabController controller;
//   late int _currentCount;
//   late int _currentPosition;

//   @override
//   void initState() {
//     _currentPosition = widget.initPosition;
//     controller = TabController(
//       length: widget.itemCount,
//       vsync: this,
//       initialIndex: _currentPosition,
//     );
//     controller.addListener(onPositionChange);
//     controller.animation!.addListener(onScroll);
//     _currentCount = widget.itemCount;
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(CustomTabView oldWidget) {
//     if (_currentCount != widget.itemCount) {
//       controller.animation!.removeListener(onScroll);
//       controller.removeListener(onPositionChange);
//       controller.dispose();

//       if (widget.initPosition != null) {
//         _currentPosition = widget.initPosition;
//       }

//       if (_currentPosition > widget.itemCount - 1) {
//         _currentPosition = widget.itemCount - 1;
//         _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
//         if (widget.onPositionChange is ValueChanged<int>) {
//           WidgetsBinding.instance!.addPostFrameCallback((_) {
//             if (mounted) {
//               widget.onPositionChange(_currentPosition);
//             }
//           });
//         }
//       }

//       _currentCount = widget.itemCount;
//       setState(() {
//         controller = TabController(
//           length: widget.itemCount,
//           vsync: this,
//           initialIndex: _currentPosition,
//         );
//         controller.addListener(onPositionChange);
//         controller.animation!.addListener(onScroll);
//       });
//     } else if (widget.initPosition != null) {
//       controller.animateTo(widget.initPosition);
//     }

//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   void dispose() {
//     controller.animation!.removeListener(onScroll);
//     controller.removeListener(onPositionChange);
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.itemCount < 1) return widget.stub;

//     return SizedBox(
//       height: double.infinity,
//       width: double.infinity,
//       child: SingleChildScrollView(
//         physics: NeverScrollableScrollPhysics(),
//         child: Container(
//           // padding: EdgeInsets.only(
//           //   left: defaultPadding(context),
//           //   right: defaultPadding(context),
//           //   bottom: defaultPadding(context),
//           // ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               // ==============================
//               Column(
//                 children: [
//                   SizedBox(
//                     width: double.infinity,
//                     height: 35,
//                     child: Container(
//                       // alignment: Alignment.center,
//                       child: TabBar(
//                         unselectedLabelColor: Styles.appPrimaryColor,
//                         isScrollable: true,
//                         controller: controller,
//                         labelColor: Colors.white,
//                         indicatorSize: TabBarIndicatorSize.label,
//                         indicator: BoxDecoration(
//                           borderRadius: BorderRadius.circular(60),
//                           color: Styles.appPrimaryColor,
//                         ),
//                         tabs: List.generate(
//                           widget.itemCount,
//                           (index) {
//                             return widget.tabBuilder(context, index);
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               // ===================================
//               Card(
//                 elevation: 4,
//                 child: Container(
//                     child: Column(
//                   children: [
//                     SizedBox(
//                       height: 3,
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: defaultPadding(context),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               'Product',
//                               style: Styles.heading3(context),
//                             ),
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Text(
//                                 'Quantity',
//                                 style: Styles.heading3(context),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Align(
//                               alignment: Alignment.topRight,
//                               child: Text(
//                                 'Amount',
//                                 style: Styles.heading3(context),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 3,
//                     ),
//                     SingleChildScrollView(
//                       child: SizedBox(
//                         height: MediaQuery.of(context).size.height,
//                         // child: Expanded(
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: defaultPadding(context),
//                           ),
//                           // margin: EdgeInsets.only(
//                           //   bottom: 3,
//                           // ),
//                           child: TabBarView(
//                             controller: controller,
//                             children: List.generate(
//                               widget.itemCount,
//                               (index) => widget.pageBuilder(context, index),
//                             ),
//                           ),
//                         ),
//                         // ),
//                       ),
//                     ),
//                   ],
//                 )),
//               )
//             ],
//           ),
//           // ==============================
//         ),
//       ),
//     );
//   }

//   onPositionChange() {
//     if (!controller.indexIsChanging) {
//       _currentPosition = controller.index;
//       if (widget.onPositionChange is ValueChanged<int>) {
//         widget.onPositionChange(_currentPosition);
//       }
//     }
//   }

//   onScroll() {
//     if (widget.onScroll is ValueChanged<double>) {
//       widget.onScroll(controller.animation!.value);
//     }
//   }
// }


// // class Deliveries extends StatefulWidget {
// //   const Deliveries({Key? key}) : super(key: key);

// //   @override
// //   State<Deliveries> createState() => _DeliveriesState();
// // }

// // class _DeliveriesState extends State<Deliveries> {
// //   @override
// //   Widget build(BuildContext context) {
// //     final controller = Provider.of<CustomersProvider>(context, listen: false);
// //     return Scaffold(
// //         body: SafeArea(
// //       child: FutureBuilder<CustomerDeliveriesModels>(
// //         future: context.read<CustomersProvider>().fetchCustomerDeliveries(2),
// //         builder: (context, snapShot) {
// //           if (snapShot.connectionState == ConnectionState.done) {
// //             return SizedBox(
// //               height: double.infinity,
// //               width: double.infinity,
// //               child: Container(
// //                 padding: EdgeInsets.only(
// //                     left: defaultPadding(context),
// //                     right: defaultPadding(context),
// //                     bottom: defaultPadding(context)),
// //                 decoration: const BoxDecoration(
// //                     borderRadius:
// //                         BorderRadius.only(bottomLeft: Radius.circular(30))),
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.start,
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     SizedBox(
// //                       height: defaultPadding(context),
// //                     ),
// //                     Stack(
// //                       children: [
// //                         Material(
// //                           child: InkWell(
// //                             splashColor: Theme.of(context).splashColor,
// //                             onTap: () => Navigator.pop(context),
// //                             child: Icon(
// //                               Icons.arrow_back_ios_new,
// //                               color: Styles.darkGrey,
// //                             ),
// //                           ),
// //                         ),
// //                         Align(
// //                           alignment: Alignment.center,
// //                           child: Text(
// //                             'Malaika Mbili Shop.',
// //                             style: Styles.heading2(context),
// //                           ),
// //                         ),
// //                         Align(
// //                           alignment: Alignment.topRight,
// //                           child: Material(
// //                             child: InkWell(
// //                               splashColor: Theme.of(context).splashColor,
// //                               onTap: () => Get.toNamed(AppRoutes.home),
// //                               child: Icon(
// //                                 Icons.home_sharp,
// //                                 size: defaultPadding(context) * 2,
// //                                 color: Styles.appPrimaryColor,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     // ============Stack end
// //                     SizedBox(
// //                       height: defaultPadding(context) * 1,
// //                     ),
// //                     Text(
// //                       'Deliveries',
// //                       style: Styles.heading2(context),
// //                     ),
// //                     SizedBox(
// //                       height: defaultPadding(context),
// //                     ),
// //                     Padding(
// //                       padding: EdgeInsets.symmetric(
// //                           horizontal: defaultPadding(context) * 1.8),
// //                       child: const LargeSearchField(
// //                         hintText: 'Search By Name',
// //                         outline: true,
// //                       ),
// //                     ),
// //                     Expanded(
// //                         child: Stack(
// //                       children: [
// //                         ListView(
// //                           shrinkWrap: true,
// //                           children: [
// //                             SizedBox(
// //                               height: defaultPadding(context) * .4,
// //                             ),
// //                             Responsive.isTablet(context)
// //                                 ? SizedBox(
// //                                     child: ListView.builder(
// //                                       shrinkWrap: true,
// //                                       itemBuilder: (context, index) {
// //                                         final cuisine =
// //                                             index < 5 ? cuisines1 : cuisines2;
// //                                         index = index < 5 ? index : index - 5;
// //                                         return Card(
// //                                           color: index == 2
// //                                               ? Styles.appPrimaryColor
// //                                               : Styles.appBackgroundColor,
// //                                           elevation: 8,
// //                                           child: Text(
// //                                             "${cuisine[index]["name"]}",
// //                                             style: TextStyle(
// //                                                 fontSize:
// //                                                     Styles.normalText(context)
// //                                                         .fontSize),
// //                                           ),
// //                                           margin:
// //                                               const EdgeInsets.only(right: 20),
// //                                         );
// //                                       },
// //                                       itemCount: 9,
// //                                       scrollDirection: Axis.horizontal,
// //                                     ),
// //                                     width: double.infinity,
// //                                     height: 120,
// //                                   )
// //                                 : Column(
// //                                     children: [
// //                                       SizedBox(
// //                                         child: ListView.builder(
// //                                           shrinkWrap: true,
// //                                           itemBuilder: (context, index) {
// //                                             return Container(
// //                                               decoration: BoxDecoration(
// //                                                   boxShadow: [
// //                                                     BoxShadow(
// //                                                       color: Colors.grey
// //                                                           .withOpacity(0.5),
// //                                                       spreadRadius: 0,
// //                                                       blurRadius: 0,
// //                                                       // offset: const Offset(0,
// //                                                       //     3), // changes position of shadow
// //                                                     ),
// //                                                   ],
// //                                                   color: index == 2
// //                                                       ? Styles.appPrimaryColor
// //                                                       : Styles
// //                                                           .appBackgroundColor,
// //                                                   borderRadius:
// //                                                       const BorderRadius.all(
// //                                                           Radius.circular(10))),
// //                                               child: Padding(
// //                                                 padding:
// //                                                     const EdgeInsets.all(8.0),
// //                                                 child: Text(
// //                                                     "${cuisines1[index]["name"]}",
// //                                                     style: TextStyle(
// //                                                       color: index == 2
// //                                                           ? Colors.white
// //                                                           : Colors.black,
// //                                                     )),
// //                                               ),
// //                                               margin: const EdgeInsets.only(
// //                                                   right: 20, bottom: 10),
// //                                             );
// //                                           },
// //                                           itemCount: 5,
// //                                           scrollDirection: Axis.horizontal,
// //                                         ),
// //                                         width: double.infinity,
// //                                         height: 40,
// //                                       ),
// //                                     ],
// //                                   ),
// //                             // ==============end of the navigation
// //                             SizedBox(
// //                               height: defaultPadding(context) * 1,
// //                             ),
// //                             Card(
// //                               child: Padding(
// //                                 padding: const EdgeInsets.all(8.0),
// //                                 child: Column(
// //                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: [
// //                                     Row(
// //                                       mainAxisAlignment:
// //                                           MainAxisAlignment.spaceBetween,
// //                                       children: [
// //                                         Text(
// //                                           'Product',
// //                                           style: Styles.heading3(context),
// //                                         ),
// //                                         Text(
// //                                           'Quantity',
// //                                           style: Styles.heading3(context),
// //                                         ),
// //                                         Text(
// //                                           'Amount',
// //                                           style: Styles.heading3(context),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                     ListView.builder(
// //                                       itemCount: snapShot.data!.data!.length,
// //                                       shrinkWrap: true,
// //                                       itemBuilder: (context, int index) {
// //                                         return ProductsWidget(
// //                                             text: 'Dasani',
// //                                             quantity: '1L',
// //                                             amount: 'Ksh 2,320');
// //                                       },
// //                                     )
// //                                   ],
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         )
// //                       ],
// //                     ))
// //                   ],
// //                 ),
// //               ),
// //             );
// //           } else {
// //             return Center(
// //               child: Platform.isAndroid
// //                   ? CircularProgressIndicator()
// //                   : CupertinoActivityIndicator(),
// //             );
// //           }
// //         },
// //       ),
// //     ));
// //   }

// //   final List cuisines2 = const [
// //     {"name": "Indian", "icon": "assets/icons/h.png"},
// //     {"name": "Italian", "icon": "assets/icons/i.png"},
// //     {"name": "kenyan", "icon": "assets/icons/d.png"},
// //     {"name": "French", "icon": "assets/icons/e.png"},
// //     {"name": "Ghanaian", "icon": "assets/icons/j.png"},
// //   ];

// //   final List cuisines1 = const [
// //     {"name": "All", "icon": "assets/icons/a.png"},
// //     {"name": "Past 1 Month", "icon": "assets/icons/b.png"},
// //     {"name": "Last 3 Months", "icon": "assets/icons/f.png"},
// //     {"name": "Last 6 Months", 'icon': "assets/icons/g.png"},
// //     {"name": "Last 1 year", "icon": "assets/icons/c.png"},
// //   ];
// // }

// // class ProductsWidget extends StatelessWidget {
// //   const ProductsWidget(
// //       {Key? key,
// //       required this.quantity,
// //       required this.text,
// //       required this.amount})
// //       : super(key: key);
// //   final String text;
// //   final String quantity;
// //   final String amount;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text(
// //           text,
// //           style: Styles.smallGreyText(context),
// //         ),
// //         Text(
// //           quantity,
// //           style: Styles.smallGreyText(context),
// //         ),
// //         Text(
// //           amount,
// //           style: Styles.smallGreyText(context),
// //         ),
// //       ],
// //     );
// //   }
// // }
// // class Deliveries extends StatelessWidget {
// //   Deliveries({Key? key}) : super(key: key);
// //   final bool isSelected = false;
// //   @override
// //   Widget build(BuildContext context) {
// //     final _controller = Provider.of<CustomersProvider>(context, listen: false);

// //     return Scaffold(
// //       body: SafeArea(
// //         child: SizedBox(
// //           height: double.infinity,
// //           width: double.infinity,

// //           //color: Styles.appBackgroundColor,
// //           child: Container(
// //             padding: EdgeInsets.only(
// //                 left: defaultPadding(context),
// //                 right: defaultPadding(context),
// //                 bottom: defaultPadding(context)),
// //             decoration: const BoxDecoration(
// //                 image: DecorationImage(
// //                     image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
// //                 borderRadius:
// //                     BorderRadius.only(bottomLeft: Radius.circular(30))),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.start,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 SizedBox(
// //                   height: defaultPadding(context),
// //                 ),
// //                 Stack(
// //                   children: [
// //                     Material(
// //                       child: InkWell(
// //                         splashColor: Theme.of(context).splashColor,
// //                         onTap: () => Navigator.pop(context),
// //                         child: Icon(
// //                           Icons.arrow_back_ios_new,
// //                           color: Styles.darkGrey,
// //                         ),
// //                       ),
// //                     ),
// //                     Align(
// //                       alignment: Alignment.center,
// //                       child: Text(
// //                         'Malaika Mbili Shop',
// //                         style: Styles.heading2(context),
// //                       ),
// //                     ),
// //                     Align(
// //                       alignment: Alignment.topRight,
// //                       child: Material(
// //                         child: InkWell(
// //                           splashColor: Theme.of(context).splashColor,
// //                           onTap: () => Get.toNamed(AppRoutes.home),
// //                           child: Icon(
// //                             Icons.home_sharp,
// //                             size: defaultPadding(context) * 2,
// //                             color: Styles.appPrimaryColor,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 SizedBox(
// //                   height: defaultPadding(context) * 1,
// //                 ),
// //                 Text(
// //                   'Deliveries',
// //                   style: Styles.heading2(context),
// //                 ),
// //                 SizedBox(
// //                   height: defaultPadding(context),
// //                 ),
// //                 Padding(
// //                   padding: EdgeInsets.symmetric(
// //                       horizontal: defaultPadding(context) * 1.8),
// //                   child: const LargeSearchField(
// //                     hintText: 'Search By Name',
// //                     outline: true,
// //                   ),
// //                 ),
// //                 Expanded(
// //                     child: Stack(children: [
// //                   ListView(
// //                     shrinkWrap: true,
// //                     children: [
// //                       SizedBox(
// //                         height: defaultPadding(context) * .4,
// //                       ),
// //                       Responsive.isTablet(context)
// //                           ? SizedBox(
// //                               child: ListView.builder(
// //                                 shrinkWrap: true,
// //                                 itemBuilder: (context, index) {
// //                                   final cuisine =
// //                                       index < 5 ? cuisines1 : cuisines2;
// //                                   index = index < 5 ? index : index - 5;
// //                                   return Card(
// //                                     color: index == 2
// //                                         ? Styles.appPrimaryColor
// //                                         : Styles.appBackgroundColor,
// //                                     elevation: 8,
// //                                     child: Text(
// //                                       "${cuisine[index]["name"]}",
// //                                       style: TextStyle(
// //                                           fontSize: Styles.normalText(context)
// //                                               .fontSize),
// //                                     ),
// //                                     margin: const EdgeInsets.only(right: 20),
// //                                   );
// //                                 },
// //                                 itemCount: 9,
// //                                 scrollDirection: Axis.horizontal,
// //                               ),
// //                               width: double.infinity,
// //                               height: 120,
// //                             )
// //                           : Column(
// //                               children: [
// //                                 SizedBox(
// //                                   child: ListView.builder(
// //                                     shrinkWrap: true,
// //                                     itemBuilder: (context, index) {
// //                                       return Container(
// //                                         decoration: BoxDecoration(
// //                                             boxShadow: [
// //                                               BoxShadow(
// //                                                 color: Colors.grey
// //                                                     .withOpacity(0.5),
// //                                                 spreadRadius: 0,
// //                                                 blurRadius: 0,
// //                                                 // offset: const Offset(0,
// //                                                 //     3), // changes position of shadow
// //                                               ),
// //                                             ],
// //                                             color: index == 2
// //                                                 ? Styles.appPrimaryColor
// //                                                 : Styles.appBackgroundColor,
// //                                             borderRadius:
// //                                                 const BorderRadius.all(
// //                                                     Radius.circular(10))),
// //                                         child: Padding(
// //                                           padding: const EdgeInsets.all(8.0),
// //                                           child: Text(
// //                                               "${cuisines1[index]["name"]}",
// //                                               style: TextStyle(
// //                                                 color: index == 2
// //                                                     ? Colors.white
// //                                                     : Colors.black,
// //                                               )),
// //                                         ),
// //                                         margin: const EdgeInsets.only(
// //                                             right: 20, bottom: 10),
// //                                       );
// //                                     },
// //                                     itemCount: 5,
// //                                     scrollDirection: Axis.horizontal,
// //                                   ),
// //                                   width: double.infinity,
// //                                   height: 40,
// //                                 ),
// //                               ],
// //                             ),

// //                       // Row(
// //                       //   mainAxisAlignment: MainAxisAlignment.center,
// //                       //   children: const [
// //                       //     TabButton(
// //                       //       text: 'All',
// //                       //       isSelected: false,
// //                       //     ),
// //                       //     TabButton(text: 'Alcohol'),
// //                       //     //TabButton(text: 'Energy Drink'),
// //                       //     TabButton(text: 'Juice'),
// //                       //     TabButton(text: 'Water'),
// //                       //   ],
// //                       // ),
// //                       SizedBox(
// //                         height: defaultPadding(context) * 1,
// //                       ),
// //                       Card(
// //                         child: Padding(
// //                           padding: const EdgeInsets.all(8.0),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Row(
// //                                 mainAxisAlignment:
// //                                     MainAxisAlignment.spaceBetween,
// //                                 children: [
// //                                   Text(
// //                                     'Product',
// //                                     style: Styles.heading3(context),
// //                                   ),
// //                                   Text(
// //                                     'Quantity',
// //                                     style: Styles.heading3(context),
// //                                   ),
// //                                   Text(
// //                                     'Amount',
// //                                     style: Styles.heading3(context),
// //                                   ),
// //                                 ],
// //                               ),
// //                               ProductsWidget(
// //                                   text: 'Dasani',
// //                                   quantity: '1L',
// //                                   amount: 'Ksh 2,320'),
// //                               ProductsWidget(
// //                                   text: 'Dasani',
// //                                   quantity: '1L',
// //                                   amount: 'Ksh 2,320'),
// //                               ProductsWidget(
// //                                   text: 'Dasani',
// //                                   quantity: '1L',
// //                                   amount: 'Ksh 2,320'),
// //                               ProductsWidget(
// //                                   text: 'Dasani',
// //                                   quantity: '1L',
// //                                   amount: 'Ksh 2,320'),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   // Positioned(
// //                   //   bottom: 0,
// //                   //   left: 0,
// //                   //   right: 0,
// //                   //   child: Column(
// //                   //     children: [
// //                   //       FullWidthButton(
// //                   //         action: () {},
// //                   //         text: 'Add',
// //                   //         color: Styles.appPrimaryColor,
// //                   //       ),
// //                   //       Material(
// //                   //         child: InkWell(
// //                   //           splashColor: Theme.of(context).splashColor,
// //                   //           onTap: () {
// //                   //             Navigate.instance.toRemove('/customers');
// //                   //           },
// //                   //           child: Padding(
// //                   //             padding: EdgeInsets.symmetric(
// //                   //                 vertical: defaultPadding(context)),
// //                   //             child: Center(
// //                   //                 child: Text(
// //                   //               'Cancel',
// //                   //               textAlign: TextAlign.center,
// //                   //               style: Styles.normalText(context),
// //                   //             )),
// //                   //           ),
// //                   //         ),
// //                   //       )
// //                   //     ],
// //                   //   ),
// //                   // ),
// //                 ]))
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   final List cuisines2 = const [
// //     {"name": "Indian", "icon": "assets/icons/h.png"},
// //     {"name": "Italian", "icon": "assets/icons/i.png"},
// //     {"name": "kenyan", "icon": "assets/icons/d.png"},
// //     {"name": "French", "icon": "assets/icons/e.png"},
// //     {"name": "Ghanaian", "icon": "assets/icons/j.png"},
// //   ];

// //   final List cuisines1 = const [
// //     {"name": "All", "icon": "assets/icons/a.png"},
// //     {"name": "Past 1 Month", "icon": "assets/icons/b.png"},
// //     {"name": "Last 3 Months", "icon": "assets/icons/f.png"},
// //     {"name": "Last 6 Months", 'icon': "assets/icons/g.png"},
// //     {"name": "Last 1 year", "icon": "assets/icons/c.png"},
// //   ];
// // }

// // class ProductsWidget extends StatelessWidget {
// //   const ProductsWidget(
// //       {Key? key,
// //       required this.quantity,
// //       required this.text,
// //       required this.amount})
// //       : super(key: key);
// //   final String text;
// //   final String quantity;
// //   final String amount;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text(
// //           text,
// //           style: Styles.smallGreyText(context),
// //         ),
// //         Text(
// //           quantity,
// //           style: Styles.smallGreyText(context),
// //         ),
// //         Text(
// //           amount,
// //           style: Styles.smallGreyText(context),
// //         ),
// //       ],
// //     );
// //   }
// // }
