import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/models/add_cart_model/add_to_cart_model.dart';

class NewSalesOrderList extends StatefulWidget {
  final List<NewSalesCart>? newSalesCartList;

  const NewSalesOrderList({Key? key, this.newSalesCartList}) : super(key: key);

  @override
  State<NewSalesOrderList> createState() => _NewSalesOrderListState();
}

class _NewSalesOrderListState extends State<NewSalesOrderList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
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
                Text("Product", style: Styles.heading3(context),),
                IntrinsicHeight(
                    child:Row(

                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                        Container(
                            width: 50,
                            child: Center(child: Text('SKU', style: Styles.heading3(context),))),
                        VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                      ],
                    )),
                Text("Quantity", style: Styles.heading3(context),),
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
              children: widget.newSalesCartList!.map((e) =>  buildRow(
                  [
                    Text(e.productMo!.productName!, style: Styles.smallGreyText(context),),
                    IntrinsicHeight(
                        child:Row(

                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                            Container(
                                width: 50,
                                child: Center(child: Text(e.productMo!.skuCode!, style: Styles.smallGreyText(context)))), VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                          ],
                        )),
                    Text("${e.qty.toString()}", style: Styles.smallGreyText(context)),
                  ]
              )).toList()
          ),

        ],
      ),
    );
  }
}

TableRow buildRow(List<Widget> cells) => TableRow(
    children: cells.map((cell) => cell).toList()
);

