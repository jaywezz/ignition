import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/logic/routes/routes.dart';
import 'package:soko_flow/models/latest_allocations_model/latest_allocated_items_model.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/size_utils2.dart';

import 'package:soko_flow/views/product_catalogue/components/allocation_history_products.dart';
import 'package:soko_flow/views/product_catalogue/components/latest_allocations_products.dart';
import 'package:soko_flow/widgets/buttons/pill_button.dart';
import 'package:soko_flow/widgets/inputs/search_field.dart';

import '../../../routes/route_helper.dart';
import '../../errors/empty_failure_no_internet_view.dart';

class ViewMyStock extends StatefulWidget {
  const ViewMyStock({Key? key}) : super(key: key);

  @override
  State<ViewMyStock> createState() => _ViewMyStockState();
}

class _ViewMyStockState extends State<ViewMyStock> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  @override
  void initState() {
    StockHistoryController stockHistoryController = Get.put(
        StockHistoryController(stockHistoryRepository: Get.find()));
    stockHistoryController.getLatestAllocations(false);

    super.initState();
  }

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
            child: Column(
              children: [
                SizedBox(
                  height: defaultPadding(context),
                ),
                Stack(
                  children: [
                    Material(
                      child: InkWell(
                        splashColor: Theme
                            .of(context)
                            .splashColor,
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
                        'My Stock',
                        style: Styles.heading2(context),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Material(
                        child: InkWell(
                          splashColor: Theme
                              .of(context)
                              .splashColor,
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
                      'Current Stock',
                      style: Styles.heading2(context),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '',
                      style: Styles.smallGreyText(context),
                    ),
                  ],
                ),
                GetBuilder<StockHistoryController>(
                    builder: (stockAllocationController) {
                      return stockAllocationController.lstLatestAllocations
                          .length == 0 ? Center(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            StockHistoryController stockHistoryController = Get
                                .put(StockHistoryController(
                                stockHistoryRepository: Get.find()));
                            await stockHistoryController.getLatestAllocations(
                                true);
                          },
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("No stock",
                                  style: Styles.heading3(context).copyWith(
                                      color: Colors.black54),),
                              ),
                            ),
                          ),
                        ),
                      )
                          : Expanded(
                        child: LatestAllocationsProductList(
                          latestAllocationList: stockAllocationController
                              .lstLatestAllocations,),
                      );
                    })

              ],
            ),
          ),
        ),
      ),
    );
  }
}


