import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/data_sync_controller.dart';
import 'package:soko_flow/data/providers/targets_provider.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/app_constants.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/auth/forgot_password_page.dart';
import 'package:soko_flow/views/auth/login_page.dart';
import 'package:soko_flow/views/customers/sales/van_sales.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/view_my_stock.dart';
import 'package:soko_flow/views/routeSchedule/route_schedule2.dart';
import 'package:soko_flow/widgets/shimmer_loader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/auth_controller.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  // String userEmail = '';
  String userName = '';
  // String userPhone = '';

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  getData() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      phoneNumberController.text =
      (prefs.getString(AppConstants.PHONE_NUMBER))!;
      userName = (prefs.getString(AppConstants.USER_NAME)) ?? "";
      emailController.text = (prefs.getString(AppConstants.EMAIL)) ?? "None";
    });
  }

  Future<void> _sendSMS(String phoneNumber) async {
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: Uri.encodeComponent(phoneNumber),
      queryParameters: <String, String>{
        'body': Uri.decodeComponent(''),
      },
    );
    await launchUrl(smsLaunchUri);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    print("calling");
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/logo/bg.png',
                ),
                fit: BoxFit.cover),
            // borderRadius:
            // BorderRadius.only(bottomLeft: Radius.circular(30))
          ),
          child: Stack(
            fit: StackFit.passthrough,
            // padding: EdgeInsets.zero,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(35))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: defaultPadding(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 30),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Material(
                                child: InkWell(
                                  splashColor: Styles.appPrimaryColor,
                                  onTap: () async {
                                    Get.back();
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.black,
                                  ),
                                ),
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Profile",
                                  style: Styles.heading2(context)
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: PopupMenuButton<int>(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.black,
                                ),
                                itemBuilder: (context) => [
                                  // PopupMenuItem 1
                                  PopupMenuItem(
                                    value: 1,
                                    // row with 2 children
                                    child: Row(
                                      children: [
                                        const Icon(Icons.sync),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Sync Data",
                                          style: Styles.heading3(context),
                                        )
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    // row with 2 children
                                    child: Row(
                                      children: [
                                        const Icon(Icons.call),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Call Admin",
                                          style: Styles.heading3(context),
                                        )
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 3,
                                    // row with 2 children
                                    child: Row(
                                      children: [
                                        const Icon(Icons.message),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Message Admin",
                                          style: Styles.heading3(context),
                                        )
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 4,
                                    // row with 2 children
                                    child: Row(
                                      children: [
                                        const Icon(Icons.message),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Reset Password",
                                          style: Styles.heading3(context),
                                        )
                                      ],
                                    ),
                                  ),
                                  // PopupMenuItem 2
                                  PopupMenuItem(
                                    value: 5,
                                    // row with 2 children
                                    child: Row(
                                      children: [
                                        const Icon(Icons.logout),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Log Out ",
                                          style: Styles.heading3(context),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                                offset: const Offset(0, 40),
                                color: Colors.white,
                                elevation: 2,
                                // on selected we show the dialog box
                                onSelected: (value) async{
                                  // if value 1 show dialog
                                  if (value == 1) {
                                    try{
                                      showDialog(context: context, builder: (context){
                                        return Container(
                                          color: Colors.black38,
                                          height: MediaQuery.of(context).size.height,
                                          child: Center(child: CircularProgressIndicator()),
                                        );
                                      });
                                      await ref.read(dataSyncRepositoryProvider).syncData();
                                      Get.back();
                                    }catch(e){
                                      Get.back();
                                    }
                                  }
                                  if (value == 2) {
                                    _makePhoneCall("0746051278");
                                    Fluttertoast.showToast(
                                        msg: "Calling ...",
                                        backgroundColor: Styles.appYellowColor);
                                  }

                                  if (value == 3) {
                                    _sendSMS("0746051278");
                                  }
                                  if (value == 4) {
                                    Get.to(ForgotPasswordPage(screenName: "Reset Password",));
                                  }
                                  if (value == 5) {
                                    Get.find<AuthController>()
                                        .clearSharedData();

                                    Get.offNamed(RouteHelper.getLogin());
                                    Fluttertoast.showToast(
                                        msg: "Logout Successful",
                                        backgroundColor:
                                        Styles.appPrimaryColor);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CircleAvatar(
                        backgroundImage:
                        Image.asset("assets/logo/playstore.png").image,
                        maxRadius: 40.r,
                        //SizeConfig.safeBlockHorizontal * 10,
                        minRadius: 40.r,
                        // SizeConfig.safeBlockHorizontal * 10,
                      ),
                      SizedBox(
                        height: defaultPadding(context) * .8,
                      ),
                      Text(
                        userName != null ? '${userName}' : 'Mchagua Jembe',
                        style: Styles.heading1(context)
                            .copyWith(color: Styles.appSecondaryColor),
                      ),
                      SizedBox(
                        height: defaultPadding(context) * .8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            phoneNumberController.text != null
                                ? '${phoneNumberController.text}'
                                : '0723 456789',
                            style: Styles.normalText(context)
                                .copyWith(color: Colors.black),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: defaultPadding(context) * .2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            emailController.text != null
                                ? '${emailController.text}'
                                : 'mchaguajembe@gmail.com',
                            style: Styles.normalText(context)
                                .copyWith(color: Colors.black),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
              // SizedBox(height: 10.h,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.sp, vertical: 0),
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50.sp),
                          border: Border.all(color: Colors.grey)),
                      child: Padding(
                        padding: EdgeInsets.all(
                            Responsive.isMobile(context) ? 15.0.sp : 12.sp),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ref.watch(filteredTargetsProvider).when(data: (data){
                                return RichText(
                                  text: TextSpan(
                                      text: 'Orders\n',
                                      style: Styles.heading4(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: data.achievedOrderTarget!,
                                            style: Styles.normalText(context)
                                                .copyWith(
                                                color: Colors.black54,
                                                fontSize:
                                                Responsive.isMobile(context)
                                                    ? 10.sp
                                                    : 8.sp,
                                                fontWeight: FontWeight.w700))
                                      ]),
                                );
                              },
                                  error: (error, stackTrace) => Text("Error", style: Styles.heading3(context).copyWith(color: Colors.redAccent),),
                                  loading: () => Column(
                                    children: [
                                      ShimmerLoader(height: 5.h, width: 40.w),
                                      SizedBox(height: 5.h,),
                                      ShimmerLoader(height: 5.h, width: 20.w),
                                    ],
                                  )),
                              const VerticalDivider(
                                color: Colors.black38,
                                thickness: 1,
                              ),
                              ref.watch(filteredTargetsProvider).when(data: (data){
                                return RichText(
                                  text: TextSpan(
                                      text: 'Visits\n',
                                      style: Styles.heading4(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: data.achievedVisitTarget!,
                                            style: Styles.normalText(context)
                                                .copyWith(
                                                color: Colors.black54,
                                                fontSize:
                                                Responsive.isMobile(context)
                                                    ? 10.sp
                                                    : 8.sp,
                                                fontWeight: FontWeight.w700))
                                      ]),
                                );

                              },
                                  error: (error, stackTrace) => Text("Error", style: Styles.heading3(context).copyWith(color: Colors.redAccent),),
                                  loading: () => Column(
                                    children: [
                                      ShimmerLoader(height: 5.h, width: 40.w),
                                      SizedBox(height: 5.h,),
                                      ShimmerLoader(height: 10.h, width: 20.w),
                                    ],
                                  )),
                              const VerticalDivider(
                                color: Colors.black38,
                                thickness: 1,
                              ),
                              ref.watch(filteredTargetsProvider).when(data: (data){
                                return RichText(
                                  text: TextSpan(
                                      text: 'Customers\n',
                                      style: Styles.heading4(context),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: data.achievedLeadsTarget,
                                            style: Styles.normalText(context)
                                                .copyWith(
                                                color: Colors.black54,
                                                fontSize:
                                                Responsive.isMobile(context)
                                                    ? 10.sp
                                                    : 8.sp,
                                                fontWeight: FontWeight.w700))
                                      ]),
                                );
                              },
                                  error: (error, stackTrace) => Text("Error", style: Styles.heading3(context).copyWith(color: Colors.redAccent),),
                                  loading: () => Column(
                                    children: [
                                      ShimmerLoader(height: 5.h, width: 40.w),
                                      SizedBox(height: 5.h,),
                                      ShimmerLoader(height: 10.h, width: 20.w),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      )),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height *.4,
                  decoration: BoxDecoration(
                      color: Styles.appSecondaryColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap:(){
                          Get.toNamed(RouteHelper.Notifications());
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: ListTile(
                              leading: Icon(Icons.notification_important, color: Styles.appPrimaryColor,),
                              trailing: Icon(Icons.arrow_forward_ios, color:Colors.grey,),
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Notifications", style: Styles.heading3(context),),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Get.toNamed(RouteHelper.getCustomers(), arguments: {"user_filtered": false});
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: ListTile(
                              leading: Icon(Icons.people, color: Styles.appPrimaryColor,),
                              trailing: Icon(Icons.arrow_forward_ios, color:Colors.grey,),
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("My Customers", style: Styles.heading3(context),),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: ()async{
                          try{
                            showDialog(context: context, builder: (context){
                              return Container(
                                color: Colors.black38,
                                height: MediaQuery.of(context).size.height,
                                child: Center(child: CircularProgressIndicator()),
                              );
                            });
                            await ref.read(dataSyncRepositoryProvider).syncData();
                            Get.back();
                          }catch(e){
                            Get.back();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: ListTile(
                              leading: Icon(Icons.sync, color: Styles.appPrimaryColor,),
                              trailing: Icon(Icons.arrow_forward_ios, color:Colors.grey,),
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Sync Data", style: Styles.heading3(context),),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Get.to(ForgotPasswordPage(screenName: "Reset Password",));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: ListTile(
                              leading: Icon(Icons.lock, color: Styles.appPrimaryColor,),
                              trailing: Icon(Icons.arrow_forward_ios, color:Colors.grey,),
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Reset Password", style: Styles.heading3(context),),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),

                      // RichText(
                      //   text: TextSpan(
                      //     children: <TextSpan>[
                      //       TextSpan(
                      //         text: 'Terms and conditions apply.  ',
                      //         style: TextStyle(color: Colors.white),
                      //       ),
                      //       TextSpan(
                      //         text: 'Privacy Policy',
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //           decoration: TextDecoration.underline,
                      //         ),
                      //         recognizer: TapGestureRecognizer()
                      //           ..onTap = launchPrivacyPolicy,
                      //       ),
                      //     ],
                      //   ),
                      // ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),



            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   tooltip: 'Sync Data',
      //   backgroundColor: Styles.appPrimaryColor,
      //   splashColor: Theme.of(context).splashColor,
      //   onPressed: () {},
      //   child: Icon(
      //     Icons.sync,
      //     size: Responsive.isMobile(context)
      //         ? defaultPadding(context) * 2.1
      //         : defaultPadding(context) * 2.4,
      //     color: Styles.appBackgroundColor,
      //   ),
      // ),
    );
  }
}
