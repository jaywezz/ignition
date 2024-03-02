import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/buttons/full_width_button.dart';


class UpdateAppScreen extends StatefulWidget {
  static const routeName = '/sign-in';
  final String appVersion;
  const UpdateAppScreen({Key? key, required this.appVersion}) : super(key: key);

  @override
  State<UpdateAppScreen> createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {

  String version = "";
  getAppVersion()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      version = packageInfo.version;
    });
    print("app version: $version");
  }
  @override
  void initState() {
    getAppVersion();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [

            Center(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .2,),
                  Center(child: Lottie.asset('assets/lottie/update.json', height: 200.h, width: 200.w)),
                  SizedBox(height: 20.h,),
                  Center(child: Text("App Version $version is out of Date", style: Styles.heading4(context),)),
                  SizedBox(height: 10.h,),
                  Center(child: Text("Update to version ${widget.appVersion}", style: Styles.heading3(context).copyWith(color: Colors.grey[700]),)),
                  SizedBox(height: 30.h,),
                  Padding(
                    padding:  EdgeInsets.all(30.0.sp),
                    child: FullWidthButton(
                      height: 40,
                      text: "Update from PlayStore",
                      action: ()async{
                        if (Platform.isAndroid || Platform.isIOS) {
                          final appId = "com.sokoflow.kenmeat";
                          final url = Uri.parse(
                            Platform.isAndroid
                                ? "market://details?id=$appId"
                                : "https://apps.apple.com/app/id$appId",
                          );
                          launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },

                    ),
                  )

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
