import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:soko_flow/main.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/views/customers/geofencing_example.dart';
import 'package:upgrader/upgrader.dart';

import 'controllers/customer_provider.dart';
import 'controllers/product_by_id_Controller.dart';

Logger _log = Logger(
  printer: PrettyPrinter(),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    _log.i("MyApp has started");
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        splitScreenMode: true,
        builder: (context, child) {
          return OverlaySupport.global(
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Soko Flow',
              navigatorKey: navigatorKey,
              theme: ThemeData(useMaterial3: false,
                textTheme: GoogleFonts.poppinsTextTheme(),
              ),
              initialRoute: RouteHelper.getSplashPage(),
              getPages: RouteHelper.routes,
              // navigatorKey: Navigate.instance.navigationKey,
            ),
          );
        });
  }
}
