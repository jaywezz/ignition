import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletons/skeletons.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/controllers/product_category_controller.dart';
import 'package:soko_flow/controllers/product_controller.dart';
import 'package:soko_flow/data/api_service/api_client.dart';
import 'package:soko_flow/data/repository/product_category_repo.dart';
import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';
import 'package:soko_flow/models/customer_model/customer_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/app_constants.dart';
import 'package:soko_flow/views/customers/sales/components/quantity_input.dart';
import 'package:soko_flow/views/customers/sales/confirm_sales_cart.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';

import '../../../base/show_custom_snackbar.dart';
import '../../../configs/constants.dart';
import '../../../configs/styles.dart';
import '../../../controllers/add_cart.dart';
import '../../../widgets/buttons/small_counter.dart';
import '../../../widgets/inputs/search_field.dart';

Logger _log = Logger(printer: PrettyPrinter());

class VanSales extends StatefulWidget {
  final CustomerDataModel customer;
  const VanSales({Key? key, required this.customer}) : super(key: key);

  @override
  State<VanSales> createState() => _VanSalesState();
}

class _VanSalesState extends State<VanSales> {
  late TabController _tabController;
  int initPosition = 0;
  List<String> options = ["Fast Movers", "Slow Movers"];

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final customer_name = Get.arguments["customer_name"];

  var newCategoryID;
  // tabOptions(BuildContext context) async {
  //   await Get.find<ProductCategoryController>().getProductCategories();
  //   //await Get.find<ProductController>().getProducts();
  //   var controller =
  //       await Get.find<ProductCategoryController>().productCategoryList;
  //   options.clear();
  //   //options.add("All");
  //   for (var i = 0; i < controller.length; i++) {
  //     options.add(controller[i].name.toString());
  //   }
  //   await options;
  // }
  var categoryController = Get.find<ProductCategoryController>();
  @override
  void initState() {
    Get.find<StockHistoryController>().getLatestAllocations(false);
    super.initState();

    // tabOptions(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            style: Styles.heading2(context),
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
                      'Van Sales',
                      style: Styles.heading2(context),
                    ),
                    SizedBox(
                      height: defaultPadding(context),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: defaultPadding(context) * 1.8),
                      child: const LargeSearchField(
                        hintText: 'Search By Product Name',
                        outline: true,
                      ),
                    ),
                    Expanded(
                        child: Stack(
                      children: [
                        GetBuilder<StockHistoryController>(
                            builder: (stockHistoryController) {
                          return stockHistoryController.isLoading
                              ? SkeletonListView(
                                  scrollable: true,
                                  itemCount: 10,
                                )
                              : ListView.builder(
                                  // key: PageStorageKey(category.id),
                                  physics: AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: stockHistoryController
                                      .lstLatestAllocations.length,
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
                                            width: MediaQuery.of(context).size.width * .5,
                                            child: Text(
                                                stockHistoryController
                                                    .lstLatestAllocations[index]
                                                    .productName
                                                    .toString(),
                                                style:
                                                    Styles.heading4(context)),
                                          ),
                                          // Text(
                                          //     stockHistoryController.lstLatestAllocations[index]
                                          //         .skuCode
                                          //         .toString(),
                                          //     style:
                                          //     Styles.heading4(context)),
                                          Row(
                                            children: [
                                              Text(
                                                  "(${stockHistoryController.lstLatestAllocations[index].allocatedQty.toString()})",
                                                  style: Styles.heading4(
                                                          context)
                                                      .copyWith(
                                                          color: Styles
                                                              .appSecondaryColor)),
                                              Container(
                                                  width: 50,
                                                  height: 25,
                                                  child: QuantitySmallInput(
                                                    allocations:
                                                        stockHistoryController
                                                                .lstLatestAllocations[
                                                            index],
                                                    isReconcile: false,
                                                    price: widget.customer.customerGroup == "Wholesaler"
                                                        ? stockHistoryController.lstLatestAllocations[index].wholeSalePrice!
                                                        :widget.customer.customerGroup == "Distributor"
                                                        ? stockHistoryController.lstLatestAllocations[index].distributorPrice!
                                                        : stockHistoryController.lstLatestAllocations[index].retailPrice!,

                                                    // controller: _editingController,
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  });
                        })
                      ],
                    ))
                  ],
                ),
              ));
        }),
        bottomNavigationBar: Container(
          height: defaultPadding(context) * 7,
          padding: EdgeInsets.only(
              left: defaultPadding(context),
              right: defaultPadding(context),
              bottom: defaultPadding(context)),
          child: SingleChildScrollView(
            child: Column(children: [
              FullWidthButton(
                color: Styles.appSecondaryColor,
                action: () {
                  if (Get.find<AddToCartController>().vanCartList.isEmpty) {
                    showCustomSnackBar("Empty cart", isError: true);
                  } else {
                    Get.to(
                        ConfirmSalesCart(
                            nopayment: false, customer: widget.customer),
                        arguments: {'screen_name': "vanSales"});
                  }
                  // _addToCart();
                },
                text: "Add",
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
  // void _addTextField(void Function(String value)? onChanged) {
  //   final controller = TextEditingController();
  //   _textFields.add(
  //
  //   );
  //   _qtyControllers!.add(controller);
  // }
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
          // padding: EdgeInsets.only(
          //   left: defaultPadding(context),
          //   right: defaultPadding(context),
          //   bottom: defaultPadding(context),
          // ),
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
                        unselectedLabelColor: Styles.appPrimaryColor,
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
