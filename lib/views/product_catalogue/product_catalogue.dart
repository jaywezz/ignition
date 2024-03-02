import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:soko_flow/configs/constants.dart';

import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/views/customers/sales/new_sales_order.dart';
import 'package:soko_flow/views/product_catalogue/components/productList.dart';
import 'package:soko_flow/views/product_catalogue/components/products_list.dart';
import '../../../routes/route_helper.dart';

class ProductCatalogueScreen extends ConsumerStatefulWidget {
  const ProductCatalogueScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductCatalogueScreen> createState() => _ProductCatalogueScreenState();
}

class _ProductCatalogueScreenState extends ConsumerState<ProductCatalogueScreen> {
  int initPosition = 0;
  List<String> options = ["Fast Movers", "Slow Movers"];

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
                    image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
                borderRadius:
                BorderRadius.only(bottomLeft: Radius.circular(30))),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: defaultPadding(context),
                  ),
                  Stack(
                    children: [
                      Material(
                        child: InkWell(
                          splashColor: Theme.of(context).splashColor,
                          onTap: () {
                            //Get.to(const DeliveryScreen());
                            Get.back();
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
                          'Product Catalogue',
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

                    ProductListWidget()
                  // Expanded(
                  //     child: Stack(
                  //       children: [
                  //         CustomTabView(
                  //           initPosition: initPosition,
                  //           itemCount: options.length,
                  //           tabBuilder: (context, index) {
                  //             // _log.e("..Options length" +
                  //             //     options.length.toString());
                  //             return Tab(
                  //               child: Container(
                  //                 width: MediaQuery.of(context).size.width * .4,
                  //                 padding: EdgeInsets.symmetric(
                  //                   horizontal: 15,
                  //                 ),
                  //                 decoration: BoxDecoration(
                  //                     borderRadius:
                  //                     BorderRadius.circular(50),
                  //                     border: Border.all(
                  //                         color: Styles.appPrimaryColor,
                  //                         width: 1)),
                  //                 child: Align(
                  //                   alignment: Alignment.center,
                  //                   child: Text(options[index]),
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //           pageBuilder: (context, index) {
                  //             var text = options[index];
                  //
                  //             return ProductListWidget();
                  //           },
                  //           onPositionChange: (index) {
                  //             print("Current Position: $index");
                  //
                  //             initPosition = index;
                  //           },
                  //           onScroll: (position) =>
                  //               print("Current Position: $position"),
                  //           stub: Center(
                  //             child: CircularProgressIndicator(),
                  //           ),
                  //         ),
                  //
                  //       ],
                  //     ))


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

