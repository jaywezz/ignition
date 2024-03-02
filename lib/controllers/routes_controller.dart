//
//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
// import 'package:get/get.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:logger/logger.dart';
// import 'package:soko_flow/base/show_custom_snackbar.dart';
// import 'package:soko_flow/data/hive_database/hive_constants.dart';
// import 'package:soko_flow/data/hive_database/hive_manager.dart';
// import 'package:soko_flow/data/repository/allocations_repo.dart';
// import 'package:soko_flow/data/repository/routes_repo.dart';
// import 'package:soko_flow/models/allocation_history_model/allocations_model.dart';
// import 'package:soko_flow/models/customer_model/customer_model.dart';
// import 'package:soko_flow/models/latest_allocations_model/latest_allocated_items_model.dart';
// import 'package:soko_flow/models/response_model.dart';
// import 'package:soko_flow/models/route_schedule_model.dart';
// import 'package:soko_flow/views/home/last_31days.dart';
//
//
// class RoutesController extends GetxController{
//   RouteRepository routeRepository;
//   RoutesController({required this.routeRepository});
//   showSnackBar(String title, String message, Color backgroundColor) {
//     Get.snackbar(
//       title,
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: backgroundColor,
//       colorText: Colors.white,
//     );
//   }
//   static final Logger _log = Logger(
//     printer: PrettyPrinter(),
//   );
//
//   ValueNotifier<List<UserRouteModel>> selectedEvents = ValueNotifier<List<UserRouteModel>>([]);
//   List<UserRouteModel> allUserRoutes = List<UserRouteModel>.empty(growable: true).obs;
//
//   var connectionStatus = 0.obs;
//   var isDataProcessing = false.obs;
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   Customer? selectedCustomer = null;
//   Map<DateTime, List<UserRouteModel>> kEvents = {};
//
//   ScheduleTypes selected =
//
//   // var filterValue = 0.obs;
//
//   //bool isConnected=await InternetConnectionChecker().hasConnection;
//   late StreamSubscription<InternetConnectionStatus> _listener;
//
//   @override
//   void onInit() {
//     allUserRoutes.clear();
//     // _isLoading = true;
//     super.onInit();
//
//     _listener = InternetConnectionChecker()
//         .onStatusChange
//         .listen((InternetConnectionStatus status) {
//       switch (status) {
//         case InternetConnectionStatus.connected:
//           connectionStatus.value = 1;
//           break;
//         case InternetConnectionStatus.disconnected:
//           connectionStatus.value = 0;
//           break;
//       }
//     });
//   }
//
//
//   @override
//   void onReady() {
//     super.onReady();
//     // getStockHistory("all");
//     //For Pagination
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//   }
//
//   Future<List<Customer>> getCustomersForSchedule() async {
//     List<Customer> listcustomers = [];
//     try {
//       await HiveDataManager(HiveBoxConstants.customersDb).getHiveData().then((box){
//         listcustomers.addAll(box.get(HiveBoxConstants.customersDb).cast<Customer>());
//       });
//       return listcustomers;
//     } catch (exception) {
//         showSnackBar('Exception', exception.toString(), Colors.red);
//       return [];
//     }
//   }
//
//   Future<ResponseModel> addCustomerVisit(String routeName, String customer_id, String startDate) async{
//     refresh();
//     _isLoading = true;
//
//     try{
//       Response response = await routeRepository.addCustomerVisit(routeName,customer_id, startDate);
//       _isLoading = false;
//       showCustomSnackBar("Successfully scheduled visit", isError: false);
//       return ResponseModel(true, response.statusText!);
//     }catch (e){
//       _isLoading = false;
//       showCustomSnackBar(e.toString(), isError: true);
//     return ResponseModel(false, e.toString());
//     }
//   }
//   Future<bool> getUserRoutes() async {
//     // refresh();
//     allUserRoutes = [];
//     kEvents = {};
//     update();
//     _isLoading = true;
//     isDataProcessing(true);
//
//     try {
//       Response response = await routeRepository.getUserVisits();
//       if (response.statusCode == 200) {
//         _log.d('...Got Routes...: ${response.body}' );
//         allUserRoutes.addAll(RouteSchedule
//             .fromJson(response.body)
//             .routeSchedules);
//         _log.i(response.body);
//         _log.i(allUserRoutes.length);
//         // isDataProcessing(true);
//         print("populating k event");
//         allUserRoutes.forEach((event) {
//           // print("event: ${event}");
//
//           print(event.startDate);
//           if(kEvents[DateTime.utc(event.startDate!.year, event.startDate!.month, event.startDate!.day)] == null){
//             kEvents[DateTime.utc(event.startDate!.year, event.startDate!.month, event.startDate!.day)] = [
//               UserRouteModel(
//                   name : event.name,
//                   routeCode: event.routeCode,
//                   status: event.status,
//                   startDate: event.startDate,
//                   endDate: event.endDate,
//                   customerName: event.customerName,
//                   account: event.account,
//                   address: event.address,
//                   email : event.email,
//                   telephone: event.telephone,
//                   latitude: event.latitude,
//                   longitude: event.longitude
//               )
//             ];
//           }else{
//             kEvents[DateTime.utc(event.startDate!.year, event.startDate!.month, event.startDate!.day)]!.add(
//                 UserRouteModel(
//                     name : event.name,
//                     routeCode: event.routeCode,
//                     status: event.status,
//                     startDate: event.startDate,
//                     endDate: event.endDate,
//                     customerName: event.customerName,
//                     account: event.account,
//                     address: event.address,
//                     email : event.email,
//                     telephone: event.telephone,
//                     latitude: event.latitude,
//                     longitude: event.longitude
//
//                 )
//             );
//           }
//         });
//         // selectedEvents = ValueNotifier(getEventsForDay(DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day)));
//         _isLoading = false;
//         update();
//
//         return true;
//       } else {
//         _isLoading = false;
//         print(response.body);
//         _log.e('Could not Get Routes');
//         //print('Could not Get Ontrack Customers');
//
//         return false;
//       }
//     } catch (e) {
//       _isLoading = false;
//       print(e);
//       showSnackBar('Exception', e.toString(), Colors.red);
//       return false;
//     }
//
//   }
//
//   List<UserRouteModel> getEventsForDay(DateTime day) {
//
//     print("getting event for day ${day}");
//     // print(day);
//     // print("events today: ${kEvents[DateTime.now()]}");
//     // print("events for day : ${kEvents[day]}");
//     // Implementation example
//     return kEvents[day] ?? [];
//   }
//
//   List<UserRouteModel> getEventsForRange(DateTime start, DateTime end) {
//     // Implementation example
//     final days = daysInRange(start, end);
//
//     return [
//       for (final d in days) ...getEventsForDay(d),
//     ];
//   }
//
// }