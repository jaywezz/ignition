import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/controllers/customer_checking_controller.dart';
import 'package:soko_flow/controllers/customer_provider.dart';
import 'package:soko_flow/controllers/data_sync_controller.dart';
import 'package:soko_flow/controllers/find_me.dart';
import 'package:soko_flow/controllers/product_category_controller.dart';
import 'package:soko_flow/controllers/routes_controller.dart';
import 'package:soko_flow/data/providers/deliveries/deliveries_provider.dart';
import 'package:soko_flow/data/providers/routes_provider.dart';
import 'package:soko_flow/data/providers/targets_provider.dart';
import 'package:soko_flow/data/repository/device_data/device_data_configs_repo.dart';
import 'package:soko_flow/models/route_schedule_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/app_constants.dart';
import 'package:soko_flow/utils/currency_formatter.dart';
import 'package:soko_flow/views/customers/components/customer_details.dart';
import 'package:soko_flow/views/customers/map_view.dart';
import 'package:soko_flow/views/customers/sales/user_orders.dart';
import 'package:soko_flow/views/customers/surveys/widget/custom_radio_button.dart';
import 'package:soko_flow/views/deliveries/deliveries_screen.dart.bak';
import 'package:soko_flow/views/home/components/home_data_cards.dart';
import 'package:soko_flow/views/home/components/home_schedule_card.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/receive_stock/receive_stock_screen.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/stock_lift.dart';
import 'package:soko_flow/views/inventory/inventory_screen.dart';
import 'package:soko_flow/views/routeSchedule/route_schedule2.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:upgrader/upgrader.dart';

import '../../configs/constants.dart';
import '../../configs/styles.dart';
import '../../data/providers/sales-count_provider.dart';
import '../../drawer_main.dart';
import '../../models/customer_model/customer_model.dart';
import '../../services/notification_services.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/indicators/animated_circular_progress_indicator.dart';
import '../deliveries/deliveries_screen2.dart';
import 'custom_date_picker.dart';
import 'last_31days.dart';

class HomeScreen2 extends ConsumerStatefulWidget {
  HomeScreen2({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends ConsumerState<HomeScreen2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var startDate = DateTime.now();

  void openHiveDb() async {
    await Hive.openBox('new_leads');
    await Hive.openBox('customer_visits');
    await Hive.openBox('sales_made');
    await Hive.openBox('orders');
  }

  NotifyHelper notifyHelper = NotifyHelper();

  String userEmail = '';
  String userName = '';
  String userPhone = '';

  List<UserRouteModel> todaySchedules = [];
  Future sendCurrentLocation() async {
    final myLocation = ref.watch(findMeProvider);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Position? position;
    if(prefs.getString("last_update_time") == null){
      myLocation.whenData((value) {
        ref.watch(deviceDataConfigsRepo).sendPhoneInfoAndLocation(
            value.latitude.toString(), value.longitude.toString());
        prefs.setString("last_update_time", DateTime.now().toString());
      });
    }else{
      if(DateTime.now().difference(DateTime.parse(prefs.getString("last_update_time")!)).inMinutes > 10){
        myLocation.whenData((value) {
          ref.watch(deviceDataConfigsRepo).sendPhoneInfoAndLocation(
              value.latitude.toString(), value.longitude.toString());
          prefs.setString("last_update_time", DateTime.now().toString());
        });
      }
    }

  }

  Future getData() async {
    var prefs = await SharedPreferences.getInstance();
    userPhone = (await prefs.getString(AppConstants.PHONE_NUMBER))!;
    userName = (await prefs.getString(AppConstants.USER_NAME)) ?? "";
    userEmail = (await prefs.getString(AppConstants.EMAIL))!;
    //   await _secureStore.readSecureData('name').then((value) {
    //     userName = value;
    //   });
    //   await _secureStore.readSecureData('phone').then((value) {
    //     userPhone = value;
    //   });
  }

  void getUserRoutes() async {
    todaySchedules = [];
    await ref
        .read(userRoutesNotifierProvider.notifier)
        .getUserRoutes()
        .then((value) {
      print("routes today: $value");
      setState(() {
        todaySchedules = value!;
      });
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    getUserRoutes();
    sendCurrentLocation();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    openHiveDb();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customersProvider = ref.watch(customerNotifierProvider.notifier);

    ScreenUtil.init(context);

    //SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async {
        bool exit_app = false;
        Get.dialog(AlertDialog(
          content: Container(
              width: double.maxFinite,
              child: Text(
                "Are you sure you want to Exit?",
                style: Styles.normalText(context),
              )),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: Styles.heading3(context).copyWith(color: Colors.grey),
              ),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: Text(
                "Exit",
                style: Styles.heading3(context)
                    .copyWith(color: Styles.appYellowColor),
              ),
              onPressed: () {
                setState(() {
                  exit_app = true;
                  exit(0);
                });
              },
            ),
          ],
        ));

        return exit_app;
      },
      child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          key: _scaffoldKey,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Styles.appSecondaryColor,
            onPressed: () {
              Get.toNamed(RouteHelper.getCustomers(), arguments: {"user_filtered": false});
            },
            child: Icon(
              Icons.people,
              color: Colors.white,
            ),
          ),
          drawer: MainDrawer(),
          body: UpgradeAlert(
            upgrader: Upgrader(
                showIgnore: false,
                showLater: false,
                durationUntilAlertAgain: Duration(seconds: 10),
                dialogStyle: UpgradeDialogStyle.cupertino
            ),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              //color: Styles.appBackgroundColor,
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref.refresh(targetsProvider);
                  await ref.refresh(deliveriesProvider);
                  return getUserRoutes();
                },
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .205,
                      child: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .18,
                            padding: EdgeInsets.only(
                                left: defaultPadding(context),
                                right: defaultPadding(context),
                                bottom: defaultPadding(context)),
                            decoration: BoxDecoration(
                              color: Styles.appSecondaryColor,
                            ),
                          ),
                          Positioned(
                            bottom: -10,
                            right: 10,
                            left: 10,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.0.sp, vertical: 10.0.sp),
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  //set border radius more than 50% of height and width to make circle
                                ),
                                elevation: 8,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.sp),
                                  child: Row(
                                    // mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomButton(
                                        action: () {
                                          ref
                                              .watch(timeFilterProvier.state)
                                              .state = TargetsTimeFilter.Daily;
                                        },
                                        text: 'Daily',
                                        isSelected: ref
                                                .watch(timeFilterProvier.state)
                                                .state ==
                                            TargetsTimeFilter.Daily,
                                      ),
                                      CustomButton(
                                        action: () {
                                          ref
                                              .watch(timeFilterProvier.state)
                                              .state = TargetsTimeFilter.Week;
                                        },
                                        text: 'This Week',
                                        isSelected: ref
                                                .watch(timeFilterProvier.state)
                                                .state ==
                                            TargetsTimeFilter.Week,
                                      ),
                                      CustomButton(
                                        action: () {
                                          ref
                                              .watch(timeFilterProvier.state)
                                              .state = TargetsTimeFilter.Month;
                                        },
                                        text: 'This Month',
                                        isSelected: ref
                                                .watch(timeFilterProvier.state)
                                                .state ==
                                            TargetsTimeFilter.Month,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 10,
                            top: 40,
                            child: IconButton(
                                onPressed: () {
                                  _scaffoldKey.currentState?.openDrawer();
                                  // Navigate.instance.toRoute(MainDrawer());
                                },
                                icon: Icon(
                                  Icons.menu,
                                  color: Styles.appBackgroundColor,
                                )),
                          ),
                          Positioned(
                            right: 20,
                            top: 50,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: defaultPadding(context) / 2),
                              child: InkWell(
                                splashColor: Theme.of(context).splashColor,
                                onTap: () {
                                  Get.toNamed(RouteHelper.ProfileScreen());
                                },
                                child: CircleAvatar(
                                  radius: defaultPadding(context) * 1.2,
                                  backgroundColor: Styles.appBackgroundColor,
                                  backgroundImage: const AssetImage(
                                      'assets/logo/playstore.png'),
                                  // backgroundImage: AssetImage("assetName"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 20),
                        children: [
                          ref.watch(filteredTargetsProvider).when(
                              data: (data) => DataCard(
                                  leadingColor: Styles.appPrimaryColor,
                                  icon: SvgPicture.asset(
                                    "assets/icons/1 – P – 6.svg",
                                    height: 25.w,
                                    color: Colors.white,
                                    matchTextDirection: true,
                                  ),
                                  cardName: "Sales",
                                  targets:
                                  "${formatCurrency.format(roundUpAbsolute(double.parse(data.targetSales!))).toString()}",
                                  percentage: roundUpAbsolute((double.parse(data.achievedSalesTarget??"1") /
                                      double.parse(
                                          data.targetSales??"1") *
                                      100))
                                      .toString(),
                                  achieved:
                                  "${formatCurrency.format(int.parse(data.achievedSalesTarget??"1"))}"),
                              error: (error, stackTrace) =>
                                  Text("Error getting Targets: $error"),
                              loading: () =>
                                  Center(child: CircularProgressIndicator())),
                          SizedBox(
                            height: 15.h,
                          ),

                          SizedBox(
                            height: 15.h,
                          ),
                          ref.watch(filteredTargetsProvider).when(
                              data: (data) => GestureDetector(
                                onTap: (){
                                  Get.to(RouteSchedule2());
                                },
                                child: DataCard(
                                    leadingColor: Styles.appSecondaryColor,
                                    icon: SvgPicture.asset(
                                      "assets/icons/1 – P – 8.svg",
                                      height: 20.w,
                                      color: Colors.white,
                                      matchTextDirection: true,
                                    ),
                                    cardName: "Visits",
                                    targets: formatCurrency
                                        .format(roundUpAbsolute(double.parse(
                                        data.targetsVisit!)))
                                        .toString(),
                                    percentage: roundUpAbsolute((double.parse(data.achievedVisitTarget??"1") /
                                        double.parse(data
                                            .targetsVisit!) *
                                        100))
                                        .toString(),
                                    achieved: formatCurrency.format(int.parse(data.achievedVisitTarget??"1"))),
                              ),
                              error: (error, stackTrace) =>
                                  Text("Error getting Targets: $error"),
                              loading: () =>
                                  Center(child: CircularProgressIndicator())),
                          SizedBox(
                            height: 15.h,
                          ),
                          ref.watch(filteredTargetsProvider).when(
                              data: (data) => GestureDetector(
                                onTap: (){
                                  Get.toNamed(RouteHelper.getCustomers(), arguments: {"user_filtered": true});
                                },
                                child: DataCard(
                                    leadingColor: Styles.appYellowColor,
                                    icon: SvgPicture.asset(
                                      "assets/icons/1 – P – 9.svg",
                                      height: 20.w,
                                      color: Colors.white,
                                      matchTextDirection: true,
                                    ),
                                    cardName: "Leads",
                                    targets: formatCurrency
                                        .format(roundUpAbsolute(double.parse(
                                        data.targetLeads!)))
                                        .toString(),
                                    percentage: roundUpAbsolute((double.parse(data.achievedLeadsTarget??"1") /
                                        double.parse(
                                            data.targetLeads!) *
                                        100))
                                        .toString(),
                                    achieved: formatCurrency.format(int.parse(data.achievedLeadsTarget??"1"))),
                              ),
                              error: (error, stackTrace) =>
                                  Text("Error getting Targets: $error"),
                              loading: () =>
                                  Center(child: CircularProgressIndicator())),
                          SizedBox(
                            height: 15.h,
                          ),
                          ref.watch(filteredTargetsProvider).when(
                              data: (data) => GestureDetector(
                                onTap: (){
                                  Get.to(UserOrdersScreen());
                                },
                                child: DataCard(
                                    leadingColor: Styles.appSecondaryColor,
                                    icon: SvgPicture.asset(
                                      "assets/icons/1 – P – 7.svg",
                                      height: 20.w,
                                      color: Colors.white,
                                      matchTextDirection: true,
                                    ),
                                    cardName: "Orders",
                                    targets: formatCurrency
                                        .format(roundUpAbsolute(double.parse(
                                        data.targetsOrder!)))
                                        .toString(),
                                    percentage: roundUpAbsolute((double.parse(data.achievedOrderTarget??"1") /
                                        double.parse(data
                                            .targetsOrder!) *
                                        100))
                                        .toString(),
                                    achieved: formatCurrency.format(int.parse(data.achievedOrderTarget??"1"))),
                              ),
                              error: (error, stackTrace) =>
                                  Text("Error getting Targets: $error"),
                              loading: () =>
                                  Center(child: CircularProgressIndicator())),
                          SizedBox(
                            height: 20.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    ref.read(deliveryTypeProvider.state).state = DeliveryTypes.UnAccepted;
                                    Get.toNamed(RouteHelper.UserDeliveries());
                                  },
                                  child: Container(
                                    width: context.width,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: Styles.appSecondaryColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            CupertinoIcons.car_detailed,
                                            color: Styles.appSecondaryColor,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          "Pending Deliveries",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        ref.watch(deliveriesProvider).when(
                                            data: (data){
                                              return Text(
                                                data.where((element) => element.deliveryStatus == "Waiting acceptance").toList().length.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              );
                                            },
                                            error: (e,s){
                                              return Text("Error", style: TextStyle(color: Colors.red),);
                                            },
                                            loading: (){
                                              return Text("-");
                                            })
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0.sp),
                            child: Text(
                              "Route Schedules",
                              style:
                                  Styles.heading2(context).copyWith(fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Today",
                                    style: Styles.heading4(context)
                                        .copyWith(color: Colors.black54),
                                  ),
                                  Text(
                                    DateFormat.yMMMMd().format(DateTime.now()),
                                    style: Styles.heading4(context)
                                        .copyWith(color: Colors.black54),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0.sp),
                            child: todaySchedules.length == 0
                                ? Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Center(
                                        child: Text(
                                      "No schedules today",
                                      style: Styles.heading3(context)
                                          .copyWith(color: Colors.black26),
                                    )),
                                  )
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    // key: PageStorageKey(ind),
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: todaySchedules.length,
                                    itemBuilder: (builder, ind) {
                                      return HomeScheduleCard(
                                          todaySchedules: todaySchedules[ind]);
                                    }),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
