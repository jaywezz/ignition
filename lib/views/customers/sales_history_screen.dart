import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';
import 'package:soko_flow/configs/constants.dart';

import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/orders_controller.dart';
import 'package:soko_flow/logic/routes/routes.dart';
import 'package:soko_flow/models/order_history_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/components/order_list.dart';
import 'package:soko_flow/views/customers/order_history_screen.dart';
import 'package:soko_flow/widgets/inputs/search_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../errors/empty_failure_no_internet_view.dart';
import '../../widgets/cards/customer_list_card.dart';

class SalesHistoryScreen extends StatefulWidget {

  const SalesHistoryScreen({Key? key}) : super(key: key);


  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  final customer_id = Get.arguments["customer_id"];
  final  customer_name= Get.arguments["customer_name"];
  String selectedDateRange = "";
  List<DateTime> dateRange = [];
  String paymentTypeFilter = "";

  List months =
  ['January', 'February', 'March', 'April', 'May','June','July','August','September','October','November','December'];

  @override
  void initState() {
    // TODO: implement initState
    Get.find<OrdersController>().getVanOrders(customer_id.toString());
    super.initState();
  }

  // final OrdersController ordersController = Get.put(OrdersController(widget.customer_id!));
  @override
  Widget build(BuildContext context) {
    print('customer id : ${customer_id}');
    print("customer id on orders screen");
    print(customer_id);
    return Scaffold(

      body: SafeArea(
        child: GetBuilder<OrdersController>(builder: (orderController) {
          List<OrdersModel> vanSales = [];
          if(dateRange.isNotEmpty){
            vanSales =orderController.lstVanSales
                .where((item) => item.createdAt!.isAfter(dateRange[0]) &&
                item.createdAt!.isBefore(dateRange[1]))
                .toList();

          }else{
            vanSales = orderController.lstVanSales;
          }
          if(paymentTypeFilter != ""){
            vanSales = vanSales.where((element) => element.paymentStatus == paymentTypeFilter).toList();
          }
          vanSales = vanSales.reversed.toList();
          return SizedBox(
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
                          '${customer_name} Van Sales',
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

                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Filter By: ", style: Styles.heading3(context),)),
                  SizedBox(
                    height: defaultPadding(context) * 1.3,
                  ),
                  SizedBox(
                    height: 30,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [

                        // Row(
                        //   children: [
                        //
                        //     GestureDetector(
                        //       onTap: (){
                        //         Get.dialog(
                        //             MethodPayments()
                        //         );
                        //
                        //       },
                        //       child: Padding(
                        //         padding: const EdgeInsets.only(right: 8.0),
                        //         child: Container(
                        //           child: Padding(
                        //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        //             child: Row(
                        //               children: [
                        //                 orderController.paymentMethod  == FilterPaymentMethods.PaymentMethod
                        //                     ?Text("Payment Method", style: Styles.heading3(context),)
                        //                     :orderController.paymentMethod  == FilterPaymentMethods.Mpesa
                        //                     ? Text("M-pesa", style: Styles.heading3(context).copyWith(color: Colors.white),)
                        //                     : orderController.paymentMethod  == FilterPaymentMethods.Cash
                        //                     ? Text("Cash", style: Styles.heading3(context).copyWith(color: Colors.white),)
                        //                     : orderController.paymentMethod  == FilterPaymentMethods.Cheque
                        //                     ?Text("Cheque", style: Styles.heading3(context).copyWith(color: Colors.white),):Text(""),
                        //                 SizedBox(width: 6,),
                        //                 orderController.paymentMethod  == FilterPaymentMethods.PaymentMethod
                        //                     ?Icon(Icons.keyboard_arrow_down, color: Colors.black,)
                        //
                        //                     :InkWell(
                        //                     onTap: (){
                        //                       print("press");
                        //                       orderController.paymentMethod = FilterPaymentMethods.PaymentMethod;
                        //                       orderController.update();
                        //                     },
                        //                     child: Icon(Icons.close, color: Styles.appYellowColor,))
                        //               ],
                        //             ),
                        //           ),
                        //           decoration: BoxDecoration(
                        //               color: orderController.paymentMethod  == FilterPaymentMethods.PaymentMethod?Colors.white54: Styles.appPrimaryColor,
                        //               border: Border.all(color:orderController.paymentMethod  == FilterPaymentMethods.PaymentMethod
                        //                   ? Styles.appYellowColor:Colors.transparent, width: 2),
                        //               borderRadius: BorderRadius.circular(30)
                        //           ),
                        //
                        //         ),
                        //       ),
                        //     ),
                        //
                        //
                        //   ],
                        // ),
                        PopupMenuButton<int>(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              // row has two child icon and text
                              child: Row(
                                children: [
                                  Text("Paid")
                                ],
                              ),
                            ),
                            // popupmenu item 1
                            PopupMenuItem(
                              value: 2,
                              // row has two child icon and text.
                              child: Row(
                                children: [
                                  Text("Partial Payment")
                                ],
                              ),
                            ),
                            // popupmenu item 2
                            PopupMenuItem(
                              value: 3,
                              // row has two child icon and text
                              child: Row(
                                children: [
                                  Text("Not Paid")
                                ],
                              ),
                            ),
                          ],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Text(paymentTypeFilter == ""?"Payment Status":"${paymentTypeFilter}", style: Styles.heading3(context).copyWith(color: Colors.black),),
                                    Icon(Icons.keyboard_arrow_down, color: Colors.black,)
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                  // color: Styles.appPrimaryColor,
                                  border: Border.all(color: Styles.appPrimaryColor, width: 2),
                                  borderRadius: BorderRadius.circular(30)
                              ),

                            ),
                          ),
                          offset: Offset(0, 30),
                          color: Colors.white,
                          elevation: 2,
                          onSelected: (value){
                            if(value == 1){
                              setState(() {
                                paymentTypeFilter = "PAID";
                              });
                            }
                            if(value == 2){
                              setState(() {
                                paymentTypeFilter = "PARTIAL PAID";
                              });
                            }
                            if(value == 3){
                              setState(() {
                                paymentTypeFilter = "Pending Payment";
                              });
                            }
                          },
                        ),
                        GestureDetector(
                          onTap: ()async{
                            showDialog(context: context, builder: (BuildContext context){
                              return AlertDialog(
                                content:  SizedBox(
                                  height: MediaQuery.of(context).size.height *.45,
                                  width: MediaQuery.of(context).size.width * .8,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Select Date Range",
                                        style: Styles.heading2(context),
                                      ),
                                      SfDateRangePicker(
                                        monthCellStyle:
                                        DateRangePickerMonthCellStyle(
                                            textStyle: Styles.heading4(context)
                                                .copyWith(
                                                fontWeight:
                                                FontWeight.w700)),
                                        onSelectionChanged: (DateRangePickerSelectionChangedArgs args){
                                          print("start '${args.value.startDate}");
                                          print("end '${args.value.endDate ?? args.value.startDate}");
                                          setState(() {
                                            dateRange = [args.value.startDate, args.value.endDate ?? args.value.startDate];
                                            selectedDateRange = "${DateFormat.yMd().format(dateRange[0])} - ${DateFormat.yMd().format(dateRange[1])}";
                                          });
                                        },
                                        selectionMode:
                                        DateRangePickerSelectionMode.range,
                                      ),
                                      Divider(
                                        color: Colors.grey[200],
                                        thickness: 2,
                                      ),
                                      // Text("Time", style: Styles.heading3(context),),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      'Ok',
                                      style: Styles.heading3(context).copyWith(color:Styles.appPrimaryColor),
                                    ),
                                  ),

                                ],
                              );
                            });

                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    orderController.filterDateSold.isEmpty
                                        ?Text(dateRange.isNotEmpty?selectedDateRange:"Date Sold", style: Styles.heading3(context),)
                                        :Text(orderController.filterDateSold, style: Styles.heading3(context).copyWith(color: Colors.white),),
                                    SizedBox(width: 6,),
                                    !orderController.filterDateSold.isEmpty?InkWell(
                                        onTap: (){
                                          print("press");
                                          orderController.filterDateSold = "";
                                          orderController.update();
                                        },
                                        child: Icon(Icons.close, color: Styles.appYellowColor,))
                                        :Icon(Icons.keyboard_arrow_down)
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: orderController.filterDateSold.isEmpty?Colors.white54:Styles.appPrimaryColor,
                                  border: Border.all(color:  orderController.filterDateSold.isEmpty?Styles.appYellowColor:Colors.transparent, width: 2),
                                  borderRadius: BorderRadius.circular(30)
                              ),

                            ),
                          ),
                        ),

                        SizedBox(width: 10.w,),
                        TextButton(onPressed: (){
                          setState(() {
                            dateRange = [];
                            selectedDateRange = "";
                            paymentTypeFilter = "";
                          });

                        }, child: Text("Clear All", style: Styles.heading3(context).copyWith(color: Colors.blue),))

                      ],
                    ),
                  ),

                  SizedBox(height: 20,),
                  Expanded(
                      child: orderController.isLoading? Center(child: CircularProgressIndicator())
                          :vanSales.isEmpty? RefreshIndicator(
                            onRefresh: ()async{
                              return await orderController.getVanOrders(customer_id.toString());
                            },
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                            child: Text("No Van Sales made", style: Styles.heading3(context).copyWith(color: Colors.black45),)),
                          ):RefreshIndicator(
                            onRefresh: ()async{
                              return await orderController.getVanOrders(customer_id.toString());
                            },
                            child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: vanSales.length,
                            itemBuilder: ((context, index) {
                              print("date: ${vanSales[index].createdAt}");
                              return  Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: vanSales[index].paymentStatus == "Pending Payment"
                                      ?PendingPaymentCard(context, vanSales[index])
                                      : vanSales[index].paymentStatus == "PAID"
                                      ? PaidPaymentCard(context, vanSales[index])
                                      : vanSales[index].paymentStatus == "PARTIAL PAID"
                                      ?PartialPaymentCard(context, vanSales[index]): SizedBox()
                              );

                            })),
                          )
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget PaidPaymentCard(BuildContext context, OrdersModel order){
    return  GestureDetector(
      onTap: (){
        Get.toNamed(RouteHelper.orderDetailsScreen(), arguments: {
          "orderCode": order.orderCode,
          "customer_id": Get.arguments['customer_id'].toString()
        });
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
                          Text("${DateFormat.yMMMd().format(order.createdAt!)}",
                            style: Styles.heading3(context),
                          ),
                          SizedBox(width: 10,),
                        ],
                      ),
                      SizedBox(height: 6,),
                      Row(
                        children: [
                          Text(
                            "Payment Method : ",
                            style: Styles.smallGreyText(context).copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Cash",
                            style: Styles.heading4(context).copyWith(color: Styles.appPrimaryColor),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Payment Status : ",
                            style: Styles.smallGreyText(context).copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Paid",
                            style: Styles.heading4(context).copyWith(color: Styles.appPrimaryColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),

                      Text(
                        "Total: ${order.priceTotal}" ,
                        style: Styles.heading3(
                            context).copyWith(fontWeight: FontWeight.w600, color: Styles.appPrimaryColor),
                      ),

                    ],
                  ),
                  Row(
                    children: <Widget>[
                      TextButton(
                          onPressed: (){
                            Get.toNamed(RouteHelper.orderDetailsScreen(), arguments: {
                              "orderCode": order.orderCode,
                              "customer_id": Get.arguments['customer_id'].toString()
                            });
                          },
                          child: Text("View", style: Styles.heading4(context).copyWith(color: Styles.appPrimaryColor),)
                      )
                    ],
                  ),

                ],
              ),
            ],
          ),
        ),
        width: Responsive.isMobile(context) ? 250 : 350,
        decoration: BoxDecoration(
            color: Colors.white,
            border:Border.all(color: Styles.appPrimaryColor),
            borderRadius: BorderRadius.circular(defaultPadding(context))
        ),
      ),
    );
  }
  Widget PendingPaymentCard(BuildContext context, OrdersModel order){
    return  GestureDetector(
      onTap: (){
        Get.toNamed(RouteHelper.orderDetailsScreen(), arguments: {
          "orderCode": order.orderCode,
          "customer_id": Get.arguments['customer_id'].toString()
        });
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
                            "${DateFormat.yMMMd().format(order.createdAt!)}",
                            style: Styles.heading3(context),
                          ),
                          SizedBox(width: 10,),
                        ],
                      ),
                      SizedBox(height: 6,),
                      Text(
                        order.paymentStatus == "Pending Payment"?"Payment Method: None":"Payment Method: Cash" ,
                        style: Styles.smallGreyText(context).copyWith(fontWeight: FontWeight.w600,),
                      ),
                      Text(
                        "Payment Status : Pending",
                        style: Styles.smallGreyText(context).copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10,),

                      Text(
                        "Total: ${order.priceTotal}" ,
                        style: Styles.heading3(
                            context).copyWith(fontWeight: FontWeight.w600,),
                      ),

                    ],
                  ),

                  Row(
                    children: <Widget>[
                      TextButton(
                          onPressed: (){
                            Get.toNamed(RouteHelper.orderDetailsScreen(), arguments: {
                              "orderCode": order.orderCode,
                              "customer_id": Get.arguments['customer_id'].toString()
                            });
                          },
                          child: Text("View", style: Styles.heading4(context).copyWith(color: Colors.black),)
                      )
                    ],
                  ),

                ],
              ),
              // IconButton(icon: Icon(Icons.delete, color: Colors.grey, size: 20,),onPressed: (){
              //
              // })
            ],
          ),
        ),
        width: Responsive.isMobile(context) ? 250 : 350,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(defaultPadding(context))
        ),
      ),
    );
  }
  Widget PartialPaymentCard(BuildContext context, OrdersModel order){
    return  GestureDetector(
      onTap: (){
        Get.toNamed(RouteHelper.orderDetailsScreen(), arguments: {
          "orderCode": order.orderCode,
          "customer_id": Get.arguments['customer_id'].toString()
        });
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
                            "${DateFormat.yMMMd().format(order.createdAt!)}",
                            style: Styles.heading3(context),
                          ),
                          SizedBox(width: 10,),
                        ],
                      ),
                      SizedBox(height: 6,),
                      Text(
                        "Payment Method: Cash" ,
                        style: Styles.smallGreyText(context).copyWith(fontWeight: FontWeight.w600,),
                      ),
                      Text(
                        "Payment Status : Partial",
                        style: Styles.smallGreyText(context).copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10,),

                      Text(
                        "Total: ${order.priceTotal}" ,
                        style: Styles.heading3(
                            context).copyWith(fontWeight: FontWeight.w600,),
                      ),

                    ],
                  ),

                  Row(
                    children: <Widget>[
                      TextButton(
                          onPressed: (){
                            Get.toNamed(RouteHelper.orderDetailsScreen(), arguments: {
                              "orderCode": order.orderCode,
                              "customer_id": Get.arguments['customer_id'].toString()
                            });
                          },
                          child: Text("View", style: Styles.heading4(context).copyWith(color: Colors.black),)
                      )
                    ],
                  ),

                ],
              ),
              // IconButton(icon: Icon(Icons.delete, color: Colors.grey, size: 20,),onPressed: (){
              //
              // })
            ],
          ),
        ),
        width: Responsive.isMobile(context) ? 250 : 350,
        decoration: BoxDecoration(
            color: Styles.appYellowColor.withOpacity(.2),
            borderRadius: BorderRadius.circular(defaultPadding(context))
        ),
      ),
    );
  }
}


