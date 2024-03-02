


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
import 'package:soko_flow/models/wawrehouse_model/warehouses_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/app_constants.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/stock_requisition/confirm_stock_requisition.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:soko_flow/widgets/buttons/small_counter.dart';
import 'package:soko_flow/widgets/inputs/search_field.dart';


Logger _log = Logger(printer: PrettyPrinter());

class StockRequisition extends ConsumerStatefulWidget {
  const StockRequisition({Key? key}) : super(key: key);

  @override
  ConsumerState<StockRequisition> createState() => _StockRequisitionState();
}

class _StockRequisitionState extends ConsumerState<StockRequisition>  with AutomaticKeepAliveClientMixin<StockRequisition> {
  late TabController _tabController;
  int initPosition = 0;
  List<String> options = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var newCategoryID;
  // List<String> _distributors = ["Select Distributor", 'Thika Distributors', 'Kamau Distributors', 'Njooro Distributors', 'D'];
  // String _selectedDistributor = "Select Distributor";
  // final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
  }
  @override
  bool get wantKeepAlive => true;

  // WarehouseModel? selectedWarehouse = WarehouseModel();


  @override
  Widget build(BuildContext context) {
    // _log.e(Get.find<ProductCategoryController>().productCategoryList.length);
    // _log.e(Get.find<ProductController>().productList.length);
    // _log.e("Length of categories" + options.length.toString());
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
                            'Stock Requisition',
                            style: Styles.heading2(context),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Material(
                            child: InkWell(
                              splashColor: Theme.of(context).splashColor,
                              onTap: () => Get.offNamed(RouteHelper.getInitial()),
                              child: Icon(
                                Icons.home_sharp,
                                size: defaultPadding(context) * 2,
                                color: Styles.appPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: defaultPadding(context),
                    // ),
                    // Text(
                    //   'Stock Lift',
                    //   style: Styles.heading2(context),
                    // ),

                    // ref.watch(distributorsProvider).when(
                    //     data: (data){
                    //       if(data.isEmpty){
                    //         return Center(child: Text("No distributors added", style: Styles.heading3(context).copyWith(color: Colors.black38),));
                    //       }else{
                    //         selectedDistributor = data[0];
                    //         return Padding(
                    //           padding: EdgeInsets.symmetric(
                    //               horizontal: defaultPadding(context) ),
                    //           child: DecoratedBox(
                    //             decoration: BoxDecoration(
                    //               color:Colors.white, //background color of dropdown button
                    //               border: Border.all(color: Styles.appYellowColor), //border of dropdown button
                    //               borderRadius: BorderRadius.circular(20),
                    //             ),
                    //             child: DropdownButtonFormField(
                    //               isExpanded: true,
                    //               decoration: InputDecoration(
                    //                 disabledBorder: InputBorder.none,
                    //                 enabledBorder: InputBorder.none,
                    //                 focusedBorder: InputBorder.none,
                    //                 // prefixIcon: Container(
                    //                 //     height: 10,
                    //                 //   width: 10,
                    //                 //   decoration: BoxDecoration(
                    //                 //     color: Styles.appYellowColor,
                    //                 //       shape: BoxShape.circle
                    //                 //   ),
                    //                 //     child: Icon(Icons.add, color: Colors.redAccent, size: 1
                    //                 //       ,)
                    //                 // ),
                    //               ),
                    //               hint: Row(
                    //                 children: [
                    //
                    //                   Padding(
                    //                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //                     child: Container(
                    //                       child: Icon(Icons.arrow_drop_down),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ), // Not necessary for Option 1
                    //               style: Styles.heading3(context),
                    //               value: selectedDistributor,
                    //               onChanged: (DistributorsModel? newValue) {
                    //                 print("changed: ${newValue!.name}");
                    //                 print(newValue);
                    //                 selectedDistributor = newValue;
                    //                 // stockLiftController.getDistributorProducts();
                    //                 setState(() {});
                    //                 ref.refresh(distProductsProvider(selectedDistributor.id.toString()));
                    //
                    //               },
                    //               items: data.map((distributor) {
                    //                 return DropdownMenuItem(
                    //                   child: Padding(
                    //                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    //                     child: new Text(distributor.name!),
                    //                   ),
                    //                   value: distributor,
                    //                 );
                    //               }).toList(),
                    //               icon: Padding( //Icon at tail, arrow bottom is default icon
                    //                   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    //                   child:Icon(Icons.keyboard_arrow_down)
                    //               ),
                    //             ),
                    //           ),
                    //         );
                    //       }
                    //     },
                    //     error: (error, s){
                    //       return Text("An error occurred getting distributors");
                    //     }, loading: (){
                    //   return Center(child: SizedBox(height:20, width:20,child: CircularProgressIndicator(strokeWidth: 2,color: Styles.appSecondaryColor,)));
                    // }),


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

                    Text("Select warehouse", style: Styles.heading3(context),),
                    SizedBox(height: 5,),
                    ref.watch(warehouseProvider).when(
                        data: (data){
                          if(data.isEmpty){
                            return Center(child: Text("No warehouses added", style: Styles.heading3(context).copyWith(color: Colors.black38),));
                          }else{
                            // selectedWarehouse = data[0];
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                color:Colors.white, //background color of dropdown button
                                border: Border.all(color: Styles.appYellowColor), //border of dropdown button
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
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Container(
                                        child: Icon(Icons.arrow_drop_down),
                                      ),
                                    ),
                                  ],
                                ), // Not necessary for Option 1
                                style: Styles.heading3(context),
                                value: ref.watch(selectedWarehouseProvider),
                                onChanged: (WarehouseModel? newValue) {
                                  print("changed: ${newValue!.name}");
                                  print(newValue);
                                  ref.watch(selectedWarehouseProvider.state).state = newValue;
                                  // stockLiftController.getDistributorProducts()
                                  ref.refresh(warehouseProductsProvider(ref.watch(selectedWarehouseProvider)!.warehouseCode.toString()));
                                  setState(() {});

                                },
                                items: data.map((distributor) {
                                  return DropdownMenuItem(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: new Text(distributor.name!, style: Theme.of(context).textTheme.titleMedium,),
                                    ),
                                    value: distributor,
                                  );
                                }).toList(),
                                icon: Padding( //Icon at tail, arrow bottom is default icon
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child:Icon(Icons.keyboard_arrow_down)
                                ),
                              ),
                            );
                          }
                        },
                        error: (error, s){
                          return Text("An error occurred getting warehouses");
                        }, loading: (){
                      return Center(child: SizedBox(height:20, width:20,child: CircularProgressIndicator(strokeWidth: 2,color: Styles.appSecondaryColor,)));
                    }),

                    SizedBox(height: 10,),
                    ref.watch(selectedWarehouseProvider)== null?Center(child: Text("Select a warehouse", style: Styles.heading4(context),)):ref.watch(warehouseProductsProvider(ref.watch(selectedWarehouseProvider)!.warehouseCode.toString())).when(
                        data: (data){
                          if(data.isEmpty){
                            return Center(child: Text("No products in selected warehouse", style: Styles.heading4(context),));
                          }
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
                                              style: Theme.of(context).textTheme.titleMedium),
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
                        }, error: (error, stackTrace) {
                      print(stackTrace);
                      return Text(error.toString(), style: Styles.heading3(context).copyWith(color: Colors.red),);
                    },
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
          child: SingleChildScrollView(
            child: Column(children: [FullWidthButton(
              action: () {
                if(ref.watch(cartList).isEmpty){
                  showCustomSnackBar("Empty cart", isError: true);
                }else if(ref.watch(selectedWarehouseProvider) == null){
                  showCustomSnackBar("Select a warehouse", isError: true);
                }else{
                  Get.to(ConfirmStockRequisition(warehouseCode: ref.watch(selectedWarehouseProvider)!.warehouseCode!,));
                }

              },
              text: "Confirm Stock Requisition",
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
          ),
        )
    );
  }
}

// //Implementation

