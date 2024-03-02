import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soko_flow/configs/constants.dart';

import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/logic/routes/routes.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/components/customer_detail_list.dart';
import 'package:soko_flow/views/customers/payment_screen.dart';
//import 'package:soko_flow/views/customers/components/customer_detail_list.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:soko_flow/widgets/cards/order_summary_card.dart';
import 'package:soko_flow/widgets/cards/payment_list_card.dart';

import '../../routes/route_helper.dart';

class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen({Key? key}) : super(key: key);

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map> myInventoryItems = [
      {'icon': Icons.local_shipping_outlined, 'name': 'Cash'},
      {'icon': Icons.shopping_cart, 'name': 'Mpesa'},
      {'icon': Icons.check_box_rounded, 'name': 'Airtel Money'},
      {'icon': Icons.local_shipping_rounded, 'name': 'Credit'},
      {'icon': Icons.shopping_cart, 'name': 'Cheque'},
      {'icon': Icons.restart_alt_outlined, 'name': 'Pesa Link'},
      {'icon': Icons.restart_alt_outlined, 'name': 'Add Payment Method'},
    ];
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          //color: Styles.appBackgroundColor,
          child: Container(
            padding: EdgeInsets.only(
                left: defaultPadding(context),
                right: defaultPadding(context),
                bottom: defaultPadding(context)),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(30))),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 45,
                      ),
                      Material(
                        child: InkWell(
                          splashColor: Theme.of(context).splashColor,
                          onTap: () => Get.back(),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Styles.darkGrey,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Order Summary',
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
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: OrderSummaryCard()),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: FullWidthButton(
                          text: "Checkout",
                          action: () {
                            Get.to(() => PaymentScreen());
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),

            // Column(
            //   children: [
            //     SizedBox(
            //       height: defaultPadding(context),
            //     ),

            //     Stack(
            //       children: [
            //         SizedBox(
            //           height: 50,
            //         ),
            //         OrderSummaryCard(),
            //         Positioned(
            //           bottom: 0,
            //           left: 0,
            //           right: 0,
            //           child: FullWidthButton(
            //             text: "Checkout",
            //             action: () {
            //               Navigate.instance.to('/payment');
            //             },
            //           ),
            //         ),
            //       ],
            //     )
            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}
