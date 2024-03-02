import 'package:flutter/material.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/utils/size_utils.dart';
import 'package:soko_flow/utils/size_utils2.dart';

class AuthBase extends StatelessWidget {
  final List<Widget> children;
  const AuthBase({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      child: ListView(
        children: [
          Padding(
            child: Column(
              children: [
                SizedBox(
                    height: defaultPadding(context) *
                        (Responsive.isMobile(context) &&
                            Responsive.isMobileLarge(context)
                            ? 3
                            : 2.5)),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding(context) * 2),
                  child: Image.asset("assets/logo/playstore.png",height: MediaQuery.of(context).size.width * .3, width: MediaQuery.of(context).size.width * .3,),
                ),
                SizedBox(
                  height: defaultPadding(context) *
                      (Responsive.isTall(context) ? 4.2 : 3),
                ),
                ...(children[0] as Column).children,
                SizedBox(
                  height: defaultPadding(context) *
                      (Responsive.isTall(context) ? 1 : 0.5
                          //SizeConfig.isTall ? 1 : 0.5
                      ),
                ),
              ],
            ),
            padding: Responsive.isMobile(context) &&
                Responsive.isMobileLarge(context)
                ? EdgeInsets.symmetric(horizontal: defaultPadding(context))
                : EdgeInsets.symmetric(
                horizontal: defaultPadding(context) * 6),
          ),
          //SizedBox(height: defaultPadding(context)),
          //children[1]
        ],
      ),
    );
  }
}
