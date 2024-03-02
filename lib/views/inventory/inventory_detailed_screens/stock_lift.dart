


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletons/skeletons.dart';
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
import 'package:soko_flow/models/latest_allocations_model/latest_allocated_items_model.dart';
import 'package:soko_flow/models/productsModel/products_model.dart';
import 'package:soko_flow/models/wawrehouse_model/warehouses_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/app_constants.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/components/confirm_stocklift.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:soko_flow/widgets/buttons/small_counter.dart';

import '../../../base/show_custom_snackbar.dart';
import '../../../configs/constants.dart';
import '../../../configs/styles.dart';
import '../../../controllers/add_cart.dart';
import '../../../utils/debounce.dart';
import '../../../widgets/inputs/search_field.dart';

Logger _log = Logger(printer: PrettyPrinter());

class StockLift extends ConsumerStatefulWidget {
  const StockLift({Key? key}) : super(key: key);

  @override
  ConsumerState<StockLift> createState() => _StockLiftState();
}

class _StockLiftState extends ConsumerState<StockLift>  with AutomaticKeepAliveClientMixin<StockLift> {
  late TabController _tabController;
  int initPosition = 0;
  List<String> options = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();


  TextEditingController searchController = TextEditingController();
  DistributorsModel? selectedDistributor;
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

  WarehouseModel? selectedWarehouse;

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
                            'StockLift',
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
                    ref.watch(distributorsProvider).when(
                        data: (data){
                          return SingleChildScrollView(
                            child: TypeAheadFormField<DistributorsModel>(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: searchController,
                                decoration: InputDecoration(
                                  labelText: 'Search Distributor',
                                  hintText: 'Search',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 1.0,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                return data.where((element) => element.name!.toLowerCase().contains(pattern.toLowerCase())).toList();
                              },
                              itemBuilder: (context, DistributorsModel suggestion) {
                                // Replace this with your own logic to build the suggestion widget
                                return ListTile(
                                  title: Text(suggestion.name?? "No name"),
                                  subtitle: Text(suggestion.telephone?? "0") ,
                                );
                              },
                              onSuggestionSelected: (DistributorsModel suggestion) {
                                print("id: ${suggestion.id}");
                                setState(() {
                                  selectedDistributor = suggestion;
                                  searchController.text = suggestion.name!;
                                });
                                // Replace this with your own logic to handle suggestion selection
                                print('Selected: $suggestion');
                              },
                              noItemsFoundBuilder: (context) {
                                // Replace this with your own logic to build the no items found widget
                                return ListTile(
                                  title: Text('No results found'),
                                );
                              },
                            ),
                          );
                        },
                        error: (e,s){
                          return Text("An error occurred getting distributors");
                        },
                        loading: (){
                          return Center(
                                    child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Styles.appSecondaryColor,
                                        )));
                        }),
                    SizedBox(height: 20,),

                  selectedDistributor !=null?selectedDistributor!.id == 1?ref.watch(warehouseProvider).when(
                        data: (data){
                          if(data.isEmpty){
                            return Center(child: Text("No warehouses added", style: Styles.heading3(context).copyWith(color: Colors.black38),));
                          }else{
                            // selectedWarehouse = data[1];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10 ),
                              child: DecoratedBox(
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
                                  value: selectedWarehouse,
                                  onChanged: (WarehouseModel? newValue)async {
                                    print("changed: ${newValue!.name}");
                                    print(newValue);
                                    selectedWarehouse = newValue;
                                    // stockLiftController.getDistributorProducts();
                                    await ref.refresh(warehouseProductsProvider(selectedWarehouse!.warehouseCode.toString()));

                                    setState(() {});
                                  },
                                  items: data.map((distributor) {
                                    return DropdownMenuItem(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        child: new Text(distributor.name!),
                                      ),
                                      value: distributor,
                                    );
                                  }).toList(),
                                  icon: Padding( //Icon at tail, arrow bottom is default icon
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child:Icon(Icons.keyboard_arrow_down)
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        error: (error, s){
                          return Text("An error occurred getting warehouses");
                        }, loading: (){
                      return Center(child: SizedBox(height:20, width:20,child: CircularProgressIndicator(strokeWidth: 2,color: Styles.appSecondaryColor,)));
                    }):SizedBox():SizedBox(),


                    SizedBox(height: 20.h,),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: defaultPadding(context)),
                      child: LargeSearchField(
                        controller: ref.watch(searchValueProvider),
                        hintText: 'Search By Product Name',
                        outline: true,
                        onChanged: (value){
                          print("the new value is: ${ref.watch(searchValueProvider)}");
                          ref.refresh(filteredProductsProvider);
                        },
                      ),
                    ),
                    selectedDistributor!=null?selectedDistributor!.id != 1?ref.watch(filteredProductsProvider).when(
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
                                              "${data[index]
                                                  .productName
                                                  .toString()}",
                                              style: Styles.normalText(context)),
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
                                              // if(int.parse(value) > data[index].stock!){
                                              //
                                              // }
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
                        }):SizedBox():SizedBox(),
                   
                   
                   
                   

                   selectedDistributor!=null && selectedDistributor!.id == 1
                       ?selectedWarehouse==null?Center(child: Text("Select a warehouse", style: Styles.heading4(context),)):ref.watch(warehouseProductsProvider(selectedWarehouse!.warehouseCode!)).when(
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

                                  return  StockLiftItem(productsModel: data[index]);
                                }),
                          );
                        }, error: (error, stackTrace) {
                          print(stackTrace);
                          return Text(error.toString(), style: Styles.heading3(context).copyWith(color: Colors.red),);
                    },
                        loading: (){
                          return Center(child: SizedBox(height:20, width:20,child: CircularProgressIndicator(strokeWidth: 2,color: Styles.appSecondaryColor,)));
                        }):SizedBox()
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
                }else if(selectedDistributor == null){
                  showCustomSnackBar("Select a distributor", isError: true);
                }
                else{
                  Get.to(ConfirmStockLift(distributorId: selectedDistributor!.id.toString(), warehouseCode: selectedWarehouse == null?"0":selectedWarehouse!.warehouseCode!));
                }

              },
              text: "Confirm StockLift",
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
        )
    );
  }
}

// //Implementation

class StockLiftItem extends ConsumerStatefulWidget {
  final ProductsModel productsModel;
  const StockLiftItem({Key? key, required this.productsModel}) : super(key: key);

  @override
  ConsumerState<StockLiftItem> createState() => _StockLiftItemState();
}

class _StockLiftItemState extends ConsumerState<StockLiftItem> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                "${widget.productsModel
                    .productName
                    .toString()}",
                style: Styles.normalText(context)),
          ),
          // Text(
          //     data[index]
          //         .skuCode
          //         .toString(),
          //     style:
          //     Styles.heading4(context)),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text("(${widget.productsModel.stock.toString()})", style: Styles.heading4(context).copyWith(color: Colors.blue),),
              ),

              Container(
                width: 50,
                height: 30,
                child: TextFormField(
                  controller: controller,
                  onChanged: (String value){
                    // print("controller text: ${textEditingController.text}");
                    print(value);
                    print(widget.productsModel.productName);
                    // if(int.parse(value) > data[index].stock!){
                    //
                    // }
                    if(int.parse(value) > widget.productsModel.stock!){
                      controller.clear();
                      showCustomSnackBar("Selected quantity not available",bgColor: Colors.blue, isError: true);
                    }else{
                      if(int.parse(value) > 0){
                        var cartData = NewSalesCart(
                            productMo: widget.productsModel,
                            qty: int.parse(value),
                            price:  widget.productsModel.wholesalePrice!

                        );
                        print("the data is ${cartData.productMo}, ${cartData.qty}");
                        ref.watch(addStockLiftNotifier.notifier).addStockLiftCart(cartData);
                        print("value");
                      }
                    }
                  },
                  textAlign: TextAlign.center,
                  cursorHeight: 15,
                  cursorColor: Styles.appPrimaryColor,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 1,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Styles.appPrimaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Styles
                              .appPrimaryColor),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          )
        ],
      ),
    );;
  }
}


