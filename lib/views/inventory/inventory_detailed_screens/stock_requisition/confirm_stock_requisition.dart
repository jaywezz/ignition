import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/add_cart.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/controllers/stocklift_controller.dart';
import 'package:soko_flow/data/providers/add_stock_lift_provider.dart';
import 'package:soko_flow/logic/routes/routes.dart';
import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/services/global_method.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/sales/components/new_sales_cart_list.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/components/stock_lift_cart_list.dart';
import 'package:soko_flow/views/product_catalogue/components/latest_allocations_products.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:soko_flow/widgets/inputs/search_field.dart';


class ConfirmStockRequisition extends ConsumerStatefulWidget {
  final String warehouseCode;
  const ConfirmStockRequisition({Key? key, required this.warehouseCode}) : super(key: key);

  @override
  ConsumerState<ConfirmStockRequisition> createState() => _ConfirmStockRequisitionState();
}

class _ConfirmStockRequisitionState extends ConsumerState<ConfirmStockRequisition> with SingleTickerProviderStateMixin{
  int _currentIndex = 0;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalMethod globalMethod = GlobalMethod();
    // List<Cart> _cartItems = Get.arguments['cartItems'];
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
              child:Column(
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
                          'Confirm Stock Requisition',
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
                              color: Styles.appSecondaryColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: defaultPadding(context) * 1.3,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding(context) * 1.8),
                    child: const LargeSearchField(
                      hintText: 'Search By Name',
                      outline: true,
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding(context) * .4,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Confirm Stock Requisition',
                        style: Styles.heading3(context),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      IconButton(
                        onPressed: (){
                          // _cartItems.clear();
                          ref.watch(cartList).clear();
                        },
                        icon: Icon(Icons.delete_sweep_outlined, color: Styles.appSecondaryColor,),)
                    ],
                  ),
                  Expanded(
                      child: StockLiftCartList(cartProductList: ref.watch(cartList),)
                  )

                ],
              )
          ),
        ),
      ),
      bottomNavigationBar:
      GetBuilder<StockLiftController>(builder: (stockLiftController) {
        return Container(
          height: defaultPadding(context) * 7,
          padding: EdgeInsets.only(
            left: defaultPadding(context),
            right: defaultPadding(context),
          ),
          child: Column(
            children: [
              ref.watch(addStockLiftNotifier).isLoading?CircularProgressIndicator():FullWidthButton(
                action: () async{
                  await ref.read(addStockLiftNotifier.notifier).stockRequisition(widget.warehouseCode).then((value) => Get.close(2));
                  ref.read(cartList).clear();
                  await ref.refresh(stockRequisitionsProvider);

                },
                text: 'Confirm Requisition',
                color: Styles.appSecondaryColor,
              ),
              Material(
                child: InkWell(
                  splashColor: Theme.of(context).splashColor,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: defaultPadding(context)),
                    child: Center(
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: Styles.normalText(context),
                        )),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  final List stock1 = const [
    'All', 'Past 1 Month', 'Last 3 Months', 'Last 6 months', '1 year'
    // {"name": "All", "icon": "assets/icons/a.png"},
    // {"name": "Past 1 Month", "icon": "assets/icons/b.png"},
    // {"name": "Last 3 Months", "icon": "assets/icons/f.png"},
    // {"name": "Last 6 Months", "icon": "assets/icons/g.png"},
    // {"name": "1 year", "icon": "assets/icons/c.png"},
  ];
}
