import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/data/providers/add_stock_lift_provider.dart';
import 'package:soko_flow/logic/routes/routes.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/stock_history_details.dart';
import 'package:soko_flow/views/product_catalogue/components/allocation_history_products.dart';
import 'package:soko_flow/widgets/buttons/pill_button.dart';
import 'package:soko_flow/widgets/inputs/search_field.dart';


class StockHistory extends ConsumerStatefulWidget {
  const StockHistory({Key? key}) : super(key: key);

  @override
  ConsumerState<StockHistory> createState() => _StockHistoryState();
}

class _StockHistoryState extends ConsumerState<StockHistory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  // @override
  // void didUpdateWidget(StockHistory oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   StockHistoryController stockHistoryController = Get.put(StockHistoryController(stockHistoryRepository: Get.find()));
  //   stockHistoryController.alllststockHistory.clear();
  //
  //   super.didUpdateWidget(oldWidget);
  // }

  List<String> options = [];
  int initPosition = 0;
  tabOptions(BuildContext context) async {
    // nokia c21
    //options.add("All");
    for (var i = 0; i <  stock1.length; i++) {
      options.add(stock1[i].toString());
    }
    await options;
  }

  @override
  void initState() {
    StockHistoryController stockHistoryController = Get.put(StockHistoryController(stockHistoryRepository: Get.find()));
    stockHistoryController.getStockHistory(0);

    tabOptions(context);
    _tabController = TabController(length: stock1.length, vsync: this);
    _tabController.addListener((() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //

    return Scaffold(

        body: GetBuilder<StockHistoryController>(builder: (stockHistoryController){
          return SafeArea(
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
                    ),
                    child: SingleChildScrollView(
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
                                    onTap: () => Navigator.pop(context),
                                    child: Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Styles.darkGrey,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Stock History',
                                    style: Styles.heading2(context),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: defaultPadding(context) * 1.3,
                            ),
                            SizedBox(
                              height: defaultPadding(context) * .4,
                            ),
                            ref.watch(stockRequisitionsProvider).when(
                                data:(data){
                                  return RefreshIndicator(
                                    onRefresh: ()async{
                                      await ref.refresh(stockRequisitionsProvider);
                                    },
                                    child: ListView.builder(
                                        physics: AlwaysScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: data.length,
                                        itemBuilder: (context, index){
                                          return GestureDetector(
                                            onTap:(){
                                              Get.to(StockHistoryDetails(requisition: data[index],));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(0xFF757575),
                                                  width: 0.0,
                                                ),
                                                borderRadius: BorderRadius.circular(5.0),
                                              ),
                                              padding: EdgeInsets.all(10.0),
                                              margin: EdgeInsets.only(bottom: 20.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        data[index].data!.length>0?"${data[index].data![0].productName!} ...":"None",
                                                        // DateFormat.yMMMd().format(data[index].date!),
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(DateFormat.yMMMd().format(data[index].date!),style: TextStyle(
                                                        fontSize: 13.0,
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.bold,
                                                      ),)
                                                    ],
                                                  ),
                                                  SizedBox(height: 5.0),
                                                  SizedBox(height: 10.0),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: data[index].status! == "Waiting Approval" ?Colors.grey:Colors.green,
                                                      borderRadius: BorderRadius.circular(20.0),
                                                    ),
                                                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                                    child: Text(
                                                      data[index].status!.capitalizeFirst!,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  );
                                },
                                error: (e, s){
                                  return Text("An error occured getting requisitions",style: Styles.heading3(context).copyWith(color: Colors.red),);
                                },
                                loading: (){
                                  return Center(child: CircularProgressIndicator());
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Text(
                                //   'November',
                                //   style: Styles.heading2(context),
                                // ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '',
                                  style: Styles.smallGreyText(context),
                                ),
                              ],
                            ),

                          ]),
                    ),
                  )

              )
          );
        })
    );
  }

  final List stock2 = const [
    {"name": "Indian", "icon": "assets/icons/h.png"},
    {"name": "Italian", "icon": "assets/icons/i.png"},
    {"name": "kenyan", "icon": "assets/icons/d.png"},
    {"name": "French", "icon": "assets/icons/e.png"},
    {"name": "Ghanaian", "icon": "assets/icons/j.png"},
  ];

  final List stock1 = const [
    'All', 'Past 1 Month', 'Last 3 Months', 'Last 6 months', '1 year'
    // {"name": "All", "icon": "assets/icons/a.png"},
    // {"name": "Past 1 Month", "icon": "assets/icons/b.png"},
    // {"name": "Last 3 Months", "icon": "assets/icons/f.png"},
    // {"name": "Last 6 Months", "icon": "assets/icons/g.png"},
    // {"name": "1 year", "icon": "assets/icons/c.png"},
  ];


}

class AllocationsCustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  AllocationsCustomTabView({
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    required this.stub,
    required this.onPositionChange,
    required this.onScroll,
    required this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<AllocationsCustomTabView>
    with TickerProviderStateMixin {
  late TabController controller;
  late int _currentCount;
  late int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation!.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(AllocationsCustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation!.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation!.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  // @override
  // void dispose() {
  //   controller.animation!.removeListener(onScroll);
  //   controller.removeListener(onPositionChange);
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub;

    return SizedBox(
      height: double.infinity,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.only(
          //   left: defaultPadding(context),
          //   right: defaultPadding(context),
          //   bottom: defaultPadding(context),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // ==============================
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: Container(
                      // alignment: Alignment.center,
                      child: TabBar(
                        padding: EdgeInsets.symmetric(
                          horizontal: defaultPadding(context) * 0,
                        ),
                        unselectedLabelColor: Styles.appPrimaryColor,
                        isScrollable: true,
                        controller: controller,
                        labelColor: Colors.white,
                        //indicatorSize: TabBarIndicatorSize.label,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Styles.appPrimaryColor,
                        ),
                        tabs: List.generate(
                          widget.itemCount,
                              (index) {
                            return widget.tabBuilder(context, index);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
//               // ===================================

              Container(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          // child: Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding(context),
                            ),
                            margin: EdgeInsets.only(
                              bottom: 5,
                            ),
                            child: TabBarView(
                              controller: controller,
                              children: List.generate(
                                widget.itemCount,
                                    (index) => widget.pageBuilder(context, index),
                              ),
                            ),
                          ),
                          // ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
          // ==============================
        ),
      ),
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation!.value);
    }
  }
}
