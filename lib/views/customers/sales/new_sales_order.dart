import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletons/skeletons.dart';
import 'package:soko_flow/controllers/product_category_controller.dart';
import 'package:soko_flow/controllers/product_controller.dart';
import 'package:soko_flow/data/api_service/api_client.dart';
import 'package:soko_flow/data/providers/products_provider.dart';
import 'package:soko_flow/data/repository/product_category_repo.dart';
import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';
import 'package:soko_flow/models/customer_model/customer_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/app_constants.dart';
import 'package:soko_flow/views/customers/sales/confirm_sales_cart.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:soko_flow/widgets/buttons/small_counter.dart';

import '../../../base/show_custom_snackbar.dart';
import '../../../configs/constants.dart';
import '../../../configs/styles.dart';
import '../../../controllers/add_cart.dart';
import '../../../utils/debounce.dart';
import '../../../widgets/inputs/search_field.dart';

Logger _log = Logger(printer: PrettyPrinter());

class NewSalesOrder extends ConsumerStatefulWidget {
  final CustomerDataModel customer;
  final bool nopayment;
  const NewSalesOrder({
    Key? key,
    required this.nopayment,
    required this.customer,
  }) : super(key: key);

  @override
  ConsumerState<NewSalesOrder> createState() => _NewSalesOrderState();
}

class _NewSalesOrderState extends ConsumerState<NewSalesOrder>
    with AutomaticKeepAliveClientMixin<NewSalesOrder> {
  late TabController _tabController;
  int initPosition = 0;
  List<String> options = ["Fast Movers", "Slow Movers"];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final customer_name = Get.arguments["customer_name"];

  var newCategoryID;
  // final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        key: scaffoldKey,
        body: GetBuilder<AddToCartController>(builder: (addToCartController) {
          return Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.only(
                  left: defaultPadding(context),
                  right: defaultPadding(context),
                  bottom: defaultPadding(context)),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(30))),
              child: SafeArea(
                child: SingleChildScrollView(
                  // physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: defaultPadding(context),
                      ),
                      Stack(
                        children: [
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
                              customer_name,
                              style: Styles.heading3(context),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Material(
                              child: InkWell(
                                splashColor: Theme.of(context).splashColor,
                                onTap: () =>
                                    Get.offNamed(RouteHelper.getInitial()),
                                child: Icon(
                                  Icons.home_sharp,
                                  size: defaultPadding(context) * 2,
                                  color: Styles.appSecondaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: defaultPadding(context),
                      ),
                      Text(
                        'Pre-Order',
                        style: Styles.heading3(context),
                      ),
                      SizedBox(
                        height: defaultPadding(context),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding(context)),
                        child: LargeSearchField(
                          controller: ref.watch(searchValueProvider),
                          hintText: 'Search By Product Name',
                          outline: true,
                          onChanged: (value) {
                            print(
                                "the new value is: ${ref.watch(searchValueProvider)}");
                            ref.refresh(filteredProductsProvider);
                          },
                        ),
                      ),

                      ref.watch(filteredProductsProvider).when(
                          data: (data) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * .62,
                              child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder: (builder, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .5,
                                            child: Text(
                                                data[index]
                                                    .productName
                                                    .toString(),
                                                style:
                                                    Styles.normalText(context)),
                                          ),
                                          // Text(
                                          //     data[index]
                                          //         .skuCode
                                          //         .toString(),
                                          //     style:
                                          //     Styles.heading4(context)),
                                          Container(
                                            width: 50,
                                            height: 30,
                                            child: TextFormField(
                                              // controller: textEditingController,
                                              onChanged: (String value) {
                                                print(value);
                                                print(data[index].productName);
                                                if (int.parse(value) > 0) {
                                                  var cartData = NewSalesCart(
                                                    productMo: data[index],
                                                    qty: int.parse(value),
                                                    price:widget.customer.customerGroup == "Wholesaler" ? data[index].wholesalePrice!
                                                        :widget.customer.customerGroup == "Distributor"
                                                        ? data[index].distributorPrice!.toString()
                                                        : data[index].retailPrice!,
                                                  );
                                                  print(
                                                      "the data is ${cartData.productMo}, ${cartData.qty}");
                                                  addToCartController
                                                      .addNewSalesCart(
                                                          cartData);
                                                  print("value");
                                                }
                                              },
                                              textAlign: TextAlign.center,
                                              cursorHeight: 15,
                                              cursorColor:
                                                  Styles.appSecondaryColor,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  vertical: 2,
                                                  horizontal: 1,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles.appSecondaryColor),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(color: Styles.appSecondaryColor),
                                                ),
                                              ),
                                              keyboardType: TextInputType.number,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            );
                          },
                          error: (error, stackTrace) => Text(
                                error.toString(),
                                style: Styles.heading3(context)
                                    .copyWith(color: Colors.red),
                              ),
                          loading: () {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          })

                      // GetBuilder<ProductCategoryController>(builder: (productCategoryController){
                      //   return Expanded(
                      //     child: ListView.builder(
                      //         physics: BouncingScrollPhysics(),
                      //         itemCount: productCategoryController.productCategoryList.length,
                      //         itemBuilder: (_, categoryIndex) {
                      //           final category = productCategoryController.productCategoryList[categoryIndex];
                      //           return Padding(
                      //             padding: const EdgeInsets.symmetric(vertical: 5.0),
                      //             child: Card(
                      //
                      //               elevation: 1,
                      //               child: ExpansionTile(
                      //                 // this key is required to save and restore ExpansionTile expanded state
                      //                 key: PageStorageKey(category.id),
                      //
                      //                 iconColor: Styles.appPrimaryColor,
                      //                 textColor: Styles.appPrimaryColor,
                      //                 controlAffinity: ListTileControlAffinity.trailing,
                      //                 childrenPadding:
                      //                 const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      //                 expandedCrossAxisAlignment: CrossAxisAlignment.end,
                      //                 maintainState: true,
                      //                 title: Text(category.name!, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      //                 // contents
                      //                 children: [
                      //                   GetBuilder<ProductController>(builder: (categoryProducts){
                      //                     final product =
                      //                     Get.find<ProductController>()
                      //                         .productList
                      //                         .where((element) =>
                      //                     element.category == category.name!)
                      //                         .toList();
                      //                     return  ListView.builder(
                      //                         key: PageStorageKey(category.id),
                      //                         physics: NeverScrollableScrollPhysics(),
                      //                         shrinkWrap: true,
                      //                         itemCount: product.length,
                      //                         itemBuilder: (builder, index){
                      //
                      //                           return  Padding(
                      //                             padding: const EdgeInsets.symmetric(
                      //                               vertical: 8,
                      //                             ),
                      //                             child: Row(
                      //                               mainAxisAlignment:
                      //                               MainAxisAlignment.spaceBetween,
                      //                               children: [
                      //                                 Text(
                      //                                     product[index]
                      //                                         .productName
                      //                                         .toString(),
                      //                                     style:
                      //                                     Styles.heading4(context)),
                      //                                 Text(
                      //                                     product[index]
                      //                                         .skuCode
                      //                                         .toString(),
                      //                                     style:
                      //                                     Styles.heading4(context)),
                      //                                 Container(
                      //                                   width: 50,
                      //                                   height: 30,
                      //                                   child: TextFormField(
                      //                                     // controller: textEditingController,
                      //
                      //                                     onChanged: (String value){
                      //                                       // print("controller text: ${textEditingController.text}");
                      //                                       print(value);
                      //                                       print(product[index].productName);
                      //                                       if(int.parse(value) > 0){
                      //                                         var data = NewSalesCart(
                      //                                             productMo: product[index],
                      //                                             qty: int.parse(value)
                      //                                         );
                      //                                         print("the data is ${data.productMo}, ${data.qty}");
                      //                                         addToCartController.addNewSalesCart(data);
                      //                                         print("value");
                      //
                      //                                       }
                      //
                      //                                       // _debouncer.run(() {
                      //                                       //   print(value);
                      //                                       // });
                      //                                     },
                      //                                     textAlign: TextAlign.center,
                      //                                     cursorHeight: 15,
                      //                                     cursorColor:
                      //                                     Styles.appPrimaryColor,
                      //                                     decoration: InputDecoration(
                      //                                       contentPadding:
                      //                                       EdgeInsets.symmetric(
                      //                                         vertical: 2,
                      //                                         horizontal: 1,
                      //                                       ),
                      //                                       border: OutlineInputBorder(
                      //                                         borderSide: BorderSide(
                      //                                             color: Styles
                      //                                                 .appPrimaryColor),
                      //                                       ),
                      //                                       focusedBorder:
                      //                                       OutlineInputBorder(
                      //                                         borderSide: BorderSide(
                      //                                             color: Styles
                      //                                                 .appPrimaryColor),
                      //                                       ),
                      //                                     ),
                      //                                     keyboardType: TextInputType.number,
                      //                                   ),
                      //                                 )
                      //                               ],
                      //                             ),
                      //                           );
                      //                         });
                      //                   })
                      //
                      //
                      //                 ],
                      //               ),
                      //             ),
                      //           );
                      //         }),
                      //   );
                      // }),

                      // Expanded(
                      //
                      //     child: Stack(
                      //       children: [
                      //         GetBuilder<ProductCategoryController>(
                      //             builder: (productCategoryController) {
                      //               return !productCategoryController.isLoaded
                      //                   ? SkeletonListView(
                      //                 scrollable: true,
                      //                 itemCount: 10,
                      //               )
                      //                   : CustomTabView(
                      //                 initPosition: initPosition,
                      //                 itemCount: options.length,
                      //                 tabBuilder: (context, index) {
                      //                   // _log.e("..Options length" +
                      //                   //     options.length.toString());
                      //                   return Tab(
                      //                     child: Container(
                      //                       padding: EdgeInsets.symmetric(
                      //                         horizontal: 15,
                      //                       ),
                      //                       decoration: BoxDecoration(
                      //                           borderRadius:
                      //                           BorderRadius.circular(50),
                      //                           border: Border.all(
                      //                               color: Styles.appPrimaryColor,
                      //                               width: 1)),
                      //                       child: Align(
                      //                         alignment: Alignment.center,
                      //                         child: Text(options[index]),
                      //                       ),
                      //                     ),
                      //                   );
                      //                 },
                      //                 pageBuilder: (context, index) {
                      //                   var text = options[index];
                      //
                      //                   return ListView.builder(
                      //                       itemCount: Get.find<ProductController>()
                      //                           .productList
                      //                           .where((element) =>
                      //                       element.category == text)
                      //                           .toList()
                      //                           .length,
                      //                       itemBuilder: (context, index) {
                      //                         final product =
                      //                         Get.find<ProductController>()
                      //                             .productList
                      //                             .where((element) =>
                      //                         element.category == text)
                      //                             .toList();
                      //                         // Map<String, TextEditingController>
                      //                         // textEditingControllers = {};
                      //                         // var textFields = <TextField>[];
                      //                         //
                      //                         // product.forEach((str) {
                      //                         //   var textEditingController =
                      //                         //   TextEditingController(text: "0");
                      //                         //   textEditingControllers.putIfAbsent(
                      //                         //       str.category!,
                      //                         //           () => textEditingController);
                      //                         //   return textFields.add(TextField(
                      //                         //     controller: textEditingController,
                      //                         //     decoration: InputDecoration(
                      //                         //       border: OutlineInputBorder(),
                      //                         //     ),
                      //                         //   ));
                      //                         // });
                      //                         TextEditingController textEditingController =
                      //                           TextEditingController();
                      //                         return Padding(
                      //                           padding: const EdgeInsets.symmetric(
                      //                             vertical: 8,
                      //                           ),
                      //                           child: Row(
                      //                             mainAxisAlignment:
                      //                             MainAxisAlignment.spaceBetween,
                      //                             children: [
                      //                               Text(
                      //                                   product[index]
                      //                                       .productName
                      //                                       .toString(),
                      //                                   style:
                      //                                   Styles.heading4(context)),
                      //                               Text(
                      //                                   product[index]
                      //                                       .skuCode
                      //                                       .toString(),
                      //                                   style:
                      //                                   Styles.heading4(context)),
                      //                               Container(
                      //                                 width: 50,
                      //                                 height: 18,
                      //                                 child: TextFormField(
                      //                                   // controller: textEditingController,
                      //
                      //                                   onChanged: (String value){
                      //                                     // print("controller text: ${textEditingController.text}");
                      //                                     print(value);
                      //                                     print(product[index].productName);
                      //                                     if(int.parse(value) > 0){
                      //                                       var data = Cart(
                      //                                           productMo: product[index],
                      //                                           qty: value
                      //                                       );
                      //                                       print("the data is ${data.productMo}, ${data.qty}");
                      //                                       addToCartController.addCartData(data);
                      //                                       print("value");
                      //
                      //                                     }
                      //
                      //                                     // _debouncer.run(() {
                      //                                     //   print(value);
                      //                                     // });
                      //                                   },
                      //                                   textAlign: TextAlign.center,
                      //                                   cursorHeight: 15,
                      //                                   cursorColor:
                      //                                   Styles.appPrimaryColor,
                      //                                   decoration: InputDecoration(
                      //                                     contentPadding:
                      //                                     EdgeInsets.symmetric(
                      //                                       vertical: 2,
                      //                                       horizontal: 10,
                      //                                     ),
                      //                                     border: OutlineInputBorder(
                      //                                       borderSide: BorderSide(
                      //                                           color: Styles
                      //                                               .appPrimaryColor),
                      //                                     ),
                      //                                     focusedBorder:
                      //                                     OutlineInputBorder(
                      //                                       borderSide: BorderSide(
                      //                                           color: Styles
                      //                                               .appPrimaryColor),
                      //                                     ),
                      //                                   ),
                      //                                   keyboardType: TextInputType.number,
                      //                                 ),
                      //                               )
                      //                             ],
                      //                           ),
                      //                         );
                      //                       });
                      //                 },
                      //                 onPositionChange: (index) {
                      //                   print("Current Position: $index");
                      //
                      //                   initPosition = index;
                      //                 },
                      //                 onScroll: (position) =>
                      //                     print("Current Position: $position"),
                      //                 stub: Center(
                      //                   child: CircularProgressIndicator(),
                      //                 ),
                      //               );
                      //             })
                      //       ],
                      //     ))
                    ],
                  ),
                ),
              ));
        }),
        bottomNavigationBar: Container(
          height: defaultPadding(context) * 6,
          padding: EdgeInsets.only(
              left: defaultPadding(context),
              right: defaultPadding(context),
              bottom: defaultPadding(context)),
          child: SingleChildScrollView(
            child: Column(children: [
              FullWidthButton(
                action: () {
                  if (Get.find<AddToCartController>().cartList.isEmpty) {
                    showCustomSnackBar("Empty cart", isError: true);
                  } else {
                    Get.to(
                        ConfirmSalesCart(
                            customer: widget.customer,
                            nopayment: widget.nopayment),
                        arguments: {"screen_name": "newSales"});
                  }
                },
                text: "Confirm Cart",
              ),
              InkWell(
                onTap: () {
                  // addToCartController.lstCartData.clear();
                  Get.back();
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Cancel",
                      style: Styles.heading3(context),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ));
  }
}

// //Implementation

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    required this.stub,
    required this.onPositionChange,
    required this.onScroll,
    required this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  late TabController controller;
  late int _currentCount;
  late int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation!.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation!.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation!.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  // @override
  // void dispose() {
  //   controller.animation!.removeListener(onScroll);
  //   controller.removeListener(onPositionChange);
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub;

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // ==============================
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: Container(
                      // alignment: Alignment.center,
                      child: TabBar(
                        padding: EdgeInsets.symmetric(
                          horizontal: defaultPadding(context) * 0,
                        ),
                        unselectedLabelColor: Styles.appSecondaryColor,
                        isScrollable: true,
                        controller: controller,
                        labelColor: Colors.white,
                        //indicatorSize: TabBarIndicatorSize.label,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Styles.appSecondaryColor,
                        ),
                        tabs: List.generate(
                          widget.itemCount,
                          (index) {
                            return widget.tabBuilder(context, index);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
//               // ===================================

              Container(
                  child: Column(
                children: [
                  SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      // child: Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: defaultPadding(context),
                        ),
                        margin: EdgeInsets.only(
                          bottom: 350,
                        ),
                        child: TabBarView(
                          controller: controller,
                          children: List.generate(
                            widget.itemCount,
                            (index) => widget.pageBuilder(context, index),
                          ),
                        ),
                      ),
                      // ),
                    ),
                  ),
                ],
              )),
            ],
          ),
          // ==============================
        ),
      ),
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation!.value);
    }
  }
}
