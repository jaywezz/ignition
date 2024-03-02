import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/product_category_controller.dart';
import 'package:soko_flow/controllers/product_controller.dart';
import 'package:soko_flow/data/providers/products_provider.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/components/product_summary_list.dart';
import 'package:soko_flow/widgets/cards/customer_list_card.dart';

import '../../../models/productsModel/products_model.dart';

class ProductListWidget extends ConsumerStatefulWidget {
  const ProductListWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductListWidget> createState() => _ProductListState();
}

class _ProductListState extends ConsumerState<ProductListWidget> {
  GlobalKey _one = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ref.watch(productsProvider).when(
        data: (data) {
          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  horizontalMargin: 10,
                  dividerThickness: 0.5,
                  columnSpacing: 20,
                  border: const TableBorder(
                    top: BorderSide(color: Colors.grey, width: 0.5),
                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                    left: BorderSide(color: Colors.grey, width: 0.5),
                    right: BorderSide(color: Colors.grey, width: 0.5),
                    horizontalInside:
                    BorderSide(color: Colors.grey, width: 0.5),
                    verticalInside: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  columns:  [
                    DataColumn(label: Text("#", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text("Product", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text("R. Price", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text("W. Price", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text("D. Price", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text("Category", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text("SKU", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
                  ],
                  rows: List.generate(data.length,
                          (index) => productDataRow(data[index], index, context))),
            ),
          );
        },
        error: (error, s) {
          return Center(
            child: Text(error.toString()),
          );
        },
        loading: () => Center(child: CircularProgressIndicator.adaptive()));

  }

  TableRow buildRow(List<Widget> cells) =>
      TableRow(children: cells.map((cell) => cell).toList());

  DataRow productDataRow(ProductsModel productData, index, BuildContext context) {
    return DataRow(
      selected: true,
        cells: [
      DataCell(Text((index + 1).toString())),
      DataCell(Text(productData.productName!)),
      DataCell(Text(productData.retailPrice!)),
      DataCell(Text(productData.wholesalePrice!)),
      DataCell(Text(productData.distributorPrice!.toString())),
      DataCell(Text(productData.category!)),
      DataCell(Text(productData.skuCode!)),
      // DataCell(IconButton(
      //     onPressed: () {
      //
      //     },
      //     icon: Icon(
      //       Icons.info_outline_rounded,
      //       color: Styles.appPrimaryColor,
      //     ))),
    ]);
  }
}