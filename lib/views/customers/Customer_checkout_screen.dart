import 'package:flutter/material.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/logic/routes/routes.dart';
import 'package:soko_flow/widgets/cards/order_summary_card.dart';
import 'package:get/get.dart';
import '../../routes/route_helper.dart';
import '../../widgets/buttons/full_width_button.dart';
import '../inventory/inventory_detailed_screens/components/product_summary_list.dart';

class CustomerCheckoutPage extends StatelessWidget {
  const CustomerCheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.only(
              left: defaultPadding(context),
              right: defaultPadding(context),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: defaultPadding(context),
                ),
                Stack(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Theme.of(context).splashColor,
                        onTap: () {
                          return Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Styles.darkGrey,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Order Summary",
                        style: Styles.heading2(context),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Theme.of(context).splashColor,
                          onTap: () {
                            Get.toNamed(RouteHelper.getInitial());
                          },
                          child: Icon(
                            Icons.home_sharp,
                            size: defaultPadding(context) * 2,
                            color: Styles.appPrimaryColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: defaultPadding(context) * 1.3,
                ),
                Flexible(
                    child: Stack(
                  children: [
                    productSummaryList(),
                    Positioned(
                      bottom: 20,
                      left: 10,
                      right: 10,
                      child: Column(
                        children: [
                          FullWidthButton(
                            action: () {},
                            text: "Checkout",
                            color: Styles.appPrimaryColor,
                          )
                        ],
                      ),
                    )
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
