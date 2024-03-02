


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletons/skeletons.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/product_category_controller.dart';
import 'package:soko_flow/controllers/product_controller.dart';
import 'package:soko_flow/controllers/stocklift_controller.dart';
import 'package:soko_flow/data/api_service/api_client.dart';
import 'package:soko_flow/data/providers/add_stock_lift_provider.dart';
import 'package:soko_flow/data/providers/customer_provider.dart';
import 'package:soko_flow/data/providers/products_provider.dart';
import 'package:soko_flow/data/repository/product_category_repo.dart';
import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';
import 'package:soko_flow/models/distributors_model.dart';
import 'package:soko_flow/models/requisitions/requisition_products.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/app_constants.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/stock_requisition/confirm_stock_requisition.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/stock_requisition/edit_requisition/confirm_edit_requisition.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:soko_flow/widgets/buttons/small_counter.dart';
import 'package:soko_flow/widgets/inputs/search_field.dart';


Logger _log = Logger(printer: PrettyPrinter());

class StockEditRequisition extends ConsumerStatefulWidget {
  final RequisitionModel requisition;
  const StockEditRequisition( {Key? key, required this.requisition,}) : super(key: key);

  @override
  ConsumerState<StockEditRequisition> createState() => _StockEditRequisitionState();
}

class _StockEditRequisitionState extends ConsumerState<StockEditRequisition>  with AutomaticKeepAliveClientMixin<StockEditRequisition> {
  late TabController _tabController;
  int initPosition = 0;
  List<String> options = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var newCategoryID;
  @override
  void initState() {
    super.initState();
  }
  @override
  bool get wantKeepAlive => true;

  DistributorsModel selectedDistributor = DistributorsModel();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
        key: scaffoldKey,
        body: Padding(
          padding:  EdgeInsets.only(bottom: 0),
          child: Container(
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
                            'Requisition Edit',
                            style: Styles.heading2(context),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h,),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: defaultPadding(context)),
                    //   child: LargeSearchField(
                    //     controller: ref.watch(searchValueProvider),
                    //     hintText: 'Search By Product Name',
                    //     outline: true,
                    //     onChanged: (value){
                    //       print("the new value is: ${ref.watch(searchValueProvider)}");
                    //       ref.refresh(distProductsProvider(selectedDistributor.id.toString()));
                    //     },
                    //   ),
                    // ),

                    ref.watch(productsProvider).when(
                        data: (data){
                          return Expanded(
                            child: ListView.builder(
                              // key: PageStorageKey(category.id),
                                physics: AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (builder, index){

                                  return  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width *.5,
                                          child: Text(
                                              data[index]
                                                  .productName
                                                  .toString(),
                                              style: Styles.normalText(context)),
                                        ),

                                        Container(
                                          width: 50,
                                          height: 30,
                                          child: TextFormField(
                                            // controller: textEditingController,
                                            onChanged: (String value){
                                              // print("controller text: ${textEditingController.text}");
                                              print(value);
                                              print(data[index].productName);
                                              if(int.parse(value) > 0){
                                                var cartData = NewSalesCart(
                                                    productMo: data[index],
                                                    qty: int.parse(value),
                                                    price:  data[index].wholesalePrice!
                                                );
                                                print("the data is ${cartData.productMo}, ${cartData.qty}");
                                                ref.watch(addStockLiftNotifier.notifier).addStockLiftCart(cartData);
                                                print("value");
                                              }
                                            },
                                            textAlign: TextAlign.center,
                                            cursorHeight: 15,
                                            cursorColor:
                                            Styles.appPrimaryColor,
                                            decoration: InputDecoration(
                                              contentPadding:
                                              EdgeInsets.symmetric(
                                                vertical: 2,
                                                horizontal: 1,
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Styles
                                                        .appPrimaryColor),
                                              ),
                                              focusedBorder:
                                              OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Styles
                                                        .appPrimaryColor),
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
                        }, error: (error, stackTrace) => Text(error.toString(), style: Styles.heading3(context).copyWith(color: Colors.red),),
                        loading: (){
                          return Center(child: SizedBox(height:20, width:20,child: CircularProgressIndicator(strokeWidth: 2,color: Styles.appSecondaryColor,)));
                        })
                  ],
                ),
              )),
        ),
        bottomNavigationBar: Container(
          height: defaultPadding(context) * 7,
          padding: EdgeInsets.only(
              left: defaultPadding(context),
              right: defaultPadding(context),
              bottom: defaultPadding(context)),
          child: Column(children: [FullWidthButton(
            action: () {
              if(ref.watch(cartList).isEmpty){
                showCustomSnackBar("Empty cart", isError: true);
              }else{
                Get.to(ConfirmEditRequisition(requisition: widget.requisition,));
              }
            },
            text: "Confirm Stock Edit",
          ),
            InkWell(
              onTap: () {
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
        )
    );
  }
}

// //Implementation

