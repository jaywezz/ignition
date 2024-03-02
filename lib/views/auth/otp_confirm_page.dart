import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/inputs/default_text_field.dart';
import 'login_page.dart';

class OtPConfirmPage extends StatefulWidget {
  OtPConfirmPage({Key? key, required this.phone}) : super(key: key);
  final String phone;

  @override
  _OtPConfirmPageState createState() => _OtPConfirmPageState();
}

class _OtPConfirmPageState extends State<OtPConfirmPage> {
  static final GlobalKey<FormState> changepassKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();
  var passwordConfirmController = TextEditingController();
  void _changePassword() {
    var authController = Get.find<AuthController>();

    String password = passwordController.text.trim();
    String passwordConfirm = passwordConfirmController.text.trim();

    if (password.isEmpty) {
      showCustomSnackBar("Password is required");
    } else if (password.length < 6) {
      showCustomSnackBar("Type a valid Password");
    } else if (password != passwordConfirm) {
      showCustomSnackBar("Password does not match");
    } else {
      authController
          .resetPassword(widget.phone, password, passwordConfirm)
          .then((status) {
        if (status.isSuccess) {
          showCustomSnackBar(status.message, isError: false);

          Get.offNamed(RouteHelper.getLogin());
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
        child: GetBuilder<AuthController>(builder: (passController) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  child: Form(
                    key: changepassKey,
                    child: Column(
                      children: [
                        SizedBox(
                            height: defaultPadding(context) *
                                (Responsive.isTall(context) ? 3 : 3.5)),
                        Text(
                          "Enter Your new Password",
                          style: Styles.heading1(context),
                        ),
                        SizedBox(height: defaultPadding(context) * 3),
                        DefaultInputField(
                          controller: passwordController,
                          hintText: "Enter Password",
                          password: true,
                          hide: true,
                          prefix: Icon(
                            Icons.lock_outlined,
                            color: Colors.grey,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Password is required";
                            } else if (value < 6) {
                              return "Type a valid password";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: defaultPadding(context) * 3),
                        DefaultInputField(
                          controller: passwordConfirmController,
                          hintText: "Confirm Password",
                          password: true,
                          prefix: Icon(
                            Icons.lock_outlined,
                            color: Colors.grey,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Confirm password is required";
                            } else if (value != passwordController.text) {
                              return "Password mismatch";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: defaultPadding(context) * 3),
                        FullWidthButton(
                          action: () {
                            _changePassword();
                            // Get.to(() => OtPPage(
                            //       phone: phoneController.text,
                            //     ));
                          },
                          text: passController.isLoading
                              ? "Confirm...."
                              : "Confirm",
                        )
                      ],
                    ),
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
          );
        }),
      ),
    );
  }
}
