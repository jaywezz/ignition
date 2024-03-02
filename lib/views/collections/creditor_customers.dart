import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletons/skeletons.dart';
import 'package:soko_flow/configs/constants.dart';

import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/customer_checking_controller.dart';
import 'package:soko_flow/controllers/geolocation_controller.dart';

import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/app_constants.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/components/customer_details.dart';
import 'package:soko_flow/views/customers/drive_to_customer.dart';
import 'package:soko_flow/views/customers/map_view.dart';
import 'package:soko_flow/views/customers/new_customer.dart';
import 'package:soko_flow/views/home/home_screen.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:soko_flow/widgets/custom_button.dart';
import 'package:soko_flow/widgets/inputs/search_field.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/customer_provider.dart';
import '../../controllers/customers_controller.dart';
import '../../controllers/find_me.dart';
import '../../models/customer_checkin.dart';
import '../../models/customer_model/customer_model.dart';
import '../errors/empty_failure_no_internet_view.dart';
import '../../widgets/cards/customer_list_card.dart';

final filterByUserProvider = StateProvider<bool>((ref) {
  return false;
});
class CreditorCustomers extends ConsumerStatefulWidget {
  const CreditorCustomers({Key? key}) : super(key: key);

  @override
  ConsumerState<CreditorCustomers> createState() => _CreditorCustomersState();
}

class _CreditorCustomersState extends ConsumerState<CreditorCustomers> {
  List<CustomerDataModel> results = [];
  bool searching = false;
  List<String> result = [];
  String userCode = "";

  String customerStatusView = "Approved";

  getUserCode()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCode = prefs.getString(AppConstants.USER_CODE)!;
    });
  }

  @override
  void initState() {
    getUserCode();
    if(Get.arguments !=null){
      setState(() {
        userFiltered = Get.arguments["user_filtered"];
      });
    }
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Get.find<CustomersController>().getCustomers(45, false);
    // });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // activityStreamController.close();
    // _geofenceStreamController.close();

    // Get.find<CustomerCheckingController>().geofenceStreamController.close();
    super.dispose();
  }

  bool _mapView = false;
  double calculateDistance(lat1, lon1, lat2, lon2) {
    // print("calculating distance: ${lat1} $lat2, $lon1, $lon2 }");
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    // print("distance calculated: ${12742 * asin(sqrt(a))}");
    return 12742 * asin(sqrt(a));
  }

  bool userFiltered = false;

  List<CustomerDataModel> myCustomers = [];
  bool isCheckin = false;

  @override
  Widget build(BuildContext context) {
    final customersProvider = ref.watch(customerNotifierProvider.notifier);
    final myLocation = ref.watch(findMeProvider);
    return GetBuilder<CustomerCheckingController>(
        builder: (customerCheckinController) {
          return WillStartForegroundTask(
            foregroundTaskOptions: const ForegroundTaskOptions(
              interval: 5000,
              autoRunOnBoot: false,
              allowWifiLock: false,
            ),
            onWillStart: () async {
              // You can add a foreground task start condition.
              return Get.find<CustomerCheckingController>()
                  .geofenceService
                  .isRunningService;
            },
            androidNotificationOptions: AndroidNotificationOptions(
              channelId: 'geofence_service_notification_channel',
              channelName: 'Geofence Service Notification',
              channelDescription:
              'This notification appears when the geofence service is running in the background.',
              channelImportance: NotificationChannelImportance.LOW,
              priority: NotificationPriority.LOW,
              isSticky: false,
            ),
            iosNotificationOptions: const IOSNotificationOptions(),
            notificationTitle: 'Geofence Service is running',
            notificationText: 'Tap to return to the app',
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                tooltip: 'Add Customer',
                backgroundColor: Styles.appPurpleColor,
                splashColor: Theme.of(context).splashColor,
                onPressed: () {
                  Navigator.pop(context);
                  Get.find<GeolocationController>();
                  // Get.toNamed(RouteHelper.addCustomers());
                  // Navigate.instance.toRoute(const AddNewCustomer());
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddNewCustomer();
                  }));
                },
                child: Icon(
                  Icons.add,
                  size: Responsive.isMobile(context)
                      ? defaultPadding(context) * 2.1
                      : defaultPadding(context) * 2.4,
                  color: Styles.appBackgroundColor,
                ),
              ),
              body: WillPopScope(
                onWillPop: () async {
                  Get.toNamed(RouteHelper.getInitial());
                  return true;
                },
                child: SafeArea(
                  child: GetBuilder<CustomersController>(
                    builder: (controller) {
                      return myLocation.when(data: (data) {
                        // Future.delayed(Duration.zero, () {
                        //   // print("the length of customers: ${controller.lstcustomers.length}");
                        //
                        // });
                        myCustomers = [];
                        myCustomers.addAll(controller.lstcustomers.where((element) => element.creditorStatus == "1").toList());
                        if(customerStatusView == "Pending"){
                          myCustomers = myCustomers.where((element) => element.approval == "approved").toList();
                        }else{
                          myCustomers = myCustomers.where((element) => element.approval == "waiting_approval").toList();
                        }
                        print("customer lenth: ${myCustomers.length}");
                        myCustomers.sort((a, b) {
                          // print("a: ${a.customerName}, b: ${b.customerName}");
                          return calculateDistance(
                              data.latitude,
                              data.longitude,
                              double.parse(a.latitude == "" ? "-0.4264737" : a.latitude!),
                              double.parse(a.longitude == "" ? "37.5679389" : a.longitude!))
                              .compareTo(calculateDistance(data.latitude, data.longitude,
                              double.parse(b.latitude == "" ? "-0.4264737" : b.latitude!),
                              double.parse(b.longitude == "" ? "37.5679369" : b.longitude!)));
                        });
                        print("csacbasjkb: ${myCustomers.length}");


                        return SizedBox(
                          height: double.infinity,
                          width: double.infinity,

                          //color: Styles.appBackgroundColor,
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(
                                left: defaultPadding(context),
                                right: defaultPadding(context),
                              ),
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/logo/bg.png'),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(30))),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: defaultPadding(context),
                                  ),
                                  Stack(
                                    children: [
                                      Material(
                                        child: InkWell(
                                          splashColor: Theme.of(context).splashColor,
                                          onTap: () {
                                            Get.offNamed(RouteHelper.getInitial());
                                            // Get.back();
                                          },
                                          child: Icon(
                                            Icons.arrow_back_ios_new,
                                            color: Styles.darkGrey,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          userFiltered?"My Customers":'Customers',
                                          style: Styles.heading2(context),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Material(
                                          child: InkWell(
                                            splashColor:
                                            Theme.of(context).splashColor,
                                            onTap: () =>
                                                Get.toNamed(RouteHelper.getInitial()),
                                            child: Icon(
                                              Icons.home_sharp,
                                              size: defaultPadding(context) * 2,
                                              color: Styles.appPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: defaultPadding(context) * 1.3,
                                  ),
                                  // ====================================
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: defaultPadding(context) * 1.8),
                                    child: LargeSearchField(
                                      onTap: () {
                                        setState(() {
                                          searching = true;
                                        });
                                      },
                                      controller: controller.searchController,
                                      onChanged: (value) {
                                        controller.filterCustomers(value);
                                      },
                                      hintText: 'Search By Name',
                                      outline: true,
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Map View",
                                        style: Styles.heading3(context),
                                      ),
                                      CupertinoSwitch(
                                        activeColor: Styles.appPrimaryColor,
                                        value: _mapView,
                                        onChanged: (value) {
                                          setState(() {
                                            _mapView = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SingleChildScrollView(
                                    physics: NeverScrollableScrollPhysics(),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
                                      child: Container(
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20.sp)
                                        ),
                                        child: Row(
                                          // mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CustomButton(
                                              action: () {
                                                setState(() {
                                                  customerStatusView = "Pending";
                                                });
                                                setState(() {

                                                });
                                              },
                                              text: 'Pending',
                                              isSelected: customerStatusView == "Pending",
                                            ),
                                            CustomButton(
                                              action: () {
                                                setState(() {
                                                  customerStatusView = "Complete";
                                                });
                                                setState(() {

                                                });
                                              },
                                              text: 'Complete',
                                              isSelected: customerStatusView == "Complete",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  _mapView
                                      ? Container(
                                      height: MediaQuery.of(context).size.height *.74,
                                      child: CustomerMapView(customer: myCustomers))
                                      : Container(
                                    height: MediaQuery.of(context).size.height,
                                    child: Obx(() {
                                      if(controller.isDataProcessing.value == true) {
                                        return SkeletonListView();
                                      } else {
                                        if (myCustomers.isNotEmpty) {
                                          return RefreshIndicator(
                                            onRefresh: () {
                                              ref.refresh(findMeProvider.future);
                                              customerCheckinController.geofenceStreamController.stream;
                                              setState(() {
                                                myCustomers = [];
                                              });
                                              return controller.getCustomers(45, true);
                                            },
                                            child: StreamBuilder<Geofence>(
                                              stream: customerCheckinController.geofenceStreamController.stream,
                                              builder: (context, snapshot) {
                                                return ListView.builder(
                                                    itemCount:  myCustomers.length,
                                                    itemBuilder: ((context, index) {
                                                      print("my customers length: ${myCustomers.length}");
                                                      bool isCurrentCustomer = false;
                                                      bool isCloseCustomer = false;
                                                      // print("Gps : ${controller.lstcustomers[index].latitude}");
                                                      if( myCustomers[index].latitude == "" ||  myCustomers[index].longitude == ""){
                                                        // print("Gps : ${controller.lstcustomers[index].latitude}");
                                                      }else{
                                                        if (index ==  myCustomers.length - 1 && controller.isMoreDataAvailable.value == true) {
                                                          return Center(
                                                            child: Platform.isAndroid
                                                                ? const CircularProgressIndicator()
                                                                : const CupertinoActivityIndicator(),
                                                          );
                                                        }
                                                        // print("active geofences: ${customerCheckinController.activeGeofences}");
                                                        var contain = customerCheckinController.activeGeofences.where((element) => element.id ==
                                                            myCustomers[index].id.toString());
                                                        // print("the contain: $contain");
                                                        if (contain.isNotEmpty) {
                                                          //find the geofence
                                                          final ind = customerCheckinController.activeGeofences.indexWhere((element) => element.id == myCustomers[index].id.toString());
                                                          // print("eg index is: $index");
                                                          if (ind >= 0) {
                                                            Geofence fence = customerCheckinController.activeGeofences[ind];
                                                            if (fence.radius[0].status != GeofenceStatus.EXIT) {
                                                              // print("is 10 meters close");
                                                              isCurrentCustomer = true;
                                                            } else if (fence.radius[1].status != GeofenceStatus.EXIT) {
                                                              isCloseCustomer = true;
                                                            }
                                                          }
                                                        }
                                                      }

                                                      double distance =calculateDistance(
                                                          data.latitude,
                                                          data.longitude,
                                                          double.parse(myCustomers[index].latitude == "" ? "-0.4264737" : myCustomers[index].latitude!),
                                                          double.parse(myCustomers[index].longitude == "" ? "37.5679389" : myCustomers[index].longitude!));


                                                      return Stack(
                                                        children: [
                                                          CustomerListCard(
                                                              distance: distance,
                                                              hasGeoData:  myCustomers[index].latitude != null ||   myCustomers[index].latitude != "",
                                                              phoneNumber:  myCustomers[index].phoneNumber,
                                                              trackingaction: () {
                                                                Navigator.of(context).push(
                                                                    MaterialPageRoute(builder: (context) =>
                                                                        CustomerTrackingPage(
                                                                          shopName:  myCustomers[index].customerName!,
                                                                          sourceLocation: LatLng(data.latitude, data.longitude),
                                                                          destination: LatLng(double.parse( myCustomers[index].latitude!), double.parse(myCustomers[index].longitude!)),
                                                                        )));
                                                              },
                                                              action: () async {
                                                                // =====Implement the Checkin=====/
                                                                setState(() {
                                                                  isCheckin = true;
                                                                });
                                                                if(myCustomers[index].approval == "waiting_approval"){
                                                                  showCustomSnackBar("Customer Not yet Approved");
                                                                }else{
                                                                  if (isCurrentCustomer || distance < 0.5) {
                                                                    Position position = await customersProvider.getGeoLocationPosition();
                                                                    String cstIndex =  myCustomers[index].id.toString();
                                                                    print('index: $cstIndex');
                                                                    print(cstIndex.runtimeType);
                                                                    CustomerCheckinModel checkinCode = await customerCheckinController.createCheckinSession(
                                                                      // "${controller.lstcustomers[index].id!.toString()}",
                                                                        position.latitude.toString(),
                                                                        position.longitude.toString(),
                                                                        // "4158",
                                                                        cstIndex,
                                                                        "xtUxiU");
                                                                    print(
                                                                        "the customer checkin code: ${checkinCode.checkingCode}");
                                                                    await customerCheckinController.addCheckingData(
                                                                      checkinCode.checkingCode!,
                                                                      myCustomers[index].id!,
                                                                      myCustomers[index].customerName!,
                                                                      myCustomers[index].address!,
                                                                      myCustomers[index].email ?? "",
                                                                      myCustomers[index].phoneNumber!,
                                                                      myCustomers[index].latitude ?? "0.0",
                                                                      myCustomers[index].longitude ?? "0.0",
                                                                    );

                                                                    Get.to(CustomerDetailsScreen(customer: controller.lstcustomers[index]));
                                                                  } else {
                                                                    Get.dialog(
                                                                        AlertDialog(
                                                                          title: Text("Customer out of range", style: Styles.heading2(context),
                                                                          ),
                                                                          content: Container(width: double.maxFinite,
                                                                              child: Text("Selected customer is out of range. Do you wish to proceed",
                                                                                style: Styles.normalText(context),)),
                                                                          actions: [
                                                                            TextButton(
                                                                              child:
                                                                              Text("Cancel",
                                                                                style: Styles.heading3(context).copyWith(color: Colors.grey),
                                                                              ),
                                                                              onPressed: () => Get.back(),
                                                                            ),
                                                                            TextButton(
                                                                              child: Text("Proceed", style: Styles.heading3(context).copyWith(color: Styles.appYellowColor),
                                                                              ),
                                                                              onPressed:
                                                                                  () async {
                                                                                await customerCheckinController.addCheckingData("",  myCustomers[index].id!,
                                                                                  myCustomers[index].customerName!,
                                                                                  myCustomers[index].address!,
                                                                                  myCustomers[index].email ?? "",
                                                                                  myCustomers[index].phoneNumber!,
                                                                                  myCustomers[index].latitude!,
                                                                                  myCustomers[index].longitude!,
                                                                                );
                                                                                Get.to(CustomerDetailsScreen(
                                                                                    customer:  myCustomers[index]));
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ));
                                                                    // Get.toNamed(
                                                                    //     RouteHelper.getCustomerDetails());
                                                                  }
                                                                }
                                                                setState(() {
                                                                  isCheckin = false;
                                                                });
                                                              },
                                                              children: [
                                                                myCustomers[index].customerName![0].toUpperCase(),
                                                                //mycustomers[index]['name'][0].toUpperCase(),
                                                                myCustomers[index].customerName!,
                                                                //mycustomers[index]['name'],
                                                                myCustomers[index].address ?? "Nairobi",
                                                                //mycustomers[index]['location'],
                                                              ],
                                                              isCurrentCustomer: isCurrentCustomer,
                                                              isCloseCustomer: isCloseCustomer),
                                                          Positioned(
                                                            top: 5,
                                                            right: 10,
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(10),
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                                color:  Styles.appButtonColor,
                                                                child: Text(
                                                                  calculateDistance(data.latitude, data.longitude, double.parse(myCustomers[index].latitude == "" ? "-0.4264737" :  myCustomers[index].latitude!), double.parse( myCustomers[index].longitude == "" ? "37.5679389" : myCustomers[index].longitude!)).toStringAsFixed(2).toString() +
                                                                      " Km" ==
                                                                      "0.00 Km"
                                                                      ? "Arrived"
                                                                      : calculateDistance(
                                                                      data.latitude,
                                                                      data.longitude,
                                                                      double.parse(myCustomers[index].latitude == "" ? "-0.4264737" : myCustomers[index].latitude!),
                                                                      double.parse(myCustomers[index].longitude == "" ? "37.5679389" : myCustomers[index].longitude!))
                                                                      .toStringAsFixed(2)
                                                                      .toString() +
                                                                      " Km",
                                                                  style: TextStyle(
                                                                      color: Styles.appBackgroundColor),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }));
                                              },
                                            ),
                                          );
                                        } else {
                                          return searching
                                              ? SingleChildScrollView(
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "No search results. Try other search keywords",
                                                    style: Styles.smallGreyText(context),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Lottie.asset(
                                                      "lottie/no_search.json"),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  MaterialButton(
                                                    color: Styles
                                                        .appPrimaryColor,
                                                    height: Responsive.isMobile(context) && Responsive.isMobileLarge(context)
                                                        ? 30
                                                        : 50,
                                                    //SizeConfig.isTabletWidth ? 70 : 50,
                                                    child: Text("Cancel",
                                                        style: Styles.buttonText2(context)),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(defaultRadius1)),
                                                    onPressed: () {
                                                      controller.searchController.clear();
                                                      setState(() {
                                                        myCustomers = [];
                                                        searching = false;
                                                      });
                                                      controller
                                                          .getCustomers(20, false);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                              : SingleChildScrollView(
                                            physics:
                                            BouncingScrollPhysics(),
                                            child:
                                            EmptyFailureNoInternetView(
                                              image:
                                              'lottie/no_search.json',
                                              title: 'No customers',
                                              description: "",
                                              buttonText: "Refresh",
                                              onPressed: () {
                                                setState(() {
                                                  myCustomers = [];
                                                });
                                                controller.getCustomers(20, true);
                                              },
                                            ),
                                          );
                                        }
                                      }
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }, error: (e, s) {
                        if(e.toString() == "Location permissions are denied." ||e.toString() == "Location permissions are permanently denied, We cannot request permissions."){
                          return  Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(e.toString(), style: Styles.heading3(context).copyWith(color: Colors.black54),),
                                  SizedBox(height: 10,),
                                  FullWidthButton(
                                      text: "Enable Location",
                                      action: (){
                                        Geolocator.openAppSettings().then((value) {
                                          ref.refresh(findMeProvider);
                                          customerCheckinController.geofenceStreamController.stream;
                                          setState(() {
                                            myCustomers = [];
                                          });
                                          controller.getCustomers(45, true);

                                        });
                                      })
                                ],
                              ),
                            ),
                          );
                        }else{
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(e.toString(), style: Styles.heading3(context).copyWith(color: Colors.black54),),
                                  SizedBox(height: 10,),
                                  FullWidthButton(
                                      text: "Enable Location",
                                      action: (){
                                        Geolocator.openLocationSettings().then((value) {
                                          ref.refresh(findMeProvider);
                                          customerCheckinController.geofenceStreamController.stream;
                                          setState(() {
                                            myCustomers = [];
                                          });
                                          controller.getCustomers(45, true);

                                        });
                                      })
                                ],
                              ),
                            ),
                          );
                        }

                      }, loading: () {
                        return Center(
                          child: Text("Getting your location..."),
                        );
                      });
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }
}
