import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/product_category_controller.dart';
import 'package:soko_flow/views/auth/phone_login_screen.dart';

import 'package:soko_flow/views/deliveries/deliveries_screen.dart.bak';
import 'package:soko_flow/views/help/help.dart';
import 'package:soko_flow/views/home/home_screen.dart';
import 'package:soko_flow/views/inventory/inventory_screen.dart';
import 'package:soko_flow/views/product_catalogue/product_catalogue.dart';
import 'package:soko_flow/views/routeSchedule/route_schedule.dart';
import 'package:soko_flow/views/routeSchedule/route_schedule2.dart';
import 'package:soko_flow/widgets/poweredby_widget.dart';

import 'controllers/auth_controller.dart';
import 'controllers/product_controller.dart';
import 'logic/routes/routes.dart';
import 'routes/route_helper.dart';
import 'utils/app_constants.dart';
import 'views/chat/screens/chat_screen.dart';

Logger _log = Logger(printer: PrettyPrinter());

class MainDrawer extends StatefulWidget {
  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  // bool isParent = AuthService.instance.isParent;

  String userEmail = '';
  String userName = '';
  String userPhone = '';

  @override
  void initState() {
    super.initState();
    getData();
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

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    // Get.lazyPut(() => ProductController(productRepo: Get.find()));
    // Get.lazyPut(
    //     () => ProductCategoryController(productCategoryRepo: Get.find()));
    // Get.find<ProductCategoryController>().getProductCategories();
    // Get.find<ProductController>().getProducts();
    return FutureBuilder(
        future: getData(),
        builder: (builder, snapshot) {
          // _log.e("User name is : " + userName,);
          // =======================
          return Drawer(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/logo/bg.png'),
                      fit: BoxFit.cover)),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: defaultPadding(context) * 3,
                        ),
                        Center(
                          child: CircleAvatar(
                            backgroundImage:
                            Image.asset("assets/logo/playstore.png").image,
                            maxRadius: defaultPadding(context) * 3,
                            //SizeConfig.safeBlockHorizontal * 10,
                            minRadius: defaultPadding(context) * 3,
                            // SizeConfig.safeBlockHorizontal * 10,
                          ),
                        ),
                        SizedBox(
                          height: defaultPadding(context) * .6,
                        ),
                        Text(
                          userName != null ? '${userName}' : 'Mchagua Jembe',
                          style: Styles.heading2(context)
                              .copyWith(color: Colors.black87),
                        ),
                        SizedBox(
                          height: defaultPadding(context) * .5,
                        ),
                        Text(
                          userPhone != null ? '${userPhone}' : '0723 456789',
                          style: Styles.normalText(context),
                        ),
                        SizedBox(
                          height: defaultPadding(context) * .2,
                        ),
                        Text(
                          userEmail != null
                              ? '${userEmail}'
                              : 'mchaguajembe@gmail.com',
                          style: Styles.normalText(context),
                        ),
                        SizedBox(
                          height: defaultPadding(context) * .8,
                        ),
                        Material(
                          color: Styles.appSecondaryColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(defaultPadding(context) * 1.5)),
                          child: InkWell(
                            splashColor: Theme.of(context).splashColor,
                            onTap: () {
                              Get.toNamed(RouteHelper.ProfileScreen());
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: defaultPadding(context) * .4,
                                  horizontal: defaultPadding(context) * 2),
                              child: Text(
                                'View Profile',
                                style: Styles.bttxt2(context),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: defaultPadding(context),
                        ),
                        DrawerItem(
                          icon: Icons.home,
                          text: "Home",
                          action: () {
                            //Navigate.instance.toRoute(PaymentScreen());

                            // Get.to(VanSales());
                            Get.toNamed(RouteHelper.getInitial());

                            // Navigate.instance.toRoute(HomeScreen());
                          },
                        ),
                        DrawerItem(
                          icon: Icons.people,
                          text: "Customers",
                          action: () {
                            Get.toNamed(RouteHelper.getCustomers(), arguments: {"user_filtered": false});
                          },
                        ),
                        DrawerItem(
                          icon: Icons.room_outlined,
                          text: "Route Schedule",
                          action: () {
                            Get.to(RouteSchedule2());
                            //AuthService.instance.setupKids();
                            // Navigate.instance.toRemove('/selectuser');
                          },
                        ),
                        DrawerItem(
                          action: () async {
                            // await Get.find<ProductController>().getProducts();
                            Get.to(InventoryScreen());
                          },
                          icon: Icons.event_note_outlined,
                          text: "My Inventory",
                        ),
                        DrawerItem(
                          icon: Icons.local_parking_rounded,
                          text: "Product Catalogue",
                          action: () {
                            Get.toNamed(RouteHelper.ProductCatalogue());
                          },
                        ),
                        DrawerItem(
                          action: () {
                            Get.toNamed(RouteHelper.UserDeliveries());
                          },
                          icon: Icons.directions_bus_filled_outlined,
                          text: "Deliveries",
                        ),
                        DrawerItem(
                          action: () {
                            Get.toNamed(RouteHelper.reports());
                          },
                          icon: Icons.receipt_outlined,
                          text: "Reports",
                        ),
                        // DrawerItem(
                        //   action: () {
                        //     Get.to(ChatScreen());
                        //   },
                        //   icon: Icons.chat,
                        //   text: "Chat",
                        // ),
                        // DrawerItem(
                        //   action: () {
                        //     Get.to(HelpScreen());
                        //   },
                        //   icon: Icons.help,
                        //   text: "Help",
                        // ),
                        DrawerItem(
                          icon: Icons.logout_outlined,
                          text: "Logout",
                          action: () {
                            Get.find<AuthController>().clearSharedData();

                            // Get.offNamed(RouteHelper.getLogin());
                            Get.off(PhoneLoginScreen());
                            Fluttertoast.showToast(msg: "Logout Successful");
                          },
                        ),
                        SizedBox(
                          height: defaultPadding(context),
                        ),
                      ],
                    ),

                    const Positioned(
                      bottom: -35,
                      left: 50,
                      child: PoweredByWidget(),
                    )
                  ],
                ),
              ),
            ),
            // ============================
          );
          // ====================
        });
  }
}

// class DrawerItem extends StatelessWidget {
//   var icon;
//   var text;
//   var action;

//   DrawerItem({this.icon, this.text, this.action});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       splashColor: Theme.of(context).splashColor,
//       child: Column(
//         children: [
//           Divider(
//             thickness: 0.5,
//             color: Colors.grey,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(
//                 vertical: SizeConfig.blockSizeVertical * 1,
//                 horizontal: SizeConfig.safeBlockHorizontal * 3),
//             child: Row(
//               children: [
//                 Icon(
//                   icon,
//                   size: SizeConfig.safeBlockHorizontal * 5,
//                   color: Styles.appPrimaryColor,
//                 ),
//                 SizedBox(
//                   width: SizeConfig.safeBlockHorizontal * 4,
//                 ),
//                 Text(
//                   text,
//                   style: TextStyle(
//                       color: Styles.darkGrey,
//                       fontSize: SizeConfig.safeBlockHorizontal * 4.5,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//       onTap: () => action(),
//     );
//   }
// }

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback action;
  const DrawerItem(
      {Key? key, required this.icon, required this.action, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: defaultPadding(context),
      //SizeConfig.safeBlockHorizontal * 4,
      onTap: () {
        action();
      },
      leading: Icon(
        icon,
        size: defaultPadding(context) * 1.7,
        color: Styles.appSecondaryColor,
      ),
      title: Text(
        text,
        style: Styles.heading3(context).copyWith(color: Colors.black54),
      ),
    );
  }
}


//funlympics--otdoor activities