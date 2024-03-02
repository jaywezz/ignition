// import 'dart:collection';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:soko_flow/configs/constants.dart';
// import 'package:soko_flow/configs/styles.dart';
// import 'package:soko_flow/controllers/routes_controller.dart';
// import 'package:soko_flow/models/route_schedule_model.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// import '../../routes/route_helper.dart';
//
// class TableEventsExample extends StatefulWidget {
//   @override
//   _TableEventsExampleState createState() => _TableEventsExampleState();
// }
//
// class _TableEventsExampleState extends State<TableEventsExample> {
//   ValueNotifier<List<UserRouteModel>> _selectedEvents = ValueNotifier<List<UserRouteModel>>([]);
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
//       .toggledOff; // Can be toggled on/off by longpressing a date
//   var _routesController = Get.find<RoutesController>();
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   DateTime? _rangeStart;
//   // Map<DateTime, List<Event>>? kEvents;
//   DateTime? _rangeEnd;
//
//   @override
//   void initState() {
//     super.initState();
//     getUserRoutes();
//     _selectedDay = _focusedDay;
//     _selectedEvents = ValueNotifier(_routesController.getEventsForDay(_selectedDay!));
//
//   }
//
//   void getUserRoutes() async{
//     await _routesController.getUserRoutes().then((value) {
//
//     });
//
//   }
//
//   @override
//   void dispose() {
//     _selectedEvents.dispose();
//     super.dispose();
//   }
//
//
//
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
//       _selectedEvents.value = _routesController.getEventsForDay(selectedDay);
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
//
//     // `start` or `end` could be null
//     if (start != null && end != null) {
//       _selectedEvents.value = _routesController.getEventsForRange(start, end);
//     } else if (start != null) {
//       _selectedEvents.value = _routesController.getEventsForDay(start);
//     } else if (end != null) {
//       _selectedEvents.value = _routesController.getEventsForDay(end);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.only(
//             top: defaultPadding(context) * 2,
//             left: defaultPadding(context),
//             right: defaultPadding(context),
//             bottom: defaultPadding(context)),
//         decoration: BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
//         ),
//         child: Column(
//           children: [
//             SizedBox(
//               height: defaultPadding(context),
//             ),
//             Stack(
//               children: [
//                 Material(
//                   child: InkWell(
//                     splashColor: Theme.of(context).splashColor,
//                     onTap: () => Navigator.pop(context),
//                     child: Icon(
//                       Icons.arrow_back_ios_new,
//                       color: Styles.darkGrey,
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.center,
//                   child: Text(
//                     'Last 31 Days',
//                     style: Styles.heading2(context),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: Material(
//                     child: InkWell(
//                       splashColor: Theme.of(context).splashColor,
//                       onTap: () => Get.toNamed(RouteHelper.getInitial()),
//                       child: Icon(
//                         Icons.home_sharp,
//                         size: defaultPadding(context) * 2,
//                         color: Styles.appPrimaryColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: defaultPadding(context),
//             ),
//             GetBuilder<RoutesController>(builder: (routeController) {
//                   return routeController.isLoading? CircularProgressIndicator():TableCalendar<UserRouteModel>(
//                     firstDay: kFirstDay,
//                     lastDay: kLastDay,
//                     focusedDay: _focusedDay,
//                     selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                     rangeStartDay: _rangeStart,
//                     rangeEndDay: _rangeEnd,
//                     calendarFormat: _calendarFormat,
//                     rangeSelectionMode: _rangeSelectionMode,
//                     eventLoader: routeController.getEventsForDay,
//                     startingDayOfWeek: StartingDayOfWeek.monday,
//                     calendarStyle: CalendarStyle(
//                       // Use `CalendarStyle` to customize the UI
//                       outsideDaysVisible: false,
//                     ),
//                     onDaySelected: _onDaySelected,
//                     onRangeSelected: _onRangeSelected,
//                     onFormatChanged: (format) {
//                       if (_calendarFormat != format) {
//                         setState(() {
//                           _calendarFormat = format;
//                         });
//                       }
//                     },
//                     onPageChanged: (focusedDay) {
//                       _focusedDay = focusedDay;
//                     },
//                   );
//                 }),
//
//             const SizedBox(height: 8.0),
//             Expanded(
//               child: ValueListenableBuilder<List<UserRouteModel>>(
//                 valueListenable: _selectedEvents,
//                 builder: (context, value, _) {
//                   return ListView.builder(
//                     itemCount: value.length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         margin: const EdgeInsets.symmetric(
//                           horizontal: 12.0,
//                           vertical: 4.0,
//                         ),
//                         decoration: BoxDecoration(
//                           border: Border.all(),
//                           borderRadius: BorderRadius.circular(12.0),
//                         ),
//                         child: ListTile(
//                           onTap: () => print('${value[index]}'),
//                           title: Text('${value[index]}'),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class Event {
//   final String title;
//   final String customers;
//
//   const Event({required this.title, required this.customers});
//
//   @override
//   String toString() => title;
//
// }
//
// /// Example events.
// ///
// /// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
// // final kEvents = LinkedHashMap<DateTime, List<Event>>(
// //   equals: isSameDay,
// //   hashCode: getHashCode,
// // )..addAll(_kEventSource);
// //
// //
// // final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
// //     key: (item) => DateTime.utc(kToday.year, kToday.month, item * 5),
// //     value: (item) => List.generate(
// //         1, (index) => Event('Event $item | ${index + 1}')))
// //   ..addAll({
// //     kToday: [
// //       Event('Today\'s Event 1'),
// //       Event('Today\'s Event 2'),
// //     ],
// //   });
//
// int getHashCode(DateTime key) {
//   return key.day * 1000000 + key.month * 10000 + key.year;
// }
//
// /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
// List<DateTime> daysInRange(DateTime first, DateTime last) {
//   final dayCount = last.difference(first).inDays + 1;
//   return List.generate(
//     dayCount,
//     (index) => DateTime.utc(first.year, first.month, first.day + index),
//   );
// }
//
// final kToday = DateTime.now();
// final kFirstDay = DateTime(kToday.year, kToday.month, kToday.day);
// final kLastDay = DateTime(kToday.year +1, kToday.month, kToday.day);
//
//
