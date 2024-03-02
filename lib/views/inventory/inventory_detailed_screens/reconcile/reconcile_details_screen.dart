import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/models/reconcile/reconciliations_list_model.dart';

class ReconcileDetails extends StatefulWidget {
  final ReconciliationListModel reconcile;
  const ReconcileDetails({Key? key, required this.reconcile}) : super(key: key);

  @override
  State<ReconcileDetails> createState() => _ReconcileDetailsState();
}

class _ReconcileDetailsState extends State<ReconcileDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: Text(DateForm),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                        'Reconciliation Details',
                        style: Styles.heading3(context),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text("Cash Reconciliations", style: Styles.heading3(context).copyWith(color: Colors.black54),),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Mpesa: ", style: Styles.heading3(context).copyWith(color: Colors.black54),),
                              Text(widget.reconcile.mpesa.toString(), style: Styles.heading2(context).copyWith(color: Colors.black),)
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Cash: ", style: Styles.heading3(context).copyWith(color: Colors.black54),),
                              Text(widget.reconcile.cash.toString(), style: Styles.heading2(context).copyWith(color: Colors.black),)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Cheque: ", style: Styles.heading3(context).copyWith(color: Colors.black54),),
                              Text(widget.reconcile.cheque.toString(), style: Styles.heading2(context).copyWith(color: Colors.black),)
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Bank Transfer: ", style: Styles.heading3(context).copyWith(color: Colors.black54),),
                              Text(widget.reconcile.bank.toString(), style: Styles.heading2(context).copyWith(color: Colors.black),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                SizedBox(height: 20,),
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
                        DataColumn(label: Text("Qty", style: Styles.heading3(context).copyWith(fontWeight: FontWeight.bold),)),
                      ],
                      rows: List.generate(widget.reconcile.reconciliationProducts!.length,
                              (index) => productDataRow(widget.reconcile.reconciliationProducts![index], index, context))),
                ),

            ],),
          ),
        ),
      ),
    );;
  }

  DataRow productDataRow(ReconciliationListProduct productData, index, BuildContext context) {
    return DataRow(
        selected: true,
        cells: [
          DataCell(Text((index + 1).toString())),
          DataCell(Text(productData.productName!)),
          DataCell(Text(productData.amount!.toString())),

        ]);
  }

  TableRow buildRow(List<Widget> cells) => TableRow(
      children: cells.map((cell) => cell).toList()
  );
}

