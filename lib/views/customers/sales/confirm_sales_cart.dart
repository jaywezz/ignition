import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/add_cart.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/logic/routes/routes.dart';
import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';
import 'package:soko_flow/models/customer_model/customer_model.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/sales/components/new_sales_cart_list.dart';
import 'package:soko_flow/views/customers/sales/components/van_sales_cart_list.dart';
import 'package:soko_flow/views/product_catalogue/components/latest_allocations_products.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:soko_flow/widgets/inputs/search_field.dart';

import '../../../../routes/route_helper.dart';
import '../../errors/empty_failure_no_internet_view.dart';

class ConfirmSalesCart extends StatefulWidget {
  final CustomerDataModel customer;
  final bool nopayment;
  const ConfirmSalesCart(
      {Key? key, required this.nopayment, required this.customer})
      : super(key: key);

  @override
  State<ConfirmSalesCart> createState() => _ConfirmSalesCartState();
}

class _ConfirmSalesCartState extends State<ConfirmSalesCart>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");

  @override
  void initState() {
    if (Get.arguments["screen_name"] != "") {
      setState(() {
        screen_name = Get.arguments["screen_name"];
      });
    }
    StockHistoryController stockHistoryController =
        Get.put(StockHistoryController(stockHistoryRepository: Get.find()));
    stockHistoryController.getLatestAllocations(false);

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
              child:
                  GetBuilder<AddToCartController>(builder: (addCartController) {
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
                            'My Cart',
                            style: Styles.heading2(context),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Material(
                            child: InkWell(
                              splashColor: Theme.of(context).splashColor,
                              onTap: () =>
                                  Get.toNamed(RouteHelper.getInitial()),
                              child: Icon(
                                Icons.home_sharp,
                                size: defaultPadding(context) * 2,
                                color: Styles.appSecondaryColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    // SizedBox(height: defaultPadding(context) * 1.3,),
                    SizedBox(
                      height: defaultPadding(context) * .4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Confirm Order',
                          style: Styles.heading2(context),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        IconButton(
                          onPressed: () {
                            // _cartItems.clear();
                            addCartController.totalCartPrice = 0;
                            addCartController.cartList.clear();
                            addCartController.update();
                            Get.back();
                          },
                          icon: Icon(
                            Icons.delete_sweep_outlined,
                            color: Styles.appPrimaryColor,
                          ),
                        )
                      ],
                    ),
                    Expanded(
                        child: screen_name == "newSales"
                            ? NewSalesCartList(
                                customer: widget.customer,
                                cartProductList: addCartController.cartList,
                              )
                            : VanSalesCartList(
                                customer: widget.customer,
                                vanSalesCartList: addCartController.vanCartList,
                              ))
                  ],
                );
              })),
        ),
      ),
      bottomNavigationBar:
          GetBuilder<AddToCartController>(builder: (addToCartController) {
        return Container(
          height: defaultPadding(context) * 13.5,
          padding: EdgeInsets.only(
                  top: defaultPadding(context) * .7,
                  left: defaultPadding(context) * 1.5,
                  right: defaultPadding(context) * 1.5,
                  bottom: defaultPadding(context)) *
              1.5,
          child: SingleChildScrollView(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SubTotal (Ksh)",
                    style: Styles.normalText(context).copyWith(
                        color: Colors.grey, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    formatCurrency.format(addToCartController.totalCartPrice),
                    style: Styles.heading3(context),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tax",
                    style: Styles.normalText(context).copyWith(
                        color: Colors.grey, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '0.0',
                    style: Styles.heading3(context),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total (Ksh. )",
                    style: Styles.heading2(context)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formatCurrency.format(addToCartController.totalCartPrice),
                    style: Styles.heading1(context).copyWith(
                      color: Styles.appSecondaryColor,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              addToCartController.isLoading == true
                  ? Center(
                      child: Platform.isAndroid
                          ? CircularProgressIndicator(
                              color: Styles.appSecondaryColor)
                          : CupertinoActivityIndicator())
                  : FullWidthButton(
                      action: () {
                        // addToCartController.addToCart();
                        Get.toNamed(RouteHelper.createOrder(), arguments: {
                          "screen_name": screen_name,
                          "nopayment": widget.nopayment
                        });
                      },
                      text: screen_name == "newSales"
                          ? "Create Pre-Order"
                          : "Create Sale",
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
          ),
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
