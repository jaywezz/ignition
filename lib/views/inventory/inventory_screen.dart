import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/constants.dart';

import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/logic/routes/routes.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/receive_stock/receive_stock_screen.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/reconcile/all_reconciliation_screen.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/reconcile/reconcile.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/reconcile/reconcile_products.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/stock_history_details.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/stock_lift.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/stock_requisition/select_stock_screen.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/view_my_stock.dart';
import 'package:soko_flow/views/inventory/shipments.dart';
import 'package:soko_flow/views/inventory/stock_history.dart';

import '../../routes/route_helper.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map> myInventoryItems = [
      {'icon': Icons.download, 'name': 'Receive Stock'},
      {'icon': Icons.note_alt, 'name': 'Stock History'},
      {'icon': Icons.check_box_rounded, 'name': 'View My Stock'},
      //{'icon': Icons.local_shipping_rounded, 'name': 'Shipments'},
      // {'icon': Icons.shopping_cart, 'name': 'Stock Lift'},
      {'icon': Icons.shopping_cart, 'name': 'Stock Requisition'},
      {'icon': Icons.restart_alt_outlined, 'name': 'Reconcile'},
    ];
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          //color: Styles.appBackgroundColor,
          child: Container(
            padding: EdgeInsets.only(
                left: defaultPadding(context),
                right: defaultPadding(context),
                bottom: defaultPadding(context)),
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
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Theme.of(context).splashColor,
                        onTap: () => Get.toNamed(RouteHelper.getInitial()),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Styles.darkGrey,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'My Inventory',
                        style: Styles.heading2(context),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Theme.of(context).splashColor,
                          onTap: () => Get.toNamed(RouteHelper.getInitial()),
                          child: Icon(
                            Icons.home_sharp,
                            size: defaultPadding(context) * 2,
                            color: Styles.appSecondaryColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                    child: Center(
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: defaultPadding(context) * 3),
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: choices.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: Responsive.isTablet(context)
                              ? ((((MediaQuery.of(context).size.width -
                                              (defaultPadding(context) * 1.2)) /
                                          2) -
                                      5) /
                                  200)
                              : ((((MediaQuery.of(context).size.width -
                                          (defaultPadding(context) * 1.4)) /
                                      1.3)) /
                                  220),
                          crossAxisSpacing: 0,
                        ),
                        itemBuilder: (context, index) {
                          return GridCard(
                            choice: choices[index],
                          );
                        }),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GridData {
  final String title;
  final IconData icon;

  Widget onpressed;

  GridData({required this.title, required this.icon, required this.onpressed});
}

List<GridData> choices = [
  GridData(
    title: 'Receives Stock',
    icon: Icons.download,
    onpressed: ReceiveStock(),
  ),
  GridData(
    title: 'Stock History',
    icon: Icons.note_alt,
    onpressed: StockHistory(),
  ),
  GridData(
    title: 'View My Stock',
    icon: Icons.check_box,
    onpressed: ViewMyStock(),
  ),
  // GridData(
  //   title: 'Shipments',
  //   icon: Icons.local_shipping,
  //   onpressed: ShipmentsPage(),
  // ),
  GridData(
    title: 'Stock Lift',
    icon: Icons.shopping_cart,
    onpressed: StockLift(),
  ),
  GridData(
    title: 'Stock Requisition',
    icon: Icons.add_shopping_cart,
    onpressed: StockRequisition(),
  ),
  GridData(
    title: 'Reconcile',
    icon: Icons.restart_alt,
    onpressed: UserReconciliations(),
  ),
];

class GridCard extends StatelessWidget {
  const GridCard({Key? key, this.choice}) : super(key: key);
  final GridData? choice;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(choice!.onpressed);
      },
      //Navigate.instance.toRoute(choice!.onpressed),
      child: Card(
        color: Styles.appSecondaryColor,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all( Responsive.isTablet(context)?13:defaultPadding(context)),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Icon(
                    choice!.icon,
                    color: Colors.white,
                    size: defaultPadding(context) * 4,
                  )),
                  SizedBox(
                    height: 2,
                  ),
                  Text(choice!.title,
                      style: Styles.heading3(context)
                          .copyWith(color: Colors.white)),
                ]),
          ),
        ),
      ),
    );
  }
}
