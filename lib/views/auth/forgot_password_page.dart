import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/auth_controller.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/app_constants.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/auth/otp_confirm_page.dart';
import 'package:soko_flow/views/auth/otp_mobile_number.dart';
import 'package:soko_flow/views/auth/otp_page.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String? screenName;
  const ForgotPasswordPage({Key? key, this.screenName}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool _value = false;
  int val = -1;
  setlectedValue(value) {
    setState(() {
      val = value;
    });
  }
  bool isLoading = false;

  void _sendOtp()async {
    var authController = Get.find<AuthController>();
    String phone = phoneNumber;

    if (phone.isEmpty) {
      showCustomSnackBar("Phone number is required");
    } else if (!GetUtils.isPhoneNumber(phone)) {
      showCustomSnackBar("Type a valid phone number");
    } else {
      setState(() {
        isLoading = true;
      });
      await authController.sendOtp(phone).then((status) {
        if (status.isOk) {
          showCustomSnackBar("OTP sent", isError: false);
          // authController.saveUserNumberAndPassword(phone, password);
          Get.to(() => OtPPage(phone: phone), arguments: {
            "phone": status.body["data"][0]["phone_number"]
          });
        } else {
          showCustomSnackBar(status.statusText!);
        }
        setState(() {
          isLoading = false;
        });
      });
    }
    setState(() {
      isLoading = false;
    });
  }


  Future getData() async {
    var prefs = await SharedPreferences.getInstance();
    phoneNumber = (await prefs.getString(AppConstants.PHONE_NUMBER))!;
    email = (await prefs.getString(AppConstants.EMAIL))!;
    setState(() {});
  }
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  String phoneNumber = "";
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.authBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              SizedBox(height: defaultPadding(context) * 3),
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Styles.appSecondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Styles.appBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(
                        height: defaultPadding(context) *
                            (Responsive.isTall(context) ? 3 : 3.5)),
                    Text(
                      widget.screenName== null?"Forgot Password":widget.screenName!,
                      style: Styles.heading1(context),
                    ),
                    SizedBox(height: defaultPadding(context) * 3),
                    Text(
                      "Select which contact details to use",
                      style: Styles.normalText(context),
                    ),
                    Text(
                      "for password resetting",
                      style: Styles.normalText(context),
                    ),
                    SizedBox(height: defaultPadding(context) * 3),
                    ListTile(
                      title: Text(
                        'Via SMS',
                        style: Styles.heading4(context),
                      ),
                      subtitle: Text(
                        '${phoneNumber}',
                        style: Styles.normalText(context),
                      ),
                      leading: Icon(
                        Icons.phone_android_outlined,
                        color: Colors.black,
                        size: defaultPadding(context) * 2,
                      ),
                      trailing: Radio(
                        value: 1,
                        groupValue: val,
                        onChanged: setlectedValue,
                        activeColor: Styles.appPrimaryColor,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Email',
                        style: Styles.heading4(context),
                      ),
                      subtitle: Text(
                        '$email',
                        style: Styles.normalText(context),
                      ),
                      leading: Icon(
                        Icons.email_outlined,
                        color: Colors.black,
                        size: defaultPadding(context) * 2,
                      ),
                      trailing: Radio(
                        value: 2,
                        groupValue: val,
                        onChanged: setlectedValue,
                        activeColor: Styles.appPrimaryColor,
                      ),
                    ),
                    SizedBox(height: defaultPadding(context) * 7),
                    isLoading?Center(child: CircularProgressIndicator()):FullWidthButton(
                      action: ()async {
                        if (val == 1) {
                          _sendOtp();
                        } else {
                          null;
                        }
                      },
                      text: "Proceed",
                    )
                  ],
                ),
                padding: EdgeInsets.all(defaultPadding(context)),
                width: double.infinity,
              ),
            ],
          ),
          padding: Responsive.isMobile(context) &&
              Responsive.isMobileLarge(context)
              ? EdgeInsets.symmetric(horizontal: defaultPadding(context))
              : EdgeInsets.symmetric(horizontal: defaultPadding(context) * 6),
        ),
      ),
    );
  }
}
