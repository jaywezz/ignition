import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/data/repository/user_deriveries_repo.dart';
import 'package:soko_flow/models/derivery_model.dart';

final deliveryCartProvider = StateProvider<List<DeliveryCartModel>>((ref) => []);
// final initialDeliveryItemsProvider = StateProvider<List<DeliveryItemModel>>((ref) => []);

final deliveriesProvider = FutureProvider<List<DeliveriesModel>>((ref) async {
  final deliveries = await ref.watch(deliveriesRepositoryProvider).getUserDeliveries();
  return deliveries.reversed.toList();
});

final acceptedDeliveriesProvider = FutureProvider<List<DeliveriesModel>>((ref) async {

  List<DeliveriesModel> deliveries = [];
  await ref.watch(deliveriesProvider).whenData((value) {
    value = value.where((element) => element.deliveryStatus != "Waiting acceptance").toList();
    value = value.where((element) => element.deliveryStatus != "rejected").toList();
    deliveries.addAll(value);
  });
  return deliveries.reversed.toList();
});


final todayDeliveriesProvider = FutureProvider<List<DeliveriesModel>>((ref) async {

  List<DeliveriesModel> deliveries = [];
  await ref.watch(deliveriesProvider).whenData((value) {

    // deliveries.addAll(value);
    print("all deiveries : $value");
    value.forEach((element) {
      print("status: ${element.deliveryStatus}");
      // print("date ${ DateTime(element.deliveryDate!.year, element.deliveryDate!.month, element.deliveryDate!.day)}: and ")
    });
    value = value.where((element) => element.deliveryStatus != "Waiting acceptance").toList();
    value = value.where((element) => element.deliveryStatus != "rejected").toList();
    deliveries.addAll(value.where((element) => DateTime(element.createdAt.year, element.createdAt.month, element.createdAt.day) ==  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)).toList());
  });
  return deliveries;
});

final tommorowDeliveriesProvider = FutureProvider<List<DeliveriesModel>>((ref) async {

  List<DeliveriesModel> deliveries = [];
  await ref.watch(deliveriesProvider).whenData((value) {
    value = value.where((element) => element.deliveryStatus != "Waiting acceptance").toList();
    value = value.where((element) => element.deliveryStatus != "rejected").toList();
    deliveries.addAll(value.where((element) =>
    DateTime(element.createdAt.year, element.createdAt.month, element.createdAt.day)==  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day +1)).toList());
  });
  return deliveries;
});

final pastDeliveriesProvider = FutureProvider<List<DeliveriesModel>>((ref) async {

  List<DeliveriesModel> deliveries = [];
  await ref.watch(deliveriesProvider).whenData((value) {
    // deliveries.addAll(value);
    print("the deliveries: $value");
    value = value.where((element) => element.deliveryStatus != "Waiting acceptance").toList();
    value = value.where((element) => element.deliveryStatus != "rejected").toList();
    value.forEach((element) {
      print("this delvery");
      if(DateTime(element.createdAt.year, element.createdAt.month, element.createdAt.day) !=  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          || DateTime(element.createdAt.year, element.createdAt.month, element.createdAt.day) !=  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day +1)){
        deliveries.add(element);
      }
    });
  });
  return deliveries;
});


final deliveriesNotifierProvider =
StateNotifierProvider<DeliveriesNotifier, AsyncValue>((ref) {
  return DeliveriesNotifier (read: ref);
});


class DeliveriesNotifier extends StateNotifier<AsyncValue> {
  DeliveriesNotifier({required this.read})
      : super(const AsyncValue.data(null));
  Ref read;

  Future<void> makePartialDelivery(String reasonForPartial, String deliveryCode) async {
    state = const AsyncValue.loading();
    var data = [];
    List<DeliveryCartModel> deliveryItems = read.watch(deliveryCartProvider);
    for(DeliveryCartModel item in deliveryItems){
      var itemData = {
        "productID": item.productId,
        "qty": item.qty,
        "note": reasonForPartial,
        "item_condition": "good"
      };
      data.add(itemData);
    }
    try {
      final responseModel = await read.read(deliveriesRepositoryProvider).makePartialDelivery(data, deliveryCode);
      read.watch(deliveryCartProvider).clear();
      showSnackBar(text: "Partial delivery success");
      Get.close(2);
      StockHistoryController stockHistoryController = Get.put(StockHistoryController(stockHistoryRepository: Get.find()));
      await stockHistoryController.getLatestAllocations(true);
      read.refresh(deliveriesProvider);
      state = AsyncValue.data(responseModel);
    } catch (e, s) {
      showSnackBar(text: e.toString(), bgColor: Colors.red);
      state = AsyncValue.error(e.toString(), s);
    }
  }


  Future<void> makeFullDelivery(List<DeliveryItemModel> items, String deliveryCode) async {
    state = const AsyncValue.loading();
    var data = [];
    for(DeliveryItemModel item in items){
      var itemData = {
        "productID": item.productId,
        "qty": item.allocatedQuantity,
        "note": "Full Delivery",
        "item_condition": "good"
      };
      data.add(itemData);
    }
    try {
      final responseModel = await read.read(deliveriesRepositoryProvider).makeFullDelivery(data, deliveryCode);
      read.watch(deliveryCartProvider).clear();
      showSnackBar(text: "Delivery success");
      read.refresh(deliveriesProvider);
      StockHistoryController stockHistoryController = Get.put(StockHistoryController(stockHistoryRepository: Get.find()));
      await stockHistoryController.getLatestAllocations(true);
      state = AsyncValue.data(responseModel);
      Get.back();
    } catch (e, s) {
      showSnackBar(text: e.toString(), bgColor: Colors.red);
      state = AsyncValue.error(e.toString(), s);
    }
  }

  Future<void> acceptDelivery(List<String> deliveryCodes) async {
    state = const AsyncValue.loading();
    try {
      final responseModel = await read.read(deliveriesRepositoryProvider).acceptDelivery(deliveryCodes);
      showSnackBar(text: "Accepted");
      read.refresh(deliveriesProvider);
      StockHistoryController stockHistoryController = Get.put(StockHistoryController(stockHistoryRepository: Get.find()));
      await stockHistoryController.getLatestAllocations(true);
      stockHistoryController.update();
      state = AsyncValue.data(responseModel);
      Get.back();
    } catch (e, s) {
      showSnackBar(text: e.toString(), bgColor: Colors.red);
      state = AsyncValue.error(e.toString(), s);
    }
  }

  Future<void> declineDelivery(List<String> deliveryCodes, String notes) async {
    state = const AsyncValue.loading();
    try {
      final responseModel = await read.read(deliveriesRepositoryProvider).rejectDelivery(deliveryCodes, notes);
      showSnackBar(text: "Accepted");
      read.refresh(deliveriesProvider);
      state = AsyncValue.data(responseModel);
      Get.back();
    } catch (e, s) {
      showSnackBar(text: e.toString(), bgColor: Colors.red);
      state = AsyncValue.error(e.toString(), s);
    }
  }
}






