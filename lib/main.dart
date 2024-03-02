import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/models/company_outlets/company_outlets_model.dart';
import 'package:soko_flow/models/company_outlets/customer_groups.dart';
import 'package:soko_flow/models/company_routes/company_routes_model.dart';
import 'package:soko_flow/models/customer_model/customer_model.dart';
import 'package:soko_flow/models/productsModel/products_model.dart';
import 'package:soko_flow/models/route_schedule_model.dart';
import 'firebase_options.dart';
import 'helper/dependencies.dart' as dep;
import 'my_app.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("_firebaseMessagingBackgroundHandler: $message");
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await dep.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Hive
    ..registerAdapter(SubregionAdapter())
    ..registerAdapter(RegionalRoutesAdapter())
    ..registerAdapter(ProductsModelAdapter())
    ..registerAdapter(UserRouteModelAdapter())
    ..registerAdapter(CustomerDataModelAdapter())
    ..registerAdapter(CustomerGroupModelAdapter())
    ..registerAdapter(CompanyOutletsModelAdapter());
  FirebaseMessaging.instance.getToken().then(
        (value) => print('getToken : $value'),
      );

  //if application is in background, then it will work
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("onMessageOpenedApp: $message");
    Navigator.pushNamed(navigatorKey.currentState!.context, '/push-page',
        arguments: {
          'message': json.encode(message.data),
        });
  });
// if app is closed or terminated
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print("getInitialMessage: $message");
      Navigator.pushNamed(navigatorKey.currentState!.context, '/push-page',
          arguments: {
            'message': json.encode(message.data),
          });
    }
  });

  //if app is in fore3ground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    toast(
      message.notification!.body!,
      context: navigatorKey.currentState!.context,
    );

    showSimpleNotification(Text(message.notification!.title!),
        leading: CircleAvatar(
          radius: 20,
          child: Image.asset("assets/logo/Fav.png"),
        ),
        subtitle: Text(message.notification!.body!),
        background: Styles.appPrimaryColor,
        duration: const Duration(seconds: 5),
        trailing: IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/icons/reply.svg",
              color: Styles.appBackgroundColor,
            )));
    print("getForegroundMessage: ${message.notification}");
    // ScaffoldMessenger.of(navigatorKey.currentState!.context)
    //     .showSnackBar(SnackBar(content: Text(message.notification!.title!)));
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}
