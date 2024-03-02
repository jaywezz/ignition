// import 'dart:collection';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_clean_calendar/clean_calendar_event.dart';
// import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
// import 'package:get/get.dart';
// import 'package:soko_flow/configs/constants.dart';
// import 'package:soko_flow/configs/styles.dart';
// import 'package:soko_flow/controllers/routes_controller.dart';
// import 'package:soko_flow/logic/routes/routes.dart';
// import 'package:soko_flow/services/navigation_services.dart';
//
// import '../../routes/route_helper.dart';
//
// class RouteScheduleScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _RouteScheduleScreenState();
//   }
// }
//
// class _RouteScheduleScreenState extends State<RouteScheduleScreen> {
//   // final Map<DateTime, List<CleanCalendarEvent>> _events = {
//   //   DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): [
//   //     CleanCalendarEvent(
//   //       'Event A',
//   //       startTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //           DateTime.now().day, 10, 0),
//   //       endTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //           DateTime.now().day, 12, 0),
//   //       description: 'A special event',
//   //       // color: Colors.blue
//   //     ),
//   //   ],
//   //   DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2):
//   //       [
//   //     CleanCalendarEvent(
//   //       'Event B',
//   //       startTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //           DateTime.now().day + 2, 10, 0),
//   //       endTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //           DateTime.now().day + 2, 12, 0),
//   //       //color: Colors.orange
//   //     ),
//   //     CleanCalendarEvent(
//   //       'Event C',
//   //       startTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //           DateTime.now().day + 2, 14, 30),
//   //       endTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //           DateTime.now().day + 2, 17, 0),
//   //       //color: Colors.pink
//   //     ),
//   //   ],
//   //   DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 3):
//   //       [
//   //     CleanCalendarEvent(
//   //       'Event B',
//   //       startTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //           DateTime.now().day + 2, 10, 0),
//   //       endTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //           DateTime.now().day + 2, 12, 0),
//   //       //color: Colors.orange
//   //     ),
//   //     CleanCalendarEvent('Event C',
//   //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 14, 30),
//   //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 17, 0),
//   //         color: Colors.pink),
//   //     CleanCalendarEvent('Event D',
//   //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 14, 30),
//   //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 17, 0),
//   //         color: Colors.amber),
//   //     CleanCalendarEvent('Event E',
//   //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 14, 30),
//   //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 17, 0),
//   //         color: Colors.deepOrange),
//   //     CleanCalendarEvent('Event F',
//   //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 14, 30),
//   //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 17, 0),
//   //         color: Colors.green),
//   //     CleanCalendarEvent('Event G',
//   //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 14, 30),
//   //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 17, 0),
//   //         color: Colors.indigo),
//   //     CleanCalendarEvent('Event G',
//   //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 14, 30),
//   //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 17, 0),
//   //         color: Colors.indigo),
//   //     CleanCalendarEvent('Event G',
//   //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 14, 30),
//   //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 17, 0),
//   //         color: Colors.indigo),
//   //     CleanCalendarEvent('Event G',
//   //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 14, 30),
//   //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 17, 0),
//   //         color: Colors.indigo),
//   //     CleanCalendarEvent('Event G',
//   //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 14, 30),
//   //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 17, 0),
//   //         color: Colors.indigo),
//   //     CleanCalendarEvent('Event G',
//   //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 14, 30),
//   //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 17, 0),
//   //         color: Colors.indigo),
//   //     CleanCalendarEvent('Event H',
//   //         startTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 14, 30),
//   //         endTime: DateTime(DateTime.now().year, DateTime.now().month,
//   //             DateTime.now().day + 2, 17, 0),
//   //         color: Colors.brown),
//   //   ],
//   // };
//
//   var _routesController = Get.find<RoutesController>();
//
//   @override
//   void initState() {
//     super.initState();
//     // Force selection of today on first load, so that the list of today's events gets shown.
//     _routesController.getUserRoutes();
//     _handleNewDate(DateTime(
//         DateTime.now().year, DateTime.now().month, DateTime.now().day));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SizedBox(
//           height: double.infinity,
//           width: double.infinity,
//
//           //color: Styles.appBackgroundColor,
//           child: Container(
//             padding: EdgeInsets.only(
//                 left: defaultPadding(context),
//                 right: defaultPadding(context),
//                 bottom: defaultPadding(context)),
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                   image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
//             ),
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: defaultPadding(context),
//                 ),
//
//                 Stack(
//                   children: [
//                     Material(
//                       color: Colors.transparent,
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
//                         'Route Schedule',
//                         style: Styles.heading2(context),
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           splashColor: Theme.of(context).splashColor,
//                           onTap: () => Get.toNamed(RouteHelper.getInitial()),
//                           child: Icon(
//                             Icons.home_sharp,
//                             size: defaultPadding(context) * 2,
//                             color: Styles.appPrimaryColor,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 SizedBox(
//                   height: defaultPadding(context) * 1.3,
//                 ),
//                 GetBuilder<RoutesController>(builder: (routeController){
//                   return  Expanded(
//                     child: Calendar(
//                       startOnMonday: true,
//                       weekDays: [
//                         'Mon',
//                         'Tue',
//                         'Wed',
//                         'Thur',
//                         'Fri',
//                         'Sat',
//                         'Sun'
//                       ],
//                       events: routeController.events,
//                       isExpandable: true,
//                       eventDoneColor: Styles.appPrimaryColor,
//                       selectedColor: Styles.appPrimaryColor,
//                       todayColor: Styles.appPrimaryColor,
//                       eventColor: Styles.appPrimaryColor,
//                       locale: 'en_US',
//                       todayButtonText: 'Today',
//                       hideTodayIcon: true,
//                       isExpanded: true,
//                       expandableDateFormat: 'EEEE, dd. MMMM yyyy',
//                       dayOfWeekStyle: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.w800,
//                           fontSize: 11),
//                     ),
//                   );
//                 })
//
//               ],
//             ),
//           ),
//         ),
//       ),
//
//       // SafeArea(
//       //   child: Calendar(
//       //     startOnMonday: true,
//       //     weekDays: ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'],
//       //     events: _events,
//       //     isExpandable: true,
//       //     eventDoneColor: Colors.green,
//       //     selectedColor: Colors.pink,
//       //     todayColor: Colors.blue,
//       //     eventColor: Colors.grey,
//       //     locale: 'en_US',
//       //     todayButtonText: 'Today',
//       //     hideTodayIcon: true,
//       //     isExpanded: true,
//       //     expandableDateFormat: 'EEEE, dd. MMMM yyyy',
//       //     dayOfWeekStyle: TextStyle(
//       //         color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
//       //   ),
//       // ),
//     );
//   }
//
//   void _handleNewDate(date) {
//     print('Date selected: $date');
//   }
// }
