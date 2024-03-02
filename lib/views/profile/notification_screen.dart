import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soko_flow/configs/constants.dart';

import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/logic/routes/routes.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/size_utils.dart';

import '../../routes/route_helper.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        //color: Styles.appBackgroundColor,
        child: Container(
          padding: EdgeInsets.only(
              top: defaultPadding(context) * 3,
              left: defaultPadding(context),
              right: defaultPadding(context),
              bottom: defaultPadding(context)),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))),
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
                      onTap: () => Get.back(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Styles.darkGrey,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Notifications',
                      style: Styles.heading2(context),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Material(
                      child: InkWell(
                        splashColor: Theme.of(context).splashColor,
                        onTap: () => Get.toNamed(RouteHelper.getInitial()),
                        child: Icon(
                          Icons.home_sharp,
                          size: defaultPadding(context) * 2,
                          color: Styles.appPrimaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
