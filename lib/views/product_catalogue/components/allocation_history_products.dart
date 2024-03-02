import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/models/allocation_history_model/allocations_model.dart';
import 'package:soko_flow/models/latest_allocations_model/latest_allocated_items_model.dart';
import 'package:soko_flow/models/requisitions/requisition_products.dart';
import 'package:soko_flow/views/customers/order_details/order_details.dart';
import 'package:soko_flow/widgets/cards/customer_list_card.dart';

class AllocationHistoryProductList extends StatefulWidget {
  final List<RequisitionProducts> requisitionProducts;
  final RequisitionModel requisition;

  const AllocationHistoryProductList({Key? key, required this.requisitionProducts, required this.requisition}) : super(key: key);



  @override
  State<AllocationHistoryProductList> createState() => _AllocationHistoryProductListState();
}

class _AllocationHistoryProductListState extends State<AllocationHistoryProductList> {


  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Approved Items", style: Styles.heading3(context).copyWith(color: Styles.appSecondaryColor),),
          Card(
              child: Container(

                child: Column(

                  children: [
                    Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding(context),
                              vertical: defaultPadding(context) / 2),

                          child: Column(
                            children: [
                              Table(
                                columnWidths: {
                                  0: FractionColumnWidth(0.5),
                                  1: FractionColumnWidth(0.30),
                                  2: FractionColumnWidth(0.10),
                                  3: FractionColumnWidth(0.20),
                                },
                                children: [
                                  buildRow([
                                    IntrinsicHeight(child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Product", style: Styles.heading3(context),),

                                        VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                      ],
                                    )),
                                    // IntrinsicHeight(
                                    //     child:Row(
                                    //
                                    //       mainAxisAlignment: MainAxisAlignment.start,
                                    //       children: <Widget>[
                                    //         VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                    //         Container(
                                    //             width: 50,
                                    //             child: Center(child: Text('Sku', style: Styles.heading3(context),))),
                                    //         VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                    //       ],
                                    //     )),
                                    Text("Qty", style: Styles.heading3(context),),
                                  ]),
                                ],
                              ),
                              Divider(thickness: 1,),
                              Table(
                                  columnWidths: {
                                    0: FractionColumnWidth(0.5),
                                    1: FractionColumnWidth(0.30),
                                    2: FractionColumnWidth(0.10),
                                    3: FractionColumnWidth(0.20),
                                  },
                                  children: widget.requisitionProducts.map((e) =>  buildRow(
                                      [
                                        IntrinsicHeight(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                  width:MediaQuery.of(context).size.width *.3,
                                                  child: Text(e.productName!.toString(), style: Styles.smallGreyText(context),)),
                                              VerticalDivider(color: Colors.grey.shade400, thickness: 2,),

                                            ],
                                          ),
                                        ),
                                        VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                        Text(e.quantity!.toString(), style: Styles.smallGreyText(context))
                                        // Text(e.stockRequisitionId!.toString(), style: Styles.smallGreyText(context)),
                                      ]
                                  )).toList()
                              ),
                              SizedBox(height: 20,),


                            ],
                          ),
                        )),
                    Container(
                      height: 1,
                      color: Colors.grey.withOpacity(.5),
                    ),


                  ],
                ),
              )),
          // Text("DisApproved Items", style: Styles.heading3(context).copyWith(color: Styles.appSecondaryColor),),
          // Card(
          //     child: Container(
          //
          //       child: Column(
          //         children: [
          //           Card(
          //               child: Container(
          //                 padding: EdgeInsets.symmetric(
          //                     horizontal: defaultPadding(context),
          //                     vertical: defaultPadding(context) / 2),
          //
          //                 child: Column(
          //                   children: [
          //                     Table(
          //                       columnWidths: {
          //                         0: FractionColumnWidth(0.5),
          //                         1: FractionColumnWidth(0.30),
          //                         2: FractionColumnWidth(0.10),
          //                         3: FractionColumnWidth(0.20),
          //                       },
          //                       children: [
          //                         buildRow([
          //                           IntrinsicHeight(child: Row(
          //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                             children: [
          //                               Text("Product", style: Styles.heading3(context),),
          //
          //                               VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
          //                             ],
          //                           )),
          //                           // IntrinsicHeight(
          //                           //     child:Row(
          //                           //
          //                           //       mainAxisAlignment: MainAxisAlignment.start,
          //                           //       children: <Widget>[
          //                           //         VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
          //                           //         Container(
          //                           //             width: 50,
          //                           //             child: Center(child: Text('Sku', style: Styles.heading3(context),))),
          //                           //         VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
          //                           //       ],
          //                           //     )),
          //                           Text("Qty", style: Styles.heading3(context),),
          //                         ]),
          //                       ],
          //                     ),
          //                     Divider(thickness: 1,),
          //                     Table(
          //                         columnWidths: {
          //                           0: FractionColumnWidth(0.5),
          //                           1: FractionColumnWidth(0.30),
          //                           2: FractionColumnWidth(0.10),
          //                           3: FractionColumnWidth(0.20),
          //                         },
          //                         children: widget.requisitionProducts.where((element) => element.approved == false).map((e) =>  buildRow(
          //                             [
          //                               IntrinsicHeight(
          //                                 child: Row(
          //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                                   children: [
          //                                     SizedBox(
          //                                         width:MediaQuery.of(context).size.width *.3,
          //                                         child: Text(e.productName!.toString(), style: Styles.smallGreyText(context),)),
          //                                     VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
          //
          //                                   ],
          //                                 ),
          //                               ),
          //                               VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
          //                               Text(e.quantity!.toString(), style: Styles.smallGreyText(context))
          //                               // Text(e.stockRequisitionId!.toString(), style: Styles.smallGreyText(context)),
          //                             ]
          //                         )).toList()
          //                     ),
          //                     SizedBox(height: 20,),
          //
          //
          //                   ],
          //                 ),
          //               )),
          //           Container(
          //             height: 1,
          //             color: Colors.grey.withOpacity(.5),
          //           ),
          //
          //
          //         ],
          //       ),
          //     )),
        ],
      )
    );
  }

  final List<Map> mycustomers = [
    {
      'productName': 'Drinking Water',
      'types': {
        'data': [
          {'name': 'Dasani', 'quantity': '1L', 'price': 'KSH 110'},
          {'name': 'Quencher', 'quantity': '500ML', 'price': 'Ksh 46'},
          {'name': 'Highlands', 'quantity': '1L', 'price': 'KSH 67'},
          {'name': 'Waba 5L', 'quantity': '5L', 'price': 'KSH 250'},
        ]
      }
    },
    {
      'productName': 'Soda',
      'types': {
        'data': [
          {'name': 'Coca Cola', 'quantity': '500ML', 'price': 'KSH 56'},
          {'name': 'Sprite', 'quantity': '1L', 'price': 'Ksh 70'},
          {'name': 'Fanta Orange', 'quantity': '1L', 'price': 'KSH 70'},
          {'name': 'Fanta Passion', 'quantity': '500ML', 'price': 'KSH 56'},
          {'name': 'Fanta Blackcurrant', 'quantity': '1L', 'price': 'KSH 70'},
          {'name': 'Fanta Watermelon', 'quantity': '1L', 'price': 'KSH 70'},
          {'name': 'Stoney', 'quantity': '500ML', 'price': 'KSH 56'},
          {'name': 'Krest', 'quantity': '500ML', 'price': 'KSH 56'},
        ]
      }
    },
    {
      'productName': 'Energy Drink',
      'types': {
        'data': [
          {'name': 'Monster', 'quantity': '250ML', 'price': 'KSH 240'},
          {'name': 'Redbull', 'quantity': '250ML', 'price': 'Ksh 180'},
          {'name': 'Power', 'quantity': '250ML', 'price': 'KSH 130'},
          {'name': 'Sunlight', 'quantity': '250ML', 'price': 'KSH 123'},
        ]
      }
    },
    {
      'productName': 'Alcohol(Beer)',
      'types': {
        'data': [
          {'name': 'Heineken', 'quantity': '500ML', 'price': 'KSH 180'},
          {'name': 'Whitecap', 'quantity': '500ML', 'price': 'Ksh 185'},
          {'name': 'Guiness', 'quantity': '500ML', 'price': 'KSH 160'},
          {'name': 'Balozi', 'quantity': '500ML', 'price': 'KSH 140'},
        ]
      }
    },
    {
      'productName': 'Juice',
      'types': {
        'data': [
          {'name': 'Heineken', 'quantity': '500ML', 'price': 'KSH 180'},
          {'name': 'Whitecap', 'quantity': '500ML', 'price': 'Ksh 185'},
          {'name': 'Guiness', 'quantity': '500ML', 'price': 'KSH 160'},
          {'name': 'Balozi', 'quantity': '500ML', 'price': 'KSH 140'},
        ]
      }
    },
  ];

  final List monthsList = const [
    {'1', "January"},
    {'2', "Feb"},
    {'3', "March"},
    {'4', "April"},
    {'5', "May"},
    // {"name": "All", "icon": "assets/icons/a.png"},
    // {"name": "Past 1 Month", "icon": "assets/icons/b.png"},
    // {"name": "Last 3 Months", "icon": "assets/icons/f.png"},
    // {"name": "Last 6 Months", "icon": "assets/icons/g.png"},
    // {"name": "1 year", "icon": "assets/icons/c.png"},
  ];
}



