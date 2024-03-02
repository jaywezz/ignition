import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';
import 'package:soko_flow/configs/constants.dart';

import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/orders_controller.dart';
import 'package:soko_flow/controllers/payment_controller.dart';
import 'package:soko_flow/data/providers/reconciloations_provider.dart';
import 'package:soko_flow/logic/routes/routes.dart';
import 'package:soko_flow/models/order_history_model.dart';
import 'package:soko_flow/models/reconcile/reconciliations_list_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/components/order_list.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/reconcile/reconcile_details_screen.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/reconcile/reconcile_products.dart';
import 'package:soko_flow/widgets/customer_search_widget.dart';
import 'package:soko_flow/widgets/inputs/search_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UserReconciliations extends ConsumerStatefulWidget {
  const UserReconciliations({Key? key}) : super(key: key);

  @override
  ConsumerState<UserReconciliations> createState() => _UserReconciliationsState();
}

class _UserReconciliationsState extends ConsumerState<UserReconciliations> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  TextEditingController searchControlller = TextEditingController();

  // final OrdersController ordersController = Get.put(OrdersController(widget.customer_id!));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.appSecondaryColor,
        child: Icon(Icons.add),
        onPressed: (){
          Get.to(ReconcileItems());
        },
      ),
      body: SafeArea(
        child: SizedBox(
        height: double.infinity,
        width: double.infinity,

        //color: Styles.appBackgroundColor,
        child: Container(
          padding: EdgeInsets.only(
            left: defaultPadding(context),
            right: defaultPadding(context),
          ),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
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
                      'Reconciliations',
                      style: Styles.heading3(context),
                    ),
                  ),
                  
                ],
              ),
              SizedBox(
                height: defaultPadding(context) * 1.3,
              ),
              LargeSearchField(
                controller:searchControlller,
                onChanged: (value) {
                  setState(() {});
                },
                hintText: 'Search warehouse/Distributor',
                outline: true,
              ),
              ref.watch(reconciliationsProvider).when(
                  data: (data){
                    if(searchControlller.text != ""){
                      data = data.where((element) => element.warehouseName!.toLowerCase().contains(searchControlller.text.toLowerCase())).toList();
                    }
                    return Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            return ref.refresh(reconciliationsProvider);
                          },
                          child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: ((context, index) {
                                return Padding(padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    child:data[index].status == "waiting_approval"?PendingReconcileCard(context, data[index]): AcceptedReconcileCard(context,data[index] ));
                              })),
                        ));
                  },
                  error: (e,s){
                    print(s);
                    return Text("An error occurred getting reconciliations : $s", style: Styles.heading4(context).copyWith(color: Colors.red),);
                  }, loading: (){
                return Center(child: CircularProgressIndicator(),);
              })
            ],
          ),
        ),
      )
      ),
    );
  }

  Widget AcceptedReconcileCard(BuildContext context, ReconciliationListModel reconcile) {
    return GestureDetector(
      onTap: () {
        Get.to(ReconcileDetails(reconcile: reconcile));
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            reconcile.warehouseName??"None",
                            style: Styles.heading3(context),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Text(
                            "Status : ",
                            style: Styles.smallGreyText(context)
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            reconcile.status!,
                            style: Styles.heading4(context)
                                .copyWith(color: Colors.green),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Reconcile Amount: ${reconcile.total}",
                        style: Styles.heading3(context).copyWith(
                            fontWeight: FontWeight.w600, color: Colors.green),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat.yMMMEd().format(reconcile.createdAt!),
                    style: Styles.heading3(context),
                  ),
                ],
              ),
            ],
          ),
        ),
        width: Responsive.isMobile(context) ? 250 : 350,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(defaultPadding(context))),
      ),
    );
  }

  Widget PendingReconcileCard(BuildContext context, ReconciliationListModel reconcile) {
    return GestureDetector(
      onTap: () {
        Get.to(ReconcileDetails(reconcile: reconcile));
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            reconcile.warehouseName??"None",
                            style: Styles.heading3(context),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Text(
                            "Status : ",
                            style: Styles.smallGreyText(context)
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            reconcile.status!,
                            style: Styles.heading4(context)
                                .copyWith(color: Colors.black54),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Reconcile Amount: ${reconcile.total}",
                        style: Styles.heading3(context).copyWith(
                            fontWeight: FontWeight.w600, color: Colors.black54),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat.yMMMEd().format(reconcile.createdAt!),
                    style: Styles.heading3(context),
                  ),
                ],
              ),
            ],
          ),
        ),
        width: Responsive.isMobile(context) ? 250 : 350,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            // border: Border.all(color: Colors.grey[200]),
            borderRadius: BorderRadius.circular(defaultPadding(context))),
      ),
    );
  }



  // Widget RejectedReconcileCard(BuildContext context, OrdersModel order) {
  //   return GestureDetector(
  //     onTap: () {
  //       Get.toNamed(RouteHelper.orderDetailsScreen(), arguments: {
  //         "orderCode": order.orderCode,
  //         "customer_id": order.customerId,
  //         "distributor": order.distributor
  //       });
  //     },
  //     child: Container(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14),
  //         child: Column(
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Text(
  //                           order.customer!.customerName!,
  //                           style: Styles.heading3(context),
  //                         ),
  //                         SizedBox(
  //                           width: 10,
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: 6,
  //                     ),
  //                     Text(
  //                       "Distributor:  ${order.distributor == null ?"None":order.distributor!.name}",
  //                       style: Styles.smallGreyText(context).copyWith(
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                     Text(
  //                       "Payment Status : Partial",
  //                       style: Styles.smallGreyText(context)
  //                           .copyWith(fontWeight: FontWeight.w600),
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                     Text(
  //                       "Total: ${order.priceTotal.toString()}",
  //                       style: Styles.heading3(context).copyWith(
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Column(
  //                   children: [
  //                     Padding(
  //                       padding: EdgeInsets.symmetric(horizontal: 10.0.sp),
  //                       child: Container(
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(1.0),
  //                           child: order.orderStatus == "CANCELLED"
  //                               ? Text(
  //                             "Cancelled",
  //                             style: Styles.heading4(context)
  //                                 .copyWith(color: Colors.redAccent),
  //                           )
  //                               : order.orderStatus == "Partial delivery"
  //                               ? Text(
  //                             "Partial",
  //                             style: Styles.heading4(context).copyWith(
  //                                 color: Styles.appSecondaryColor),
  //                           )
  //                               : order.orderStatus == "DELIVERED"
  //                               ? Text(
  //                             "Delivered",
  //                             style: Styles.heading4(context)
  //                                 .copyWith(color: Colors.white),
  //                           ) : order.orderStatus == "Not Delivered"
  //                               ? Text(
  //                               "Not Delivered",
  //                               style: Styles.heading4(context).copyWith(color: Colors.white))
  //                               :Text(
  //                             "Pending",
  //                             style: Styles.heading4(context)
  //                                 .copyWith(color: Colors.grey),
  //                           ),
  //                         ),
  //                         decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.all(Radius.circular(5.sp)),
  //                             color: order.orderStatus == "CANCELLED"
  //                                 ? Colors.redAccent.withOpacity(.3)
  //                                 : order.orderStatus == "Partial delivery"
  //                                 ? Styles.appSecondaryColor.withOpacity(.3)
  //                                 : order.orderStatus == "DELIVERED"
  //                                 ? Colors.green
  //                                 : order.orderStatus == "Not Delivered"?Colors.red:Colors.grey.withOpacity(.3)),
  //                       ),
  //                     ),
  //                     SizedBox(height: 10,),
  //                     Text(
  //                       DateFormat.yMMMd().format(order.createdAt!),
  //                       style: Styles.heading4(context).copyWith(color: Colors.black54),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             // IconButton(icon: Icon(Icons.delete, color: Colors.grey, size: 20,),onPressed: (){
  //             //
  //             // })
  //           ],
  //         ),
  //       ),
  //       width: Responsive.isMobile(context) ? 250 : 350,
  //       decoration: BoxDecoration(
  //           color: Styles.appYellowColor.withOpacity(.2),
  //           borderRadius: BorderRadius.circular(defaultPadding(context))),
  //     ),
  //   );
  // }
}

