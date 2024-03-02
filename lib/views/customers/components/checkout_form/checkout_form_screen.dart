import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/data/providers/customer_provider.dart';
import 'package:soko_flow/utils/app_constants.dart';
import 'package:soko_flow/views/customers/components/checkout_form/form_review_section.dart';
import 'package:soko_flow/views/customers/components/checkout_form/not_prescent_section.dart';
import 'package:soko_flow/views/customers/components/checkout_form/placement_section.dart';
import 'package:soko_flow/views/customers/components/checkout_form/presence_section.dart';
import 'package:soko_flow/views/customers/components/checkout_form/pricing_section.dart';
import 'package:soko_flow/views/customers/components/checkout_form/widgets/pill_button.dart';
import 'package:soko_flow/views/customers/components/customer_details.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'widgets/keep_alive_wrapper.dart';



class CheckoutFormScreen extends ConsumerStatefulWidget {
  const CheckoutFormScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CheckoutFormScreen> createState() => _CheckoutFormScreenState();
}

class _CheckoutFormScreenState extends ConsumerState<CheckoutFormScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentIndex = 0;
  String? dateTime;
  GlobalKey<FormState> form1 = GlobalKey<FormState>();
  GlobalKey<FormState> form2 = GlobalKey<FormState>();
  GlobalKey<FormState> form3 = GlobalKey<FormState>();
  GlobalKey<FormState> form4 = GlobalKey<FormState>();
  late Timer _timer;
  int seconds = 0;
  int? customerId;
  String? customerName;
  String? customerAddress;
  String? customerEmail;
  String? customerPhone;
  String? checkingCode;
  double? lat;
  double? long;
  String pendingAmount = "0";

  String accountType = "";

  getCustomerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("keys ${prefs.getKeys()}");
    checkingCode = prefs.getString('checkinCode');
    customerId = prefs.getInt('customerId');
    customerName = prefs.getString('customerName');
    customerAddress = prefs.getString('customerAddress');
    customerEmail = prefs.getString('customerEmail');
    customerPhone = await prefs.getString('customerPhone');
    lat = await double.parse(prefs.getString('lat')!);
    long = await double.parse(prefs.getString('long')!);

    print("checking code at customer $customerId");
  }

  void startTimer() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const period = const Duration(seconds: 1);
    print("not null: ${prefs.getInt("countDown")}");
    if(prefs.getInt("countDown")!=null){
      setState(() {
        seconds = prefs.getInt("countDown")!;
      });
    }
    _timer = Timer.periodic(period, (timer) {
      setState(() {
        seconds++;
      });
      print("new second: $seconds");
      prefs.setInt("countDown", seconds);

      if(prefs.getString("checkinCode") == null){
        _timer.cancel();
        prefs.setInt("countDown", 0);
      }
      // if (seconds == 18000) {
      //   _timer.cancel();
      // }
    });
  }


  // DateTime selectedDate = DateTime.now();
  TimeOfDay time = const TimeOfDay(hour: 10, minute: 15);
  @override
  void initState() {
    getCustomerData();
    if(checkingCode !=""){
      startTimer();
    }
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener((() {
      setState(() {
        currentIndex = _tabController.index;
      });
    }));

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      bottomNavigationBar: ref.watch(customerNotifier).isLoading?Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: MediaQuery.of(context).size.height * .1,
                child: Center(child: CircularProgressIndicator())),
          ):Padding(
            padding: const EdgeInsets.all(8.0),
            child: FullWidthButton(
            color: Styles.appButtonColor,
            action: () async {
                  if(currentIndex ==1){
                    if(form3.currentState!.validate()){

                      // await ref.read(customerNotifier.notifier).submitCheckOutForm();
                      Get.dialog(CheckoutDialogWidget(checkinCode: checkingCode!));
                    }else{
                      print("not valid");
                      _tabController.animateTo(0);
                    }

                  }else{

                    setState(() {
                      _tabController.animateTo(currentIndex +1);
                    });
                  }
            },
            text: currentIndex==1?'Submit & Checkout: ${constructTime(seconds)}':"Next ${constructTime(seconds)}",
      ),
          ),
      resizeToAvoidBottomInset: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/logo/bg.png',
              ),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              title: Align(
                alignment: Alignment.center,
                child: Text(
                  "Checkout Form",
                  style: Styles.heading2(context)
                      .copyWith(color: Colors.black54),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Styles.appSecondaryColor, width: 1)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "${customerName == null?"N":customerName![0].toUpperCase()}",
                    style: Styles.heading1(context),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              customerName??"No Name",
              style: Styles.heading3(context)
                  .copyWith(fontWeight: FontWeight.w100),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              DateFormat.yMMMMd().format(DateTime.parse(DateTime.now().toString())),
              style: Styles.heading4(context).copyWith(
                  fontWeight: FontWeight.w100,
                  fontSize: 10.sp,
                  color: Colors.grey),
            ),
            const SizedBox(
              height: 15,
            ),
            Card(
              child: Container(
                color: Colors.white,
                width: ScreenUtil().screenWidth - (12.w),
                padding: EdgeInsets.only(top: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Expanded(
                    //   child: LeadPillButton(
                    //       selected: currentIndex == 0 ? true : false,
                    //       action: () {
                    //         setState(() {
                    //           _tabController.animateTo(0);
                    //         });
                    //       },
                    //       text: "Stock Available"),
                    // ),
                    // SizedBox(
                    //   width: 5.w,
                    // ),
                    // Expanded(
                    //   child: LeadPillButton(
                    //       selected: currentIndex == 1 ? true : false,
                    //       action: () {
                    //         setState(() {
                    //           _tabController.animateTo(1);
                    //         });
                    //       },
                    //       text: "Out of Stock"),
                    // ),
                    Expanded(
                      child: LeadPillButton(
                          selected: currentIndex == 0 ? true : false,
                          action: () {
                            setState(() {
                              _tabController.animateTo(0);
                            });
                          },
                          text: 'Comments'),
                    ),
                    Expanded(
                      child: LeadPillButton(
                          selected: currentIndex == 1 ? true : false,
                          action: () {
                            print("presses");
                            setState(() {
                              _tabController.animateTo(1);
                            });
                          },
                          text: 'Placement'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: TabBarView(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    // KeepAliveWrapper(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(10.0),
                    //     child: Form(
                    //         autovalidateMode:
                    //         AutovalidateMode.onUserInteraction,
                    //         key: form1,
                    //         child: PrescenceSection()),
                    //   ),
                    // ),
                    // KeepAliveWrapper(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(10.0),
                    //     child: Form(
                    //         autovalidateMode:
                    //         AutovalidateMode.onUserInteraction,
                    //         key: form2,
                    //         child: OutofStockSection()),
                    //   ),
                    // ),
                    KeepAliveWrapper(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            key: form3,
                            child: SingleChildScrollView(
                                child: PricingSection())),
                      ),
                    ),
                    KeepAliveWrapper(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            key: form4,
                            child: PlacementSection()),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  String constructTime(int seconds) {
    int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return "${formatTime(hour)}:${formatTime(minute)}:${formatTime(second)}";
  }

  String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

}



