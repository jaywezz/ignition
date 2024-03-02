import 'dart:async';

import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:soko_flow/data/providers/client_provider.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/services/auth_service.dart';
import 'package:soko_flow/update_app_screen.dart';
import 'package:soko_flow/widgets/poweredby_widget.dart';

import 'controllers/auth_controller.dart';

Logger _log = Logger(
  printer: PrettyPrinter(),
);

class SplashScreenPage extends ConsumerStatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SplashScreenPageState();
}

class SplashScreenPageState extends ConsumerState<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    //Get.find<ProductCategoryController>().getProductCategories();
    _loadResource();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    _checkUser();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/logo/bg.png'), fit: BoxFit.cover),
              ),
              child: Center(
                  child: Image(
                image: AssetImage(
                  'assets/logo/playstore.png',
                ),
                height: MediaQuery.of(context).size.width * .7,
              ))),
          Positioned(bottom: -1, left: 120, child: PoweredByWidget())
        ],
      ),
    );
  }

  var storage = const FlutterSecureStorage();

  void _checkUser() async{
    Future.delayed(const Duration(seconds: 3), () async {
      _log.i("Is user logged in :" +
          Get.find<AuthController>().userLoggedIn().toString());
      if (Get.find<AuthController>().userLoggedIn()) {
        //Get.find<UserController>().getUserInfo();
        AuthService.instance.load();
        Get.offNamed(RouteHelper.getInitial(),
        );
      } else {
        Get.offNamed(
          RouteHelper.getLogin(),
        );
      }
    });
    // if(await getCurrentAppVersion()){
    //
    // }
  }

  Future<void> _loadResource() async {
    Get.find<AuthController>().userLoggedIn();
  }
  Future<bool> getCurrentAppVersion()async{
    print("checking version");
    try{
      d.Response response = await ref.watch(clientProvider).get("/app-versions");
      print("after version check: ${response.data}");
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      print("app version checking: ${response.data[0]["version_code"]}");
      // if(response.data[0]["version_code"] != "2.0.5"){
      if(response.data[0]["version_code"] != packageInfo.version){
        Get.off(UpdateAppScreen(appVersion: response.data[0]["version_code"]));
        return false;
      }else{
        return true;
      }
    }catch(e,s){
      print("err:$s");
      return true;
    }
  }
}
