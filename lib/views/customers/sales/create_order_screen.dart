import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/add_cart.dart';
import 'package:soko_flow/controllers/payment_controller.dart';
import 'package:soko_flow/data/providers/add_stock_lift_provider.dart';
import 'package:soko_flow/data/providers/add_vansale_provider.dart';
import 'package:soko_flow/models/distributors_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/views/customers/sales/components/new_sales_order_list.dart';
import 'package:soko_flow/views/customers/sales/components/van_sales_order_list.dart';
import 'package:soko_flow/widgets/inputs/default_text_field.dart';

import '../../../widgets/buttons/full_width_button.dart';

class CreateOrderScreen extends ConsumerStatefulWidget {
  const CreateOrderScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends ConsumerState<CreateOrderScreen> {
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");
  TextEditingController discountController = TextEditingController();

  String screen_name = "";
  bool nopayment = false;
  @override
  void initState() {
    // TODO: implement initState
    if (Get.arguments["screen_name"] != "") {
      setState(() {
        screen_name = Get.arguments["screen_name"];
      });
    }
    if (Get.arguments["nopayment"] != null) {
      setState(() {
        nopayment = Get.arguments["nopayment"];
      });
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  bool hasDistributor = false;
  bool isLoading = false;

  // bool offerDiscount = false;

  DistributorsModel? selectedDistributor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: GetBuilder<AddToCartController>(builder: (addCartController) {
            return SingleChildScrollView(
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
                  child: GetBuilder<AddToCartController>(
                      builder: (addCartController) {
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
                                'Create Order',
                                style: Styles.heading2(context),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: defaultPadding(context) * 1.3,
                        ),
                        screen_name == "newSales"
                            ? NewSalesOrderList(
                                newSalesCartList: addCartController.cartList,
                              )
                            : VanSalesOrderList(
                                vanSalesCartList: addCartController.vanCartList,
                              ),
                        SizedBox(
                          height: 20.h,
                        ),

                        // TODO: Uncomment this to enable delivery by distributer
                        screen_name == "newSales"
                            ? CheckboxListTile(
                                title: Text(
                                  "To be delivered by distributor",
                                  style: Styles.heading3(context)
                                      .copyWith(color: Colors.black54),
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: hasDistributor,
                                onChanged: (value) {
                                  if (hasDistributor) {
                                    selectedDistributor = null;
                                    setState(() {
                                      hasDistributor = false;
                                    });
                                  } else {
                                    setState(() {
                                      hasDistributor = true;
                                    });
                                  }
                                })
                            : SizedBox.shrink(),
                        hasDistributor
                            ? ref.watch(distributorsProvider).when(
                                data: (data) {
                                if (data.isEmpty) {
                                  return Center(
                                      child: Text(
                                    "No distributors added",
                                    style: Styles.heading3(context)
                                        .copyWith(color: Colors.black38),
                                  ));
                                } else {
                                  // selectedDistributor = data[0];
                                  print("back here");
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: defaultPadding(context)),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .white, //background color of dropdown button
                                        border: Border.all(
                                            color: Styles
                                                .appYellowColor), //border of dropdown button
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: DropdownButtonFormField(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          disabledBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        ),
                                        hint: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Container(
                                                child:
                                                    Icon(Icons.arrow_drop_down),
                                              ),
                                            ),
                                          ],
                                        ), // Not necessary for Option 1
                                        style: Styles.heading3(context),
                                        value: selectedDistributor,
                                        onChanged:
                                            (DistributorsModel? newValue) {
                                          print("changed: ${newValue!.id}");
                                          print(newValue);
                                          selectedDistributor = newValue;
                                          // stockLiftController.getDistributorProducts();
                                          setState(() {});
                                        },
                                        items: data.map((distributor) {
                                          return DropdownMenuItem(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                              child: new Text(
                                                distributor.name!,
                                                style: Styles.heading3(context)
                                                    .copyWith(
                                                        color: Colors.black54),
                                              ),
                                            ),
                                            value: distributor,
                                          );
                                        }).toList(),
                                        icon: Padding(
                                            //Icon at tail, arrow bottom is default icon
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0),
                                            child: Icon(
                                                Icons.keyboard_arrow_down)),
                                      ),
                                    ),
                                  );
                                }
                              }, error: (error, s) {
                                return Text(
                                    "An error occurred getting distributors");
                              }, loading: () {
                                return Center(
                                    child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Styles.appSecondaryColor,
                                        )));
                              })
                            : SizedBox(),
                        SizedBox(
                          height: 40.h,
                        ),
                        Container(
                          height: defaultPadding(context) * 13.5,
                          padding: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "SubTotal (Ksh)",
                                  style: Styles.normalText(context).copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  formatCurrency
                                      .format(addCartController.totalCartPrice),
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
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700),
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
                                  formatCurrency
                                      .format(addCartController.totalCartPrice),
                                  style: Styles.heading1(context).copyWith(
                                    color: Styles.appSecondaryColor,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            isLoading == true
                                ? Center(
                                    child: Platform.isAndroid
                                        ? CircularProgressIndicator(
                                            color: Styles.appSecondaryColor)
                                        : CupertinoActivityIndicator())
                                : FullWidthButton(
                                    action: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (screen_name == "newSales") {
                                        await addCartController
                                            .addToOrderCart(selectedDistributor == null ? "1"
                                                :selectedDistributor!.id!.toString())
                                            .then((value) {
                                          print("the order id at create order: ${Get.find<PaymentController>().orderCode}");
                                          Get.close(2);
                                          print("Value is $value");
                                          Get.offNamed(
                                              RouteHelper.orderDetailsScreen(),
                                              arguments: {
                                                "orderCode": Get.find<PaymentController>().orderCode,
                                                "customer_id": Get.arguments['customer_id'].toString(),
                                                "allowpayment": true,
                                                "showStatus": false
                                              });
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                      } else {
                                        ref.read(addVanSaleNotifier.notifier).addVanSale().then((value){
                                          Get.close(2);
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Get.offNamed(
                                              RouteHelper.orderDetailsScreen(),
                                              arguments: {
                                                "orderCode": Get.find<PaymentController>().orderCode,
                                                "customer_id": Get.arguments['customer_id'].toString(),
                                                "distributor":null,
                                                "allowpayment": false
                                              });
                                        });
                                        // await addCartController
                                        //     .addToVanCart(
                                        //         discountController.text)
                                        //     .then((value) {
                                        //
                                        // });
                                      }

                                    },
                                    text: screen_name == "newSales"
                                        ? "Complete Pre-Order"
                                        : "Complete Sale",
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
                        )
                      ],
                    );
                  })),
            );
          }),
        ),
      ),
    );
  }
}
