import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/product_category_controller.dart';
import 'package:soko_flow/controllers/product_controller.dart';
import 'package:soko_flow/models/derivery_model.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/components/product_summary_list.dart';
import 'package:soko_flow/widgets/cards/customer_list_card.dart';

class DeliveriesList extends StatefulWidget {
  final List<DeliveryItemModel> orderItems;
  final String deliveryStatus;
  DeliveriesList({Key? key, required this.orderItems, required this.deliveryStatus}) : super(key: key);

  @override
  State<DeliveriesList> createState() => _DeliveriesListState();
}

class _DeliveriesListState extends State<DeliveriesList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                        2: FractionColumnWidth(0.25),
                      },
                      children: [
                        buildRow([
                          Text("Products", style: Styles.heading3(context),),
                          IntrinsicHeight(
                              child:Row(

                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                  Container(
                                      width: 50,
                                      child: Center(child: Text('QTY', style: Styles.heading3(context),))),
                                  VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                ],
                              )),
                          Text("Amount", style: Styles.heading3(context),),
                        ]),
                      ],
                    ),
                    Divider(thickness: 1,),
                    Table(
                        columnWidths: {
                          0: FractionColumnWidth(0.5),
                          1: FractionColumnWidth(0.30),
                          2: FractionColumnWidth(0.25),
                        },
                        children: widget.orderItems.map((e) =>  buildRow(
                            [
                              Text(e.productName!, style: Styles.smallGreyText(context),),
                              IntrinsicHeight(
                                  child:Row(

                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                      Container(
                                          width: 50,
                                          child: Center(child: Text(int.parse(e.allocatedQuantity!).toString(), style: Styles.smallGreyText(context)))),
                                      VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                    ],
                                  )),
                              Text(e.subTotal!, style: Styles.smallGreyText(context)),
                            ]
                        )).toList()
                    ),
                    SizedBox(height: 20,),


                  ],
                ),
              )),
          widget.deliveryStatus == "Partial delivery"?ExpansionTile(
            // key: new Key(_key.toString()),
            iconColor: Styles.appSecondaryColor,
            textColor: Styles.appSecondaryColor,
            controlAffinity:
            ListTileControlAffinity
                .trailing,
            childrenPadding:
            const EdgeInsets.symmetric(
                vertical: 1,
                horizontal: 10),
            expandedCrossAxisAlignment:
            CrossAxisAlignment.end,
            maintainState: false,
            title: Text(
              'Delivered Items',
              style: TextStyle(
                  color: Styles.appSecondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            children: [
              Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal:10,
                        vertical: defaultPadding(context) / 2),

                    child: Column(
                      children: [
                        Table(
                          columnWidths: {
                            0: FractionColumnWidth(0.5),
                            1: FractionColumnWidth(0.30),
                            2: FractionColumnWidth(0.25),
                          },
                          children: [
                            buildRow([
                              Text("Products", style: Styles.heading3(context),),
                              IntrinsicHeight(
                                  child:Row(

                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                      Container(
                                          width: 50,
                                          child: Center(child: Text('QTY', style: Styles.heading3(context),))),
                                      VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                    ],
                                  )),
                              Text("Amount", style: Styles.heading3(context),),
                            ]),
                          ],
                        ),
                        Divider(thickness: 1,),
                        Table(
                            columnWidths: {
                              0: FractionColumnWidth(0.5),
                              1: FractionColumnWidth(0.30),
                              2: FractionColumnWidth(0.25),
                            },
                            children: widget.orderItems.where((element) => (int.parse(element.allocatedQuantity!) - int.parse(element.deliveryQuantity!)) !=0).map((e) =>  buildRow(
                                [
                                  Text(e.productName!, style: Styles.smallGreyText(context),),
                                  IntrinsicHeight(
                                      child:Row(

                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                          Container(
                                              width: 50,
                                              child: Center(child: Text((int.parse(e.deliveryQuantity!)).toString(), style: Styles.smallGreyText(context)))),
                                          VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                        ],
                                      )),
                                  Text((int.parse(e.sellingPrice!) * int.parse(e.deliveryQuantity!)).toString(), style: Styles.smallGreyText(context)),
                                ]
                            )).toList()),
                        SizedBox(height: 20,),


                      ],
                    ),
                  )),
            ],
          ):SizedBox(),
          widget.deliveryStatus == "Partial delivery"?ExpansionTile(
            // key: new Key(_key.toString()),
            iconColor: Styles.appSecondaryColor,
            textColor: Styles.appSecondaryColor,
            controlAffinity:
            ListTileControlAffinity
                .trailing,
            childrenPadding:
            const EdgeInsets.symmetric(
                vertical: 1,
                horizontal: 10),
            expandedCrossAxisAlignment:
            CrossAxisAlignment.end,
            maintainState: false,
            title: Text(
              'Pending Delivery Items',
              style: TextStyle(
                color: Styles.appSecondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            children: [
              Card(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal:10,
                        vertical: defaultPadding(context) / 2),
                    child: Column(
                      children: [
                        Table(
                          columnWidths: {
                            0: FractionColumnWidth(0.5),
                            1: FractionColumnWidth(0.30),
                            2: FractionColumnWidth(0.25),
                          },
                          children: [
                            buildRow([
                              Text("Products", style: Styles.heading3(context),),
                              IntrinsicHeight(
                                  child:Row(

                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                      Container(
                                          width: 50,
                                          child: Center(child: Text('QTY', style: Styles.heading3(context),))),
                                      VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                    ],
                                  )),
                              Text("Amount", style: Styles.heading3(context),),
                            ]),
                          ],
                        ),
                        Divider(thickness: 1,),
                        Table(
                                  columnWidths: {
                                    0: FractionColumnWidth(0.5),
                                    1: FractionColumnWidth(0.30),
                                    2: FractionColumnWidth(0.25),
                                  },
                                  children: widget.orderItems.where((element) => (int.parse(element.allocatedQuantity!) - int.parse(element.deliveryQuantity!)) !=0).map((e) =>  buildRow(
                                      [
                                        Text(e.productName!, style: Styles.smallGreyText(context),),
                                        IntrinsicHeight(
                                            child:Row(

                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                                Container(
                                                    width: 50,
                                                    child: Center(child: Text((int.parse(e.allocatedQuantity!) - int.parse(e.deliveryQuantity!)).toString(), style: Styles.smallGreyText(context)))),
                                                VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                              ],
                                            )),
                                        Text((int.parse(e.sellingPrice!) * (int.parse(e.allocatedQuantity!) - int.parse(e.deliveryQuantity!))).toString(), style: Styles.smallGreyText(context)),
                                      ]
                                  )).toList()),
                        SizedBox(height: 20,),


                      ],
                    ),
                  )),
            ],
          ):SizedBox(),

        ],
      ),
    );

  }

  TableRow buildRow(List<Widget> cells) => TableRow(
    children: cells.map((cell) => cell).toList()
  );

  final List<Map> mycustomers = [
    {
      'productName': 'Drinking Water',
      'types': {
        'data': [
          {'name': 'Dasani22', 'quantity': '1L', 'price': 'KSH 110'},
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
}
