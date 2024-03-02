import 'package:flutter/material.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/components/amounts_payable_rows.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/components/summary_products_list.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:soko_flow/widgets/buttons/item_quantity_count_button.dart';

import '../../../../configs/styles.dart';

class productSummaryList extends StatelessWidget {
  const productSummaryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Column(
        children: [
          SummaryProductsList(),
          Flexible(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  AmountsPayableRow(amount: "Ksh 14,320", title: "Sub Total"),
                  AmountsPayableRow(amount: "Ksh 704", title: "Tax"),
                  AmountsPayableRow(amount: "Ksh 2,400", title: "Shipping"),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        "Ksh 17,424",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
