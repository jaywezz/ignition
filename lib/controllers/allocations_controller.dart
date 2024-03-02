

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/data/hive_database/hive_constants.dart';
import 'package:soko_flow/data/hive_database/hive_manager.dart';
import 'package:soko_flow/data/repository/allocations_repo.dart';
import 'package:soko_flow/models/allocation_history_model/allocations_model.dart';
import 'package:soko_flow/models/latest_allocations_model/latest_allocated_items_model.dart';
import '../models/add_cart_model/add_to_cart_model.dart';
import '../models/checkin_model.dart';
import 'package:dio/dio.dart' as d;


class StockHistoryController extends GetxController{
  StockHistoryRepository stockHistoryRepository;
  StockHistoryController({required this.stockHistoryRepository});
  showSnackBar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
    );
  }
  static final Logger _log = Logger(
    printer: PrettyPrinter(),
  );

  List<AllocationHistoryModel> alllststockHistory = List<AllocationHistoryModel>.empty(growable: true).obs;
  // List<AllocationHistoryModel> past1lststockHistory = List<AllocationHistoryModel>.empty(growable: true).obs;
  // List<AllocationHistoryModel> past3lststockHistory = List<AllocationHistoryModel>.empty(growable: true).obs;
  // List<AllocationHistoryModel> past6lststockHistory = List<AllocationHistoryModel>.empty(growable: true).obs;
  // List<AllocationHistoryModel> yearlststockHistory = List<AllocationHistoryModel>.empty(growable: true).obs;

  List<LatestAllocationModel> lstLatestAllocations = List<LatestAllocationModel>.empty(growable: true).obs;

  var connectionStatus = 0.obs;
  var isDataProcessing = false.obs;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  // var filterValue = 0.obs;

  //bool isConnected=await InternetConnectionChecker().hasConnection;
  late StreamSubscription<InternetConnectionStatus> _listener;

  @override
  void onInit() {
    alllststockHistory.clear();
    _isLoading = true;
    super.onInit();

    _listener = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          connectionStatus.value = 1;
          break;
        case InternetConnectionStatus.disconnected:
          connectionStatus.value = 0;
          break;
      }
    });
  }


  @override
  void onReady() {
    super.onReady();
    // getStockHistory("all");
    //For Pagination
  }

  @override
  void onClose() {
    super.onClose();
  }

  getStockHistory(int filterValue) async{
    _isLoading = true;
    refresh();
    alllststockHistory.clear();

    isDataProcessing(true);
    print("getting stock history");
    try{
      Response response = await stockHistoryRepository.getStockHistory();
      if (response.statusCode == 200) {
        _log.d('...Got the Stock History...');

        _log.i(response.body);
        var now = DateTime.now();
        var now_1m = new DateTime(now.year, now.month-1, now.day);
        var now_3m = new DateTime(now.year, now.month-3, now.day);
        var now_6m = new DateTime(now.year, now.month-6, now.day);
        var now_1y = new DateTime(now.year-1, now.month, now.day);

        // alllststockHistory.addAll(Allocations.fromJson(response.body).allocationsHist);
        if(filterValue == 0){
          print("all");
          alllststockHistory.addAll(Allocations.fromJson(response.body).allocationsHist);


        }
        if(filterValue == 1){
          print("past1 from ${now_1m}");
          alllststockHistory.addAll(Allocations.fromJson(response.body).allocationsHist
                  .where((element) {
                  final date = element.createdAt;
                  return now_1m.isBefore(date!);
                }));

        }
        if(filterValue == 2){
          alllststockHistory.addAll(Allocations.fromJson(response.body).allocationsHist
              .where((element) {
            final date = element.createdAt;
            return now_3m.isBefore(date!);
          }));

        }
        if(filterValue == 3){
          alllststockHistory.addAll(Allocations.fromJson(response.body).allocationsHist
              .where((element) {
            final date = element.createdAt;
            print(now_6m);
            print(date);
            print(now_6m.isBefore(date!));
            return now_6m.isBefore(date) ;
          }));

        }
        if(filterValue == 4){
          // print("past year ${now_1y}");
          alllststockHistory.addAll(Allocations.fromJson(response.body).allocationsHist
              .where((element) {
            final date = element.createdAt;
            print(now_1y);
            print(date);
            print(now_1y.isBefore(date!));
            return now_1y.isBefore(date) ;
          }));

        }
        _log.i(response.body);
        _log.i(alllststockHistory.length);
        isDataProcessing(true);
        _isLoading = false;
        update();
      } else {
        _isLoading = false;
        _log.e('Could not Get Products');
        //print('Could not Get Ontrack Customers');
      }
    }catch(e,s){
      _isLoading = false;
      print(s);
      showSnackBar('Exception', e.toString(), Colors.red);
    }
  }


  getLatestAllocations(bool isSync) async {
    print("getting allocations");
    if(!Hive.isAdapterRegistered(3)){
      Hive.registerAdapter(LatestAllocationModelAdapter());
    }
    // refresh();
    _isLoading = true;
    isDataProcessing(true);
    print("getting latest alloc");
    lstLatestAllocations.clear();
    lstLatestAllocations = [];
    isSync = true;
    try {
      await HiveDataManager(HiveBoxConstants.latestAllocations).getHiveData().then((box)async{
        if(box.isNotEmpty && isSync == false){
          await Hive.openBox(HiveBoxConstants.latestAllocations);
          Box _hiveBox = Hive.box(HiveBoxConstants.latestAllocations);
          print(_hiveBox.get(HiveBoxConstants.latestAllocations));
          print("getting allocations offline : ${box.get(HiveBoxConstants.latestAllocations).cast<LatestAllocationModel>()}");
          lstLatestAllocations.addAll(box.get(HiveBoxConstants.latestAllocations).cast<LatestAllocationModel>());
          print("offline allocations: ${lstLatestAllocations.length}");
          _isLoading = false;
          update();
          return;
        }else{
          print("getting my stock online");
          d.Response response = await stockHistoryRepository.getLatestAllocations();
          if (response.statusCode == 200) {
            lstLatestAllocations.addAll(LatestAllocations.fromJson(response.data).latestAllocations);
            print("adding allocations to hive");
            await HiveDataManager(HiveBoxConstants.latestAllocations).addHiveData(lstLatestAllocations);
            isDataProcessing(true);
            _isLoading = false;
            update();
          }
        }
      });


    } catch (e) {
      _isLoading = false;
      print(e);
      showSnackBar('Error occurred', "Try again later", Colors.red);
    }
  }



}