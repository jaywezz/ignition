import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/auth/otp_confirm_page.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';

class OtPPage extends StatefulWidget {
  final String phone;
  const OtPPage({Key? key, required this.phone}) : super(key: key);

  @override
  _OtPPageState createState() => _OtPPageState();
}

class _OtPPageState extends State<OtPPage> {
  static final GlobalKey<FormState> og2lobalKey = GlobalKey<FormState>();
  var otpController = TextEditingController();
  void _confirmOtp() {
    var authController = Get.find<AuthController>();

    String otp = otpController.text.trim();

    if (otp.isEmpty) {
      showCustomSnackBar("OTP is required");
    } else if (otp.length < 4) {
      showCustomSnackBar("Type a valid Otp");
    } else {
      authController.verifyOtp(widget.phone, otp).then((status) {
        if (status.isSuccess) {
          print("Success Login");
          showCustomSnackBar(status.message, isError: false);

          Get.to(() => OtPConfirmPage(
                phone: widget.phone,
              ));
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }

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
          child: Form(
            key: og2lobalKey,
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
                        "Enter 4 Digit Pin",
                        style: Styles.heading1(context),
                      ),
                      SizedBox(height: defaultPadding(context) * 3),
                      Text(
                        """The recovery code was sent to your
                 phone number.""",
                        style: Styles.normalText(context),
                      ),
                      Text(
                        "Please enter the code",
                        style: Styles.normalText(context),
                      ),
                      SizedBox(height: defaultPadding(context) * 3),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding(context)),
                        child: PinCodeTextField(
                          appContext: (context),
                          keyboardType: TextInputType.number,
                          pinTheme: PinTheme.defaults(
                            inactiveColor: Styles.defaultInputFieldColor,
                            activeColor: Styles.defaultInputFieldColor,
                            selectedFillColor: Styles.defaultInputFieldColor,
                            selectedColor: Styles.darkGrey,
                          ),
                          length: 6,
                          animationDuration: const Duration(milliseconds: 300),
                          errorAnimationController: null,
                          controller: otpController,
                          onCompleted: (v) {
                            print("Completed");
                          },
                          onChanged: (value) {
                            print(value);
                          },
                          beforeTextPaste: (text) {
                            print('Allowing to paste $text');
                            return true;
                          },
                        ),
                      ),
                      SizedBox(height: defaultPadding(context) * 3),
                      FullWidthButton(
                        action: () {
                          _confirmOtp();
                        },
                        text: "Verify",
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
      ),
    );
  }
}
