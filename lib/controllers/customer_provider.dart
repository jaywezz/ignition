import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';

final customerNotifierProvider = StateNotifierProvider<CustomersProvider, AsyncValue>((ref) => CustomersProvider(ref));

class CustomersProvider extends StateNotifier<AsyncValue> {
  CustomersProvider(this.ref)
      : super(AsyncLoading());
  Ref ref;
  var storage = const FlutterSecureStorage();
  //ApiProvider apiProvider = ApiProvider();
  var isDataProcessing = false;
  //List<CustomerOrdersModels> customersOrderList = [];
  // Future<List<CustomerOrdersModels>> fetchCustomersOrderProvider(
  //     var customerId) async {
  //   CustomerOrdersModels customerOrders =
  //       await apiProvider.customerOrders(customerId);
  //   customersOrderList.add(customerOrders);
  //   notifyListeners();
  //   return customersOrderList;
  // }

  // Future<CustomerDeliveriesModels> fetchCustomerDeliveries(
  //     int customerID) async {
  //   String businessCode = "Qx4FstqLJfHwf3WA";
  //   CustomerDeliveriesModels customerDeliveries =
  //       await apiProvider.customerDeriveries(businessCode, customerID);
  //   notifyListeners();
  //   return customerDeliveries;
  // }

  Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error("Location services are disabled.");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permissions are permanently denied, We cannot request permissions.");
    }
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
