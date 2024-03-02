
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/controllers/product_category_controller.dart';
import 'package:soko_flow/controllers/product_controller.dart';
import 'package:soko_flow/controllers/reconcile_controller.dart';
import 'package:soko_flow/controllers/stocklift_controller.dart';
import 'package:soko_flow/data/providers/add_stock_lift_provider.dart';
import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';
import 'package:soko_flow/models/distributors_model.dart';
import 'package:soko_flow/models/latest_allocations_model/latest_allocated_items_model.dart';
import 'package:soko_flow/models/wawrehouse_model/warehouses_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/views/customers/sales/components/quantity_input.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/reconcile/confirm_reconcile_items.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/reconcile/reconcile.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
Logger _log = Logger(printer: PrettyPrinter());

class ReconcileItems extends ConsumerStatefulWidget {
  const ReconcileItems({Key? key}) : super(key: key);

  @override
  ConsumerState<ReconcileItems> createState() => _ReconcileItemsState();
}

class _ReconcileItemsState extends ConsumerState<ReconcileItems>  with AutomaticKeepAliveClientMixin<ReconcileItems> {
  late TabController _tabController;
  int initPosition = 0;
  List<String> options = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();

  var newCategoryID;
  // List<String> _distributors = ["Select Distributor", 'Thika Distributors', 'Kamau Distributors', 'Njooro Distributors', 'D'];
  // String _selectedDistributor = "Select Distributor";
  // final _debouncer = Debouncer(milliseconds: 500);
  getReconcileItems()async{
    await Get.find<ReconcileController>().getCashReconcile();
    await Get.find<StockHistoryController>().getLatestAllocations(true);
    Get.find<StockHistoryController>().lstLatestAllocations.forEach((element) {
      Get.find<ReconcileController>().addVanSalesCart(
          ReconcileCart(
              latestAllocationModel: element,
              qty: int.parse(element.allocatedQty!),
              supplierId: Get.find<ReconcileController>().selectedDistributor.id.toString()
          )
      );
    });
  }

  @override
  void initState() {
    getReconcileItems();

    super.initState();
  }
  @override
  bool get wantKeepAlive => true;
  WarehouseModel? selectedWarehouse;
  DistributorsModel? selectedDistributor;



  @override
  Widget build(BuildContext context) {
    // _log.e(Get.find<ProductCategoryController>().productCategoryList.length);
    // _log.e(Get.find<ProductController>().productList.length);
    // _log.e("Length of categories" + options.length.toString());
    return Scaffold(
        key: scaffoldKey,
        body: GetBuilder<ReconcileController>(builder: (reconcileController) {
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
                            'Reconcile',
                            style: Styles.heading2(context),
                          ),
                        ),
                        // Align(
                        //   alignment: Alignment.topRight,
                        //   child: Material(
                        //     child: InkWell(
                        //       splashColor: Theme.of(context).splashColor,
                        //       onTap: () => Get.offNamed(RouteHelper.getInitial()),
                        //       child: Icon(
                        //         Icons.home_sharp,
                        //         size: defaultPadding(context) * 2,
                        //         color: Styles.appPrimaryColor,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

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
                            selectedWarehouse = data[0];
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
                                  onChanged: (WarehouseModel? newValue) {
                                    print("changed: ${newValue!.name}");
                                    print(newValue);
                                    selectedWarehouse = newValue;
                                    // stockLiftController.getDistributorProducts();
                                    setState(() {});
                                    ref.refresh(warehouseProductsProvider(selectedWarehouse!.warehouseCode.toString()));

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

                    // _selectedDistributor == "Select Distributor"? Text("Select a distributor", style: Styles.heading2(context),)
                    //     :
                    GetBuilder<StockHistoryController>(
                      builder: (stockHistoryController) {
                        return GetBuilder<ReconcileController>(builder: (reconcileController){
                          return Expanded(
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: reconcileController.reconcileCartList.length,
                                itemBuilder: (_, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:1, vertical: 4 ),
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // SizedBox(
                                        //   width: MediaQuery.of(context).size.width *.4,
                                        //   child: Text(
                                        //       reconcileController.reconcileCartList[index].latestAllocationModel!.productName
                                        //           .toString(),
                                        //       style:
                                        //       Styles.heading4(context)),
                                        // ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * .5,
                                          child: Text(
                                            reconcileController.reconcileCartList[index].latestAllocationModel!.productName
                                                .toString(),
                                              style:
                                              Styles.normalText(context)),
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width *.07,),
                                        Row(
                                          children: [
                                            Container(
                                                width: 50,
                                                height: 25,
                                                child: ReconcileQuantitySmallInput(
                                                  allocations:reconcileController.reconcileCartList[index].latestAllocationModel,
                                                  isReconcile: true,
                                                  price:  reconcileController.reconcileCartList[index].latestAllocationModel!.distributorPrice!,
                                                  // controller: _editingController,
                                                )
                                            ),
                                            SizedBox(width: 8,),
                                            Text(
                                                "Out of ${stockHistoryController.lstLatestAllocations[index].allocatedQty.toString()}",
                                                style: Styles.heading4(context).copyWith(color: Styles.appPrimaryColor)),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          );
                        });
                      }
                    ),
                  ],
                ),
              ));
        }),
          bottomNavigationBar:
          GetBuilder<ReconcileController>(builder: (addToCartController) {
            return Container(
              height: defaultPadding(context) * 7,
              padding: EdgeInsets.only(
                  top: defaultPadding(context) * .7,
                  left: defaultPadding(context) * 1.5,
                  right: defaultPadding(context) * 1.5,
                  bottom: defaultPadding(context)) *1.5,
              child: Column(
                  children: [
                    SizedBox(height: 10,),
                    addToCartController.isLoading == true
                        ? Center(
                        child: Platform.isAndroid
                            ? CircularProgressIndicator(
                            color: Styles.appPrimaryColor)
                            : CupertinoActivityIndicator())
                        : FullWidthButton(
                      action: () {
                        // addToCartController.addToCart();
                        if(selectedDistributor == null){
                          showSnackBar(text: "Select a distributor", bgColor: Colors.blue);
                        }else{
                          Get.to(Reconcile(warehouse: selectedWarehouse == null?"0":selectedWarehouse!.warehouseCode!, distributorId: selectedDistributor!.id.toString(),));

                        }
                      },
                      text: "Next",
                    ),
                  ]),
            );
          }),

    );
  }
}

class ReconcileQuantitySmallInput extends StatefulWidget {
  final String price;
  const ReconcileQuantitySmallInput({Key? key,this.allocations, this.isReconcile, required this.price}) : super(key: key);

  final LatestAllocationModel? allocations;
  final bool? isReconcile;

  @override
  State<ReconcileQuantitySmallInput> createState() => _ReconcileQuantitySmallInputState();
}

class _ReconcileQuantitySmallInputState extends State<ReconcileQuantitySmallInput> {
  TextEditingController? controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if(widget.isReconcile!){
      controller!.text = widget.allocations!.allocatedQty!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: (String value){
        // print("controller text: ${textEditingController.text}");

        print(value);
        // print(stockHistoryController.lstLatestAllocations[index].productName);

        if(int.parse(value) >= 0){
          if(int.parse(value) > int.parse(widget.allocations!.allocatedQty!.toString())){
            print("greater");
            Fluttertoast.showToast(
                msg: "Quantity cannot be more than ${widget.allocations!.allocatedQty}",
                textColor: Colors.white,
                toastLength: Toast.LENGTH_LONG,
                webPosition: 'top',
                gravity: ToastGravity.TOP,
                backgroundColor:Colors.redAccent
            );


            controller!.text = widget.allocations!.allocatedQty!.toString();
          }else{
            var data = ReconcileCart(
                latestAllocationModel: widget.allocations,
                qty: int.parse(value),
                // price: int.parse(widget.price)
            );
            print("the data is ${data.latestAllocationModel}, ${data.qty}");
            Get.find<ReconcileController>().addVanSalesCart(data);
            print("value");
          }

        }
        // _debouncer.run(() {
        //   print(value);
        // });
      },
      textAlign: TextAlign.center,
      cursorHeight: 15,
      cursorColor:
      Styles.appSecondaryColor,
      decoration: InputDecoration(
        contentPadding:
        EdgeInsets.symmetric(
          vertical: 1,
          horizontal: 0,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey),
        ),
        focusedBorder:
        OutlineInputBorder(
          borderSide: BorderSide(
              color: Styles
                  .appSecondaryColor),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }
}

