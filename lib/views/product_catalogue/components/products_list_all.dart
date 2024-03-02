import 'package:flutter/material.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/widgets/cards/customer_list_card.dart';

class ProductListAll extends StatelessWidget {
  ProductListAll({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: defaultPadding(context),
            vertical: defaultPadding(context) / 2),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                width: 2, color: Colors.grey.withOpacity(.5)))),
                    child: Text(
                      'Product',
                      style: Styles.heading3(context),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                width: 2, color: Colors.grey.withOpacity(.5)))),
                    child: Center(
                      child: Text(
                        'SKU',
                        style: Styles.heading3(context),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Amount',
                      style: Styles.heading3(context),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 1,
              color: Colors.grey.withOpacity(.5),
            ),
            ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => Divider(
                      color: Styles.darkGrey,
                    ),
                shrinkWrap: true,
                itemCount: mycustomers.length,
                itemBuilder: (context, index) {
                  List data = mycustomers[index]['types']['data'];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 2,
                                      color: Colors.grey.withOpacity(.5)))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: defaultPadding(context) / 2,
                              ),
                              Text(
                                mycustomers[index]['productName'],
                                style: Styles.heading3(context),
                              ),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder: (context, ind) {
                                    return Text(
                                      mycustomers[index]['types']['data'][ind]
                                          ['name'],
                                      style: Styles.smallGreyText(context),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 2,
                                      color: Colors.grey.withOpacity(.5)))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: defaultPadding(context) / 2,
                              ),
                              Text(
                                '',
                                style: Styles.heading3(context),
                              ),
                              SizedBox(
                                height: defaultPadding(context) / 2,
                              ),
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder: (context, ind) {
                                    return Center(
                                      child: Text(
                                        // getData(mycustomers[index], ['types', 'quantity'])
                                        //     .toString(),
                                        mycustomers[index]['types']['data'][ind]
                                                ['quantity']
                                            .toString(),
                                        style: Styles.smallGreyText(context),
                                      ),
                                    );
                                  })
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: defaultPadding(context) / 2,
                            ),
                            Text(
                              '',
                              style: Styles.heading3(context),
                            ),
                            SizedBox(
                              height: defaultPadding(context) / 2,
                            ),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, ind) {
                                  return Center(
                                    child: Text(
                                      mycustomers[index]['types']['data'][ind]
                                          ['price'],
                                      style: Styles.smallGreyText(context),
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ],
        ),
      )),
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
}
