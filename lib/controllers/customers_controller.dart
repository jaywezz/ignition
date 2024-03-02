import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geofence_service/models/geofence.dart';
import 'package:geofence_service/models/geofence_radius.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:soko_flow/controllers/customer_checking_controller.dart';
import 'package:soko_flow/data/hive_database/hive_constants.dart';
import 'package:soko_flow/data/hive_database/hive_manager.dart';

import '../data/repository/customers_repo.dart';
import '../models/customer_model/customer_model.dart';

class CustomersController extends GetxController {
  CustomerRepository customerRepository;
  CustomersController({ required this.customerRepository});
  final searchController = TextEditingController();
  List<CustomerDataModel> lstcustomers = List<CustomerDataModel>.empty(growable: true).obs;

  var pageSize = 100;
  var isDataProcessing = true.obs;

  //For Pagination
  ScrollController scrollController = ScrollController();
  var isMoreDataAvailable = false.obs;

  var connectionStatus = 0.obs;

  //bool isConnected=await InternetConnectionChecker().hasConnection;
  late StreamSubscription<InternetConnectionStatus> _listener;

  @override
  void onInit() {
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
    getCustomers(pageSize, false);
    //For Pagination
    paginateTask();
  }

  @override
  void onClose() {

    super.onClose();

    // dispose();
  }

  void filterCustomers(String entered_value) {
    isDataProcessing(true);

    List<CustomerDataModel> customer_results = [];
    if (searchController.text == "") {
      print("The value is empty");
      getCustomers(pageSize, false);
      customer_results = lstcustomers;
      isDataProcessing(false);
      update();


      // paginateTask();
      // isMoreDataAvailable(true);
    } else {
      customer_results = lstcustomers.where((element) => [ element.customerName, element.phoneNumber].any((element) => element!.toLowerCase().contains(searchController.text.toLowerCase()))).toList();
      isDataProcessing(false);
      isMoreDataAvailable(false);
    }
    lstcustomers = customer_results;
    print("after search customer results length ${customer_results.length}");
    lstcustomers.forEach((element) {
      print(element.customerName);
    });
  }


  getCustomers(var pageSize, bool isRefreshing) async {
    print("isrefreshing: $isRefreshing");
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CustomerDataModelAdapter());
    }

    try {
      isDataProcessing(true);
      //change(null, status: RxStatus.loading());
      // if(false){
      lstcustomers.clear();
      if(isRefreshing == false){
        await HiveDataManager(HiveBoxConstants.customersDb).getHiveData().then((box) async {
          // List<Customer> _hiveCustomers = box.get(HiveBoxConstants.customersDb) as List<Customer>;

          // print("customer db : ${box.get(HiveBoxConstants.customersDb) as Customer}");
          lstcustomers.clear();
          if(box.get(HiveBoxConstants.customersDb) == null){
            await customerRepository.getCustomers('Qx4FstqLJfHwf3WA', 500).then(
                    (resp) async{
                  isDataProcessing(false);
                  lstcustomers.clear();
                  lstcustomers.addAll(resp.data!);

                  print("customers online: $lstcustomers");
                  //clear local data Add customers to hive database;
                  await Hive.openBox(HiveBoxConstants.customersDb);
                  Hive.box(HiveBoxConstants.customersDb).clear();
                  HiveDataManager(HiveBoxConstants.customersDb).addHiveData(lstcustomers);
                  await Get.find<CustomerCheckingController>().geofenceService.stop();
                  //Add customer to geofence
                  await Get.find<CustomerCheckingController>().addCustomerGeofences(lstcustomers);

                }, onError: (err) async{
              print("exception on error : $err");

              if(err.toString().contains("SocketException") ||err.toString().contains("TimeoutException")){
                await HiveDataManager(HiveBoxConstants.customersDb).getHiveData().then((box){
                  // List<Customer> _hiveCustomers = box.get(HiveBoxConstants.customersDb) as List<Customer>;

                  // print("customer db : ${box.get(HiveBoxConstants.customersDb) as Customer}");
                  lstcustomers.clear();
                  lstcustomers.addAll(box.get(HiveBoxConstants.customersDb).cast<CustomerDataModel>());
                });
                print("offline list of customers: $lstcustomers");

                await Get.find<CustomerCheckingController>().addCustomerGeofences(lstcustomers);
              }else{
                showSnackBar('Exceptionss', err.toString(), Colors.red);
              }
              isDataProcessing(false);
            });
          }else{
            lstcustomers.addAll(await box.get(HiveBoxConstants.customersDb).cast<CustomerDataModel>());
          }
          isDataProcessing(false);
        });
        print("offline list of customers: ${lstcustomers.length}");

        await Get.find<CustomerCheckingController>().addCustomerGeofences(lstcustomers);
      }else{
        print("getting customers");
        await customerRepository.getCustomers('Qx4FstqLJfHwf3WA', 500).then(
                (resp) async{
              isDataProcessing(false);
              lstcustomers.clear();
              lstcustomers.addAll(resp.data!);

              print("customers online: $lstcustomers");
              //clear local data Add customers to hive database;
              await Hive.openBox(HiveBoxConstants.customersDb);
              Hive.box(HiveBoxConstants.customersDb).clear();
              HiveDataManager(HiveBoxConstants.customersDb).addHiveData(lstcustomers);
              await Get.find<CustomerCheckingController>().geofenceService.stop();
              //Add customer to geofence
              await Get.find<CustomerCheckingController>().addCustomerGeofences(lstcustomers);

            }, onError: (err,s) async{
          print("exception on error : $s");

          if(err.toString().contains("SocketException") ||err.toString().contains("TimeoutException")){
            await HiveDataManager(HiveBoxConstants.customersDb).getHiveData().then((box){
              // List<Customer> _hiveCustomers = box.get(HiveBoxConstants.customersDb) as List<Customer>;

              // print("customer db : ${box.get(HiveBoxConstants.customersDb) as Customer}");
              lstcustomers.clear();
              lstcustomers.addAll(box.get(HiveBoxConstants.customersDb).cast<CustomerDataModel>());
            });
            print("offline list of customers: $lstcustomers");

            await Get.find<CustomerCheckingController>().addCustomerGeofences(lstcustomers);
          }else{
            showSnackBar('Error', "An error occurred. Try again later", Colors.red);
          }
          isDataProcessing(false);
        });
      }

    } catch (exception,s) {
      print("exception: ${s.toString()}");
      if(exception is SocketException || exception is TimeoutException){
        await HiveDataManager(HiveBoxConstants.customersDb).getHiveData().then((box){
          print("customer db : ${box.get(HiveBoxConstants.customersDb)}");
          lstcustomers.clear();
          lstcustomers = box.get(HiveBoxConstants.customersDb) ;
        });

        print("offline list of customers: $lstcustomers");

        await Get.find<CustomerCheckingController>().addCustomerGeofences(lstcustomers);
      }else{
        showSnackBar('Error', "An error occurred. Try again later", Colors.red);
      }
      isDataProcessing(false);

      // showSnackBar('Exception', exception.toString(), Colors.red);
      //change(null, status: RxStatus.error(exception.toString()));
    }
  }

  //common snack bar
  showSnackBar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
    );
  }

  void paginateTask() {
    // print("Paginate task called");
    scrollController.addListener(() {
      // print("listener added");
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print(
            "Reached The end${scrollController.position.pixels} and max ${scrollController.position.maxScrollExtent}");
        pageSize++;
        getMoreCustomers(pageSize);
      }
    });
  }

  //Get More data
  void getMoreCustomers(var pageSize) {
    print("getting more customers");
    try {
      print("the page size is: ${pageSize}");
      customerRepository.getCustomers('Qx4FstqLJfHwf3WA', pageSize).then(
          (resp) {
        if (resp.data!.isNotEmpty) {
          print("there are more customers");
          isMoreDataAvailable(true);
        } else {
          print("there are no more customers");
          isMoreDataAvailable(false);
          showSnackBar("Message", "No more Items", Colors.lightBlueAccent);
        }
        print("Is more data available ${isMoreDataAvailable.value}");
        lstcustomers.addAll(resp.data!);
        update();
      }, onError: (err) {
        isMoreDataAvailable(false);
        showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isMoreDataAvailable(false);

      showSnackBar('Exception', e.toString(), Colors.red);
    }
  }
}
