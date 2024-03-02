import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:soko_flow/configs/constants.dart';

import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/reconcile_controller.dart';
import 'package:soko_flow/logic/routes/routes.dart';
import 'package:soko_flow/models/wawrehouse_model/warehouses_model.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/currency_formatter.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:soko_flow/widgets/inputs/defaut_input_field.dart';

import '../../../../routes/route_helper.dart';

class Reconcile extends StatefulWidget {
  final String warehouse;
  final String distributorId;
  const Reconcile({Key? key, required this.warehouse, required this.distributorId}) : super(key: key);

  @override
  State<Reconcile> createState() => _ReconcileState();
}

class _ReconcileState extends State<Reconcile> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,

          //color: Styles.appBackgroundColor,
          child: GetBuilder<ReconcileController>(
            builder: (reconcileController) {
              return Container(
                  padding: EdgeInsets.only(
                      left: defaultPadding(context),
                      right: defaultPadding(context),
                      bottom: defaultPadding(context)),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(30))),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: defaultPadding(context),
                          ),
                          Stack(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Theme.of(context).splashColor,
                                  onTap: () => Navigator.pop(context),
                                  //Navigate.instance.toRemove('/customers'),
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Styles.darkGrey,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Close Shipment',
                                  style: Styles.heading2(context),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Theme.of(context).splashColor,
                                    onTap: () =>
                                        Get.toNamed(RouteHelper.getInitial()),
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
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                SizedBox(
                                  height: defaultPadding(context) * 2,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      formatCurrency.format(reconcileController.totalExpectedAmount).toString(),
                                      style: Styles.heading1(context).copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black.withOpacity(.7),
                                          fontSize: defaultPadding(context) * 4),
                                    ),
                                    Text('Total Expected funds Funds (Ksh)',
                                        style: Styles.heading4(context)
                                            .copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                SizedBox(
                                  height: defaultPadding(context),
                                ),
                                Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: defaultPadding(context),
                                        left: defaultPadding(context) * 2,
                                        right: defaultPadding(context) * 2,
                                        bottom: defaultPadding(context) * 2),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Deliveries:',
                                              style: Styles.heading4(context),
                                            ),
                                            Text('379',
                                                style: Styles.heading4(context)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Stock:',
                                                style: Styles.heading4(context)),
                                            Text('2,460',
                                                style: Styles.heading4(context)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Visits:',
                                                style: Styles.heading4(context)),
                                            Text('378',
                                                style: Styles.heading4(context)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: defaultPadding(context) * 2,
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    child: Card(

                                      elevation: 1,
                                      child: ExpansionTile(
                                        // this key is required to save and restore ExpansionTile expanded state
                                        // key: PageStorageKey(category.id),

                                        iconColor: Styles.appPrimaryColor,
                                        textColor: Styles.appPrimaryColor,
                                        controlAffinity: ListTileControlAffinity.trailing,
                                        childrenPadding:
                                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                        expandedCrossAxisAlignment: CrossAxisAlignment.end,
                                        maintainState: true,
                                        title: Text("Closing Stock", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                        // contents
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
                                          Table(
                                              columnWidths: {
                                                0: FractionColumnWidth(0.5),
                                                1: FractionColumnWidth(0.30),
                                                2: FractionColumnWidth(0.25),
                                              },
                                              children: reconcileController.reconcileCartList.map((e) =>  buildRow(
                                                  [
                                                    Text(e.latestAllocationModel!.productName!, style: Styles.smallGreyText(context),),
                                                    IntrinsicHeight(
                                                        child:Row(

                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: <Widget>[
                                                            VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                                            Container(
                                                                width: 50,
                                                                child: Center(child: Text(e.latestAllocationModel!.skuCode!, style: Styles.smallGreyText(context)))),
                                                            VerticalDivider(color: Colors.grey.shade400, thickness: 2,),
                                                          ],
                                                        )),
                                                    Text("${e.qty.toString()} out of ${e.latestAllocationModel!.allocatedQty}", style: Styles.smallGreyText(context)),
                                                  ]
                                              )).toList()
                                          ),
                                          Divider(thickness: 1,),


                                        ],
                                      ),
                                    ),
                                  ),
                                SizedBox(height: defaultPadding(context)),
                                Align(
                                  alignment: Alignment.center,
                                  child: Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: defaultPadding(context),
                                          left: defaultPadding(context) * 2,
                                          right: defaultPadding(context) * 2,
                                          bottom: defaultPadding(context) * 2),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Total amount to be collected: Mpesa",
                                            style: Styles.heading4(context),
                                          ),
                                          DefaultInputField(
                                            title: "Total amount to be collected: Mpesa",
                                            textEditingController: reconcileController.mpesaAmountController,
                                            hintText: 'Mpesa Amount',
                                          ),
                                          SizedBox(height: defaultPadding(context)),

                                          SizedBox(height: defaultPadding(context)),
                                          DefaultInputField(
                                            title: "Total amount to be collected: Cash",
                                            textEditingController: reconcileController.cashAmountController,
                                            hintText: 'Cash Amount',
                                          ),
                                          SizedBox(height: defaultPadding(context)),
                                          Text(
                                            "Total amount to be collected: Cheque",
                                            style: Styles.heading4(context),
                                          ),
                                          SizedBox(height: defaultPadding(context)),
                                          DefaultInputField(
                                            title: "Total amount to be collected: Cheque",
                                            textEditingController: reconcileController.chequeAmountController,
                                            hintText: 'Cheque Amount',
                                          ),
                                          DefaultInputField(
                                            title: "Total amount to be collected: Bank",
                                            textEditingController: reconcileController.bankAmountController,
                                            hintText: 'Bank Amount',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: defaultPadding(context) * 7),
                              ],
                            ),
                          )
                        ],
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding(context)),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: Colors.grey,
                                              offset: const Offset(
                                                3.0,
                                                5.0,
                                              ),
                                              blurRadius: 10.0,
                                              spreadRadius: 2.0,
                                            ), //BoxShadow
                                            BoxShadow(
                                              color: Colors.grey,
                                              offset: const Offset(0.0, 0.0),
                                              blurRadius: 0.0,
                                              spreadRadius: 0.0,
                                            ),
                                          ],
                                          shape: BoxShape.circle,
                                          color: Styles.appYellowColor),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          defaultPadding(context) / 2,
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          size: defaultPadding(context) * 2.5,
                                          color: Styles.appBackgroundColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  isLoading?CircularProgressIndicator():FullWidthButton(
                                    action: () async{
                                     try{
                                       isLoading = true;
                                       setState(() {});
                                       await reconcileController.reconcileStock(widget.warehouse, widget.distributorId);
                                       print("here");
                                       isLoading = false;
                                       setState(() {});
                                     }catch(e){
                                       print("error");
                                       isLoading = false;
                                       setState(() {});
                                     }
                                    },
                                    text: 'Close Shipment',
                                    color: Styles.appPrimaryColor,
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashColor: Theme.of(context).splashColor,
                                      onTap: () {
                                        Navigator.pop(context);
                                        //Navigate.instance.toRemove('/customers');
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: defaultPadding(context) / 2),
                                        child: Center(
                                            child: Text(
                                          'Cancel',
                                          textAlign: TextAlign.center,
                                          style: Styles.normalText(context),
                                        )),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ))
                    ],
                  ));
            }
          ),
        ),
      ),
    );
  }

  TableRow buildRow(List<Widget> cells) => TableRow(
      children: cells.map((cell) => cell).toList()
  );
}
