import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/auth_controller.dart';
import 'package:soko_flow/data/providers/auth/auth_provider.dart';
import 'package:soko_flow/views/auth/forgot_password_page.dart';
import 'package:soko_flow/views/auth/otp_mobile_number.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:soko_flow/widgets/inputs/default_text_field.dart';
import 'package:soko_flow/widgets/poweredby_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../base/show_custom_snackbar.dart';
import '../../routes/route_helper.dart';
import 'auth_base.dart';

Logger _log = Logger(printer: PrettyPrinter());

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool hidePasswords = true;
  bool rememberMe = false;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void _login() async{
    var authController = Get.find<AuthController>();

    String email = emailController.text.trim();

    String password = passwordController.text.trim();
    if (email.isEmpty) {
      showCustomSnackBar("Type your Phone number");
    } else if (!GetUtils.isPhoneNumber(email)) {
      showCustomSnackBar("Type a valid phone number");
    } else if (password.isEmpty) {
      showCustomSnackBar("Type your password");
    } else if (password.length < 6) {
      showCustomSnackBar("Password must be at least 6 characters");
    } else {
      try{
     await ref.read(authNotifier.notifier).userLogin(email, password);
     // authController.login(email, password).then((status) {
     //      if (status.isSuccess) {
     //        _log.i("Success Login");
     //        showCustomSnackBar(status.message, isError: false);
     //        // authController.saveUserNumberAndPassword(phone, password);
     //        Get.toNamed(RouteHelper.getInitial());
     //      } else {
     //        showCustomSnackBar(status.message);
     //      }
     //    });
      }catch(e){
        setState(() {
        });
      }
    }
  }

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);
    return Scaffold(
      body: GetBuilder<AuthController>(builder: (authController) {
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/logo/bg.png'), fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              AuthBase(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome!",
                        style: Styles.heading1(context),
                      ),
                      SizedBox(height: defaultPadding(context) * 1.3),
                      Text(
                        """Stay signed in with your account to
                       make work easier""",
                        style: Styles.normalText(context),
                      ),
                      SizedBox(height: defaultPadding(context) * 4),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phone Number',
                            style: Styles.normalText(context)
                                .copyWith(color: Colors.black),
                          ),
                          DefaultInputField(
                            controller: emailController,
                            hide: false,
                            inputtype: true,
                            hintText: "Enter your phone number",

                            // prefix: Icon(
                            //   Icons.phone,
                            //   color: Colors.grey,
                            // ),
                          ),
                        ],
                      ),

                      SizedBox(height: defaultPadding(context) * 2),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password',
                            style: Styles.normalText(context)
                                .copyWith(color: Colors.black),
                          ),
                          DefaultInputField(
                            //labelText: 'Password',
                            controller: passwordController,
                            hintText: "Enter your password",
                            password: true,
                            hide: hidePasswords,

                            // prefix: const Icon(
                            //   Icons.lock,
                            //   color: Colors.grey,
                            // ),
                            toggleHide: () {
                              setState(() {
                                hidePasswords = !hidePasswords;
                              });
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: defaultPadding(context) * 1.2),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        color: rememberMe
                                            ? Styles.appSecondaryColor
                                            : Colors.white,
                                        border: Border.all(
                                          color: Styles.defaultInputFieldColor,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(defaultRadius1 - 6)),
                                    margin: const EdgeInsets.only(left: 10),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      rememberMe = !rememberMe;
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: defaultPadding(context) * 0.7,
                                ),
                                const Text("Keep me signed in")
                              ],
                            ),

                            GestureDetector(
                              child: Text(
                                "Forgot Password?",
                                style: Styles.normalText(context)
                                    .copyWith(color: Styles.appSecondaryColor),
                              ),
                              onTap: () {
                                Get.to(() => PhoneOtPPage());
                              },
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: defaultPadding(context) * 3),

                      ref.watch(authNotifier).isLoading
                          ? Center(
                              child: Platform.isAndroid
                                  ? CircularProgressIndicator(
                                      color: Styles.appPrimaryColor)
                                  : CupertinoActivityIndicator())
                          : FullWidthButton(
                              text: "Sign In",
                              action: () {
                                _login();
                              },
                            ),
                      SizedBox(height: 10,),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Terms and conditions apply.  ',
                              style: TextStyle(color: Colors.black54),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = launchPrivacyPolicy,
                            ),
                          ],
                        ),
                      ),

                      // SizedBox(height: defaultPadding(context) * 0.3),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     const Expanded(
                      //         child: Divider(
                      //       thickness: 2,
                      //     )),
                      //     SizedBox(width: defaultPadding(context) * 0.4),
                      //     Text(
                      //       "Or",
                      //       style: Styles.normalText.copyWith(color: Colors.grey),
                      //     ),
                      //     SizedBox(width: defaultPadding(context) * 0.4),
                      //     const Expanded(
                      //         child: Divider(
                      //       thickness: 2,
                      //     )),
                      //   ],
                      // ),
                      // SizedBox(height: defaultPadding(context) * 0.3),
                      // SignInWithGoogleButton(action: () {
                      //   Navigate.instance.to('/home');
                      // }
                      // )
                    ],
                  ),
                  // Container(
                  //   child: Column(
                  //     children: [
                  //       SizedBox(
                  //         height: defaultPadding(context) * 2,
                  //       ),
                  //       RichText(
                  //           text: TextSpan(
                  //               text: "Don't have an account ? ",
                  //               style: Styles.normalText,
                  //               children: [
                  //             TextSpan(
                  //               text: "Sign Up",
                  //               style: const TextStyle(fontWeight: FontWeight.bold),
                  //               recognizer: TapGestureRecognizer()
                  //                 ..onTap = () {
                  //                   Navigate.instance.toRemove('/signUp');
                  //                 },
                  //             )
                  //           ]))
                  //     ],
                  //   ),
                  //   width: double.infinity - (defaultPadding(context) * 2),
                  //   padding: EdgeInsets.symmetric(horizontal: defaultPadding(context) * 2),
                  // )
                ],
              ),
              WidgetsBinding.instance.window.viewInsets.bottom > 0.0?const SizedBox():const Positioned(
                  bottom: -1,
                  left: 120,
                  child: PoweredByWidget())

            ],
          ),
        );
      }),
    );
  }
}


launchPrivacyPolicy() async {
  final Uri _url = Uri.parse("https://sidai.sokoflow.com/privacy-policy");
  await launchUrl(_url);

}
