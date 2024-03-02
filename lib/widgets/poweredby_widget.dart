import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:soko_flow/configs/styles.dart';

class PoweredByWidget extends StatefulWidget {
  const PoweredByWidget({Key? key}) : super(key: key);

  @override
  State<PoweredByWidget> createState() => _PoweredByWidgetState();
}

class _PoweredByWidgetState extends State<PoweredByWidget> {
  String appName = "";
  String packageName = "";
  String version = "";
  String buildNumber = "";
  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
    print("app version: $version");
  }

  @override
  void initState() {
    // TODO: implement initState
    getAppVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            "Powered by: ",
            style: Styles.heading4(context).copyWith(color: Colors.grey[500]),
          ),
          Image.asset(
            "assets/logo/main-logo1.png",
            width: MediaQuery.of(context).size.width * .16,
          ),
          Text(
            "V$version",
            style: Styles.heading4(context).copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
