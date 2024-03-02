import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/auth/otp_confirm_page.dart';
import 'package:soko_flow/views/auth/otp_page.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/inputs/default_text_field.dart';

class PhoneOtPPage extends StatefulWidget {
  const PhoneOtPPage({Key? key}) : super(key: key);

  @override
  _PhoneOtPPageState createState() => _PhoneOtPPageState();
}

class _PhoneOtPPageState extends State<PhoneOtPPage> {
  static final GlobalKey<FormState> pglobalKey = GlobalKey<FormState>();
  var phoneController = TextEditingController();

  void _sendOtp() {
    var authController = Get.find<AuthController>();

    String phone = phoneController.text.trim();

    if (phone.isEmpty) {
      showCustomSnackBar("Phone number is required");
    } else if (!GetUtils.isPhoneNumber(phone)) {
      showCustomSnackBar("Type a valid phone number");
    } else {
      authController.sendOtp(phone).then((status) {
        if (status.isOk) {
          print("Success Login");
          showCustomSnackBar("OTP sent", isError: false);
          // authController.saveUserNumberAndPassword(phone, password);
          Get.to(() => OtPPage(phone: phone), arguments: {
            "phone": status.body["data"]["phone_number"]
          });
        } else {
          showCustomSnackBar(status.body["message"]!);
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.authBackgroundColor,
      body: GetBuilder<AuthController>(builder: (fController) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
            ),
            child: Form(
              key: pglobalKey,
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
                          color: Styles.appPrimaryColor,
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
                          "Enter Your Phone Number",
                          style: Styles.heading1(context),
                        ),
                        SizedBox(height: defaultPadding(context) * 3),
                        Text(
                          """Yo will receive OTP message of the mobile number you input here.""",
                          style: Styles.normalText(context),
                        ),
                        Text(
                          "Please enter the Phone Number",
                          style: Styles.normalText(context),
                        ),
                        SizedBox(height: defaultPadding(context) * 3),
                        DefaultInputField(
                          controller: phoneController,
                          hintText: "Enter Phone Number",
                          inputtype: true,
                          hide: false,
                          prefix: Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Phone number is required";
                            } else if (!GetUtils.isPhoneNumber(value)) {
                              return "Type a valid phone number";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: defaultPadding(context) * 3),
                        FullWidthButton(
                          action: () {
                            _sendOtp();
                            // Get.to(() => OtPPage(
                            //       phone: phoneController.text,
                            //     ));
                          },
                          text: fController.isLoading
                              ? "Sending Otp...."
                              : "Send OTP",
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(defaultPadding(context)),
                    width: double.infinity,
                  ),
                ],
              ),
            ),
            padding: Responsive.isMobile(context) &&
                    Responsive.isMobileLarge(context)
                ? EdgeInsets.symmetric(horizontal: defaultPadding(context))
                : EdgeInsets.symmetric(horizontal: defaultPadding(context) * 6),
          ),
        );
      }),
    );
  }
}
