import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/models/allocation_history_model/allocations_model.dart';
import 'package:soko_flow/models/latest_allocations_model/latest_allocated_items_model.dart';
import 'package:soko_flow/widgets/cards/customer_list_card.dart';

class LatestAllocationsProductList extends ConsumerStatefulWidget {
  final List<LatestAllocationModel>? latestAllocationList;

  const LatestAllocationsProductList({Key? key, this.latestAllocationList}) : super(key: key);



  @override
  ConsumerState<LatestAllocationsProductList> createState() => _LatestAllocationsProductListState();
}

class _LatestAllocationsProductListState extends ConsumerState<LatestAllocationsProductList> {


  @override
  Widget build(BuildContext context) {
    StockHistoryController stockHistoryController = Get.put(StockHistoryController(stockHistoryRepository: Get.find()));

    return RefreshIndicator(
      onRefresh: (){
        return stockHistoryController.getLatestAllocations(true);
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Card(
            child: Container(

              child: Column(
                children: [
                  SingleChildScrollView(
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
                          DataColumn(label: Text("Alc. Qty", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
                          DataColumn(label: Text("R. Price", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
                          DataColumn(label: Text("W. Price", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
                          DataColumn(label: Text("D. Price", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
                          DataColumn(label: Text("SKU", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
                        ],
                        rows: List.generate( stockHistoryController.lstLatestAllocations.length,
                                (index) => productDataRow( stockHistoryController.lstLatestAllocations[index], index, context))),
                  ),

                  // Table(
                  //     columnWidths: {
                  //       0: FractionColumnWidth(0.5),
                  //       1: FractionColumnWidth(0.30),
                  //       2: FractionColumnWidth(0.10),
                  //       3: FractionColumnWidth(0.20),
                  //     },
                  //     children: stockHistoryController.lstLatestAllocations.map((e) =>  buildRow(
                  //         [
                  //           SizedBox(
                  //               width:MediaQuery.of(context).size.width *.3,
                  //               child: Text(e.productName!, style: Styles.smallGreyText(context),)),
                  //           IntrinsicHeight(
                  //               child:Row(
                  //
                  //                 mainAxisAlignment: MainAxisAlignment.start,
                  //                 children: <Widget>[
                  //                   VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                  //                   Container(
                  //                       width: 50,
                  //                       child: Center(child: Text(e.skuCode!, style: Styles.smallGreyText(context)))),
                  //                   VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                  //                 ],
                  //               )),
                  //           Text(e.allocatedQty!, style: Styles.smallGreyText(context)),
                  //           // VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                  //           Text(e.retailPrice!, style: Styles.smallGreyText(context)),
                  //         ]
                  //     )).toList()
                  // ),
                  SizedBox(height: 20,),


                ],
              ),
            )),
      ),
    );
  }

}

DataRow productDataRow(LatestAllocationModel productData, index, BuildContext context) {
  return DataRow(
      selected: true,
      cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Text(productData.productName!)),
        DataCell(Text(productData.allocatedQty!)),
        DataCell(Text(productData.retailPrice!)),
        DataCell(Text(productData.wholeSalePrice!)),
        DataCell(Text(productData.distributorPrice!.toString())),
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

TableRow buildRow(List<Widget> cells) => TableRow(
    children: cells.map((cell) => cell).toList()
);
