import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/add_cart.dart';
import 'package:soko_flow/controllers/reconcile_controller.dart';
import 'package:soko_flow/models/wawrehouse_model/warehouses_model.dart';
import 'package:soko_flow/views/customers/sales/components/van_sales_cart_list.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/reconcile/reconcile.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/reconcile/reconcile_cart_list.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';

import '../../../../routes/route_helper.dart';

class ConfirmReconcileCart extends StatefulWidget {
  final String warehouse;
  final String distributorId;
  const ConfirmReconcileCart({Key? key, required this.warehouse, required this.distributorId}) : super(key: key);

  @override
  State<ConfirmReconcileCart> createState() => _ConfirmReconcileCartState();
}

class _ConfirmReconcileCartState extends State<ConfirmReconcileCart> with SingleTickerProviderStateMixin{
  int _currentIndex = 0;

  final formatCurrency = new NumberFormat.currency(locale: "en_US",
      symbol: "");

  @override
  void initState() {

    super.initState();
  }
  String screen_name = "";

  @override
  Widget build(BuildContext context) {

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
                      image: AssetImage(
                        'assets/bg.png',
                      ),
                      fit: BoxFit.cover),
                  borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(30))),
              child: GetBuilder<ReconcileController>(builder: (reconcileController){
                return Column(
                  children: [
                    SizedBox(
                      height: defaultPadding(context),
                    ),
                    Stack(
                      children: [
                        Material(
                          child: InkWell(
                            splashColor: Theme.of(context).splashColor,
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Styles.darkGrey,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Reconcile Cart',
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
                        )
                      ],
                    ),
                    SizedBox(
                      height: defaultPadding(context) * 1.3,
                    ),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: defaultPadding(context) * 1.8),
                    //   child: const LargeSearchField(
                    //     hintText: 'Search By Name',
                    //     outline: true,
                    //   ),
                    // ),
                    SizedBox(
                      height: defaultPadding(context) * .4,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Confirm Cart Items',
                          style: Styles.heading2(context),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        IconButton(
                          onPressed: (){
                            // _cartItems.clear();
                            reconcileController.totalCartPrice = 0;
                            reconcileController.reconcileCartList.clear();
                            reconcileController.update();
                            Get.back();
                          },
                          icon: Icon(Icons.delete_sweep_outlined, color: Styles.appPrimaryColor,),)
                      ],
                    ),
                    Expanded(
                        child:ReconcileCartList(reconcileCartList: reconcileController.reconcileCartList, warehouse: widget.warehouse,)
                    )

                  ],
                );
              })
          ),
        ),
      ),
      bottomNavigationBar:
      GetBuilder<AddToCartController>(builder: (addToCartController) {
        return Container(
          height: defaultPadding(context) * 7,
          padding: EdgeInsets.only(
              top: defaultPadding(context) * .7,
              left: defaultPadding(context) * 1.5,
              right: defaultPadding(context) * 1.5,
              bottom: defaultPadding(context)) *1.5,
          child: Column(
              children: [
                SizedBox(height: 10,),
                addToCartController.isLoading == true
                    ? Center(
                    child: Platform.isAndroid
                        ? CircularProgressIndicator(
                        color: Styles.appPrimaryColor)
                        : CupertinoActivityIndicator())
                    : FullWidthButton(
                  action: () {
                    // addToCartController.addToCart();
                    Get.to(Reconcile(warehouse: widget.warehouse, distributorId: widget.distributorId,));
                  },
                  text: "Reconcile",
                ),
                // InkWell(
                //   onTap: () {
                //     // addToCartController.lstCartData.clear();
                //     // addToCartController.update();
                //     Get.back();
                //   },
                //   child: Center(
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Text(
                //         "Cancel",
                //         style: Styles.heading3(context),
                //       ),
                //     ),
                //   ),
                // )
              ]),
        );
      }),
    );
  }

  final List cuisines2 = const [
    {"name": "Indian", "icon": "assets/icons/h.png"},
    {"name": "Italian", "icon": "assets/icons/i.png"},
    {"name": "kenyan", "icon": "assets/icons/d.png"},
    {"name": "French", "icon": "assets/icons/e.png"},
    {"name": "Ghanaian", "icon": "assets/icons/j.png"},
  ];

  final List cuisines1 = const [
    {"name": "All", "icon": "assets/icons/a.png"},
    {"name": "Past 1 Month", "icon": "assets/icons/b.png"},
    {"name": "Last 3 Months", "icon": "assets/icons/f.png"},
    {"name": "Last 6 Months", "icon": "assets/icons/g.png"},
    {"name": "1 year", "icon": "assets/icons/c.png"},
  ];

  final List stock1 = const [
    'All', 'Past 1 Month', 'Last 3 Months', 'Last 6 months', '1 year'
    // {"name": "All", "icon": "assets/icons/a.png"},
    // {"name": "Past 1 Month", "icon": "assets/icons/b.png"},
    // {"name": "Last 3 Months", "icon": "assets/icons/f.png"},
    // {"name": "Last 6 Months", "icon": "assets/icons/g.png"},
    // {"name": "1 year", "icon": "assets/icons/c.png"},
  ];
}
