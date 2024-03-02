// import 'dart:io';
// import 'dart:math';
//
// import 'package:collection/collection.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:soko_flow/controllers/customer_checking_controller.dart';
// import 'package:soko_flow/controllers/data_sync_controller.dart';
// import 'package:soko_flow/controllers/product_category_controller.dart';
// import 'package:soko_flow/controllers/routes_controller.dart';
// import 'package:soko_flow/models/route_schedule_model.dart';
// import 'package:soko_flow/views/customers/surveys/widget/custom_radio_button.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// import '../../configs/constants.dart';
// import '../../configs/styles.dart';
// import '../../data/providers/sales-count_provider.dart';
// import '../../drawer_main.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/indicators/animated_circular_progress_indicator.dart';
// import 'custom_date_picker.dart';
// import 'last_31days.dart';
//
// class HomeScreen extends StatefulWidget {
//   HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   var startDate = DateTime.now();
//   List months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
//       .toggledOff; // Can be toggled on/off by longpressing a date
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   DateTime? _rangeStart;
//   // Map<DateTime, List<Event>>? kEvents;
//   DateTime? _rangeEnd;
//
//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     if (!isSameDay(_selectedDay, selectedDay)) {
//       setState(() {
//         _selectedDay = selectedDay;
//         _focusedDay = focusedDay;
//         _rangeStart = null; // Important to clean those
//         _rangeEnd = null;
//         _rangeSelectionMode = RangeSelectionMode.toggledOff;
//       });
//
//       // _selectedEvents.value = _routesController.getEventsForDay(selectedDay);
//     }
//   }
//
//   void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
//     setState(() {
//       _selectedDay = null;
//       _focusedDay = focusedDay;
//       _rangeStart = start;
//       _rangeEnd = end;
//       _rangeSelectionMode = RangeSelectionMode.toggledOn;
//     });
//   }
//   void openHiveDb() async{
//     await Hive.openBox('new_leads');
//     await Hive.openBox('customer_visits');
//     await Hive.openBox('sales_made');
//     await Hive.openBox('orders');
//   }
//
//   void getUserRoutes() async{
//     // await _routesController.getUserRoutes().then((value) {
//
//     });
//
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     openHiveDb();
//     var d = DateTime.now();
//     var weekDay = d.weekday;
//     print("the weekday: ${weekDay}");
//     if(weekDay != 1){
//       setState(() {
//         startDate = d.subtract(Duration(days: weekDay - 1));
//       });
//       print("the start date: ${startDate}");
//       print("the today date: ${d}");
//     }else{
//       setState(() {
//         startDate = d;
//       });
//     }
//     getUserRoutes();
//
//
//
//     print('Date at start of week is $startDate');
//     super.initState();
//   }
//
//   List<PricePoint> points = pricePoints;
//   @override
//   Widget build(BuildContext context) {
//     Get.find<ProductCategoryController>().getProductCategories();
//
//     //SizeConfig().init(context);
//     return WillPopScope(
//       onWillPop: () async{
//         bool exit_app = false;
//         Get.dialog(
//             AlertDialog(
//
//               content: Container(
//                   width: double.maxFinite,
//                   child: Text("Are you sure you want to Exit?", style: Styles.normalText(context),)
//               ),
//               actions: [
//                 TextButton(
//                   child: Text("Cancel", style: Styles.heading3(context).copyWith(color: Colors.grey),),
//                   onPressed: () => Get.back(),
//                 ),
//                 TextButton(
//                   child: Text("Exit", style: Styles.heading3(context).copyWith(color: Styles.appYellowColor),),
//                   onPressed: () {
//                    setState(() {
//                      exit_app = true;
//                      exit(0);
//                    });
//                   },
//                 ),
//               ],
//             )
//         );
//
//         return exit_app;
//       },
//       child: Scaffold(
//         key: _scaffoldKey,
//         drawer: MainDrawer(),
//         body: GetBuilder<DataSyncController>(
//           builder: (dataSyncController) {
//             return GetBuilder<CustomerCheckingController>(
//               builder: (checkinController) {
//                 return Container(
//                   height: double.infinity,
//                   width: double.infinity,
//                   //color: Styles.appBackgroundColor,
//                   child: dataSyncController.isLoading?
//                       Container(
//                         child: Center(child: Text("Syncing Data ...", style: Styles.heading3(context),)),
//                       )
//                       :ListView(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.only(
//                             left: defaultPadding(context),
//                             right: defaultPadding(context),
//                             bottom: defaultPadding(context)),
//                         decoration: BoxDecoration(
//                             color: Styles.appPrimaryColor,
//                             borderRadius:
//                                 const BorderRadius.only(bottomLeft: Radius.circular(30))),
//                         child: Column(
//                           children: [
//                             SizedBox(
//                               height: defaultPadding(context),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 IconButton(
//                                     onPressed: () {
//                                       _scaffoldKey.currentState?.openDrawer();
//                                       // Navigate.instance.toRoute(MainDrawer());
//                                     },
//                                     icon: Icon(
//                                       Icons.menu,
//                                       color: Styles.appBackgroundColor,
//                                     )),
//                                 Padding(
//                                   padding:
//                                       EdgeInsets.only(left: defaultPadding(context) / 2),
//                                   child: CircleAvatar(
//                                     radius: defaultPadding(context),
//                                     backgroundColor: Styles.appBackgroundColor,
//                                     backgroundImage:
//                                         const AssetImage('assets/logo/Fav.png'),
//                                     // backgroundImage: AssetImage("assetName"),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: defaultPadding(context) / 2,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 CustomButton(
//                                   action: () {},
//                                   text: 'This Week',
//                                   isSelected: false,
//                                 ),
//                                 CustomButton(
//                                     action: () {
//                                       // Get.to(TableEventsExample());
//                                     },
//                                     text: 'Last 31 Days'),
//                                 // CustomButton(
//                                 //     action: () {
//                                 //       Get.to(const CustomDatePicker());
//                                 //     },
//                                 //     text: 'Custom'),
//                               ],
//                             ),
//                             SizedBox(
//                               height: defaultPadding(context) * 1,
//                             ),
//                             Align(
//                               alignment: Alignment.topLeft,
//                               child: Text(
//                                 // 'Mon, 13 Dec 2021 - Fri, 17 Dec 2021',
//                                 "Mon, ${startDate.day} ${months[startDate.month - 1]} ${startDate.year} "
//                                     "- Fri, ${startDate.add(Duration(days: 4)).day} ${months[startDate.add(Duration(days: 4)).month - 1]} ${startDate.add(Duration(days: 4)).year}",
//                                 textAlign: TextAlign.start,
//                                 style: Styles.buttonText1(context),
//                               ),
//                             ),
//                             SizedBox(
//                               height: defaultPadding(context) * 2,
//                             ),
//                             const AnimatedCircularProgressIndicator(
//                                 percentage: .14, label: 'Sales Done'),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                     child: Card(
//                                   // height: 200,
//                                   // decoration: BoxDecoration(
//                                   //     color: Colors.grey,
//                                   //     borderRadius: BorderRadius.circular(10)),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Consumer(builder: (context, ref, _) {
//                                       final sales = ref.watch(salesCountProvider);
//                                       return sales.when(data: (data) {
//                                         return Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 8.0, vertical: 15),
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 'Sales Made',
//                                                 style: Styles.heading3(context)),
//                                               SizedBox(
//                                                 height: 10,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     "Units:",
//                                                     style: Styles.normalText(context),
//                                                   ),
//                                                   Text(
//                                                     "43",
//                                                     style: Styles.heading4(context),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     "Amount(ksh):",
//                                                     style: Styles.normalText(context),
//                                                   ),
//                                                   Text(
//                                                     data.TotalSales.toString(),
//                                                     style: Styles.heading4(context),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       }, error: (e, error) {
//                                         return Center(
//                                           child: Text(e.toString()),
//                                         );
//                                       }, loading: () {
//                                         return Center(
//                                           child: CircularProgressIndicator(),
//                                         );
//                                       });
//                                     }),
//                                   ),
//                                 )),
//                                 SizedBox(
//                                   width: 20,
//                                 ),
//                                 Expanded(
//                                     child: Card(
//                                   // height: 200,
//                                   // decoration: BoxDecoration(
//                                   //     color: Colors.grey,
//                                   //     borderRadius: BorderRadius.circular(10)),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Consumer(builder: (context, ref, _) {
//                                       final visits = ref.watch(visitsCountCountProvider);
//                                       return visits.when(data: (data) {
//                                         return Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "Customer Visits",
//                                                 style: Styles.heading3(context),
//                                               ),
//                                               SizedBox(
//                                                 height: 10,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     "This week:",
//                                                     style: Styles.normalText(context),
//                                                   ),
//                                                   Text(
//                                                     data.TotalVisitsPerThisWeek
//                                                         .toString(),
//                                                     style: Styles.heading4(context),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     "This month:",
//                                                     style: Styles.normalText(context),
//                                                   ),
//                                                   Text(
//                                                     data.TotalVisitsPerThisMonth
//                                                         .toString(),
//                                                     style: Styles.heading4(context),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     "Today",
//                                                     style: Styles.normalText(context),
//                                                   ),
//                                                   Text(
//                                                     data.TotalVisitsThisYear.toString(),
//                                                     style: Styles.heading4(context),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       }, error: (e, error) {
//                                         return Center(
//                                           child: Text(e.toString()),
//                                         );
//                                       }, loading: () {
//                                         return Center(
//                                           child: CircularProgressIndicator(),
//                                         );
//                                       });
//                                     }),
//                                   ),
//                                 )),
//                               ],
//                             ),
//                             Divider(
//                               thickness: 2,
//                               color: Colors.grey,
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Row(
//                               children: [
//                                 Expanded(
//                                     child: Card(
//                                   // height: 200,
//                                   // decoration: BoxDecoration(
//                                   //     color: Colors.grey,
//                                   //     borderRadius: BorderRadius.circular(10)),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Consumer(builder: (context, ref, _) {
//                                       final leads = ref.watch(newLeadsCountProvider);
//                                       return leads.when(data: (data) {
//                                         return Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "New Leads",
//                                                 style: Styles.heading3(context),
//                                               ),
//                                               SizedBox(
//                                                 height: 10,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     "This week:",
//                                                     style: Styles.normalText(context),
//                                                   ),
//                                                   Text(
//                                                     data.ThisWeekLeads.toString(),
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     "This month:",
//                                                     style: TextStyle(color: Colors.black),
//                                                   ),
//                                                   Text(
//                                                     data.ThisMonthLeads.toString(),
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     "Today:",
//                                                     style: TextStyle(color: Colors.black),
//                                                   ),
//                                                   Text(
//                                                     data.ThisYearLeads.toString(),
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       }, error: (e, error) {
//                                         return Center(
//                                           child: Text(e.toString()),
//                                         );
//                                       }, loading: () {
//                                         return Center(
//                                           child: CircularProgressIndicator(),
//                                         );
//                                       });
//                                     }),
//                                   ),
//                                 )),
//                                 SizedBox(
//                                   width: 20,
//                                 ),
//                                 Expanded(
//                                     child: Card(
//                                   // height: 200,
//                                   // decoration: BoxDecoration(
//                                   //     color: Colors.grey,
//                                   //     borderRadius: BorderRadius.circular(10)),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Consumer(builder: (context, ref, _) {
//                                       final orders = ref.watch(ordersCountProvider);
//                                       return orders.when(data: (data) {
//                                         return Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "Orders",
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 16,
//                                                     fontWeight: FontWeight.bold),
//                                               ),
//                                               SizedBox(
//                                                 height: 10,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     "This week:",
//                                                     style: TextStyle(color: Colors.black),
//                                                   ),
//                                                   Text(
//                                                     data.CustomerOrderCountThisWeek
//                                                         .toString(),
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     "This month:",
//                                                     style: TextStyle(color: Colors.black),
//                                                   ),
//                                                   Text(
//                                                     data.CustomerOrderCountThisMonth
//                                                         .toString(),
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     "Today:",
//                                                     style: TextStyle(color: Colors.black),
//                                                   ),
//                                                   Text(
//                                                     data.CustomerOrderCountThisMonth
//                                                         .toString(),
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontWeight: FontWeight.bold),
//                                                   ),
//                                                 ],
//                                               ),
//                                               // Row(
//                                               //   mainAxisAlignment:
//                                               //       MainAxisAlignment.spaceBetween,
//                                               //   children: [
//                                               //     Text(
//                                               //       "This Year:",
//                                               //       style: TextStyle(color: Colors.black),
//                                               //     ),
//                                               //     Text(
//                                               //       data.CustomersOrderCountThisYear
//                                               //           .toString(),
//                                               //       style: TextStyle(
//                                               //           color: Colors.black,
//                                               //           fontWeight: FontWeight.bold),
//                                               //     ),
//                                               //   ],
//                                               // ),
//                                             ],
//                                           ),
//                                         );
//                                       }, error: (e, error) {
//                                         return Center(
//                                           child: Text(e.toString()),
//                                         );
//                                       }, loading: () {
//                                         return Center(
//                                           child: CircularProgressIndicator(),
//                                         );
//                                       });
//                                     }),
//                                   ),
//                                 )),
//                               ],
//                             ),
//
//                             SizedBox(
//                               height: 5,
//                             ),
//
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//               }
//             );
//           }
//         ),
//       ),
//     );
//   }
//
//   List<BarChartGroupData> _chartGroups() {
//     return points
//         .map((point) => BarChartGroupData(
//             x: point.x.toInt(), barRods: [BarChartRodData(toY: point.y)]))
//         .toList();
//   }
//
//   SideTitles get _bottomTitles => SideTitles(
//         showTitles: true,
//         getTitlesWidget: (value, meta) {
//           String text = '';
//           switch (value.toInt()) {
//             case 0:
//               text = 'Jan';
//               break;
//             case 2:
//               text = 'Mar';
//               break;
//             case 4:
//               text = 'May';
//               break;
//             case 6:
//               text = 'Jul';
//               break;
//             case 8:
//               text = 'Sep';
//               break;
//             case 10:
//               text = 'Nov';
//               break;
//           }
//
//           return Text(text);
//         },
//       );
// }
//
// class PricePoint {
//   final double x;
//   final double y;
//
//   PricePoint({required this.x, required this.y});
// }
//
// List<PricePoint> get pricePoints {
//   final Random random = Random();
//   final randomNumbers = <double>[];
//   for (var i = 0; i <= 11; i++) {
//     randomNumbers.add(random.nextDouble());
//   }
//
//   return randomNumbers
//       .mapIndexed(
//           (index, element) => PricePoint(x: index.toDouble(), y: element))
//       .toList();
// }
