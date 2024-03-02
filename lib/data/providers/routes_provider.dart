import 'dart:developer';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/data/hive_database/hive_constants.dart';
import 'package:soko_flow/data/hive_database/hive_manager.dart';
import 'package:soko_flow/data/repository/routes_repo.dart';
import 'package:soko_flow/helper/dio_exceptions.dart';
import 'package:soko_flow/models/response_model.dart';
import 'package:soko_flow/models/route_schedule_model.dart';

import '../../models/customer_model/customer_model.dart';

final routesTypeProvider =
    StateProvider<ScheduleTypes>((ref) => ScheduleTypes.Individual);

final routesProvider = FutureProvider<List<UserRouteModel>>((ref) async {
  final userRoutes = await ref.watch(routesRepository).getUserRoutes(false);
  return userRoutes;
});
//
// Customer? selectedCustomer = null;
// Map<DateTime, List<UserRouteModel>> kEvents = {};
final selectedCustomerProvider = StateProvider<CustomerDataModel>((ref) => CustomerDataModel());
final kEventProvider =
    StateProvider<Map<DateTime, List<UserRouteModel>>>((ref) => {});
final selectedEventsProvider = StateProvider<List<UserRouteModel>>((ref) => []);

final userRoutesNotifierProvider =
    StateNotifierProvider<UserRoutesNotifier, AsyncValue>(
        (ref) => UserRoutesNotifier(ref));

class UserRoutesNotifier extends StateNotifier<AsyncValue> {
  UserRoutesNotifier(this.ref) : super(AsyncData(null));
  Ref ref;

  Future<List<UserRouteModel>?> getUserRoutes() async {
    try {
      List<UserRouteModel> userRoutes = await ref.watch(routesProvider.future);
      print("main routes: $userRoutes");
      userRoutes.forEach((element) {
        print(
            "comp${element.startDate!}  and${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString()}");
      });
      return userRoutes
          .where((element) =>
              DateTime(element.startDate!.year, element.startDate!.month,
                  element.startDate!.day) ==
              DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day))
          .toList();
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<List<UserRouteModel>?> filterUserRoutes() async {
    ref.refresh(kEventProvider);
    final kEvents = ref.read(kEventProvider);
    final filter = ref.watch(routesTypeProvider);
    print("type is $filter");
    try {
      List<UserRouteModel> userRoutes = await ref.read(routesProvider.future);
      if (filter.name == ScheduleTypes.Assigned.name) {
        userRoutes = userRoutes
            .where((element) => element.routeType == "Assigned")
            .toList();
      }
      if (filter.name == ScheduleTypes.Individual.name) {
        print("at individual");
        print("the lenth at individual: $userRoutes");
        userRoutes = userRoutes
            .where((element) => element.routeType == "Individual")
            .toList();
      }
      if (filter.name == ScheduleTypes.Routes.name) {
        userRoutes = userRoutes
            .where((element) => element.routeType == "Route")
            .toList();
      }
      userRoutes.forEach((event) {
        // print("event: ${event}");
        print("the type is: ${event.routeType}");
        print(event.startDate);
        if (kEvents[DateTime.utc(event.startDate!.year, event.startDate!.month,
                event.startDate!.day)] ==
            null) {
          kEvents[DateTime.utc(event.startDate!.year, event.startDate!.month,
              event.startDate!.day)] = [
            UserRouteModel(
                name: event.name,
                routeCode: event.routeCode,
                status: event.status,
                startDate: event.startDate,
                endDate: event.endDate,
                customerName: event.customerName,
                account: event.account,
                address: event.address,
                email: event.email,
                telephone: event.telephone,
                latitude: event.latitude,
                longitude: event.longitude)
          ];
        } else {
          kEvents[DateTime.utc(event.startDate!.year, event.startDate!.month,
                  event.startDate!.day)]!
              .add(UserRouteModel(
                  name: event.name,
                  routeCode: event.routeCode,
                  status: event.status,
                  startDate: event.startDate,
                  endDate: event.endDate,
                  customerName: event.customerName,
                  account: event.account,
                  address: event.address,
                  email: event.email,
                  telephone: event.telephone,
                  latitude: event.latitude,
                  longitude: event.longitude));
        }
      });
      print("events for day are: ${getEventsForDay(DateTime.now())}");
      ref.refresh(selectedEventsProvider);
      ref.read(selectedEventsProvider).addAll(getEventsForDay(DateTime.utc(
          DateTime.now().year, DateTime.now().month, DateTime.now().day)));
      return userRoutes;
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<List<CustomerDataModel>> getCustomersForSchedule() async {
    List<CustomerDataModel> listcustomers = [];
    try {
      await HiveDataManager(HiveBoxConstants.customersDb).getHiveData().then((box) {
        listcustomers.addAll(box.get(HiveBoxConstants.customersDb).cast<CustomerDataModel>());
      });
      return listcustomers;
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future addCustomerVisit(
      String routeName, String customer_id, String startDate) async {
    state = AsyncLoading();
    try {
      await ref.read(routesRepository).addCustomerVisit(routeName, customer_id, startDate);
      ref.refresh(routesProvider);
      showCustomSnackBar("Successfully scheduled visit", isError: false);
      state = AsyncData(null);
    } on DioError catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
      throw DioExceptions.fromDioError(e);
    } catch (e, s) {
      AsyncError(e, s);
      // showCustomSnackBar(e.toString(), isError: true);
    }
  }

  List<UserRouteModel> getEventsForDay(DateTime day) {
    // print("getting event for day ${day}");
    // print(day);
    // print("events today: ${kEvents[DateTime.now()]}");
    // print("events for day : ${kEvents[day]}");
    // Implementation example
    return ref.read(kEventProvider)[day] ?? [];
  }

  List<UserRouteModel> getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ...getEventsForDay(d),
    ];
  }

  /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }
}
