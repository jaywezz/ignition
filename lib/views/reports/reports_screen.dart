import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/data/providers/reports_providers/graph_data_provider.dart';
import 'package:soko_flow/data/providers/reports_providers/graph_titles_provider.dart';
import 'package:soko_flow/data/providers/reports_providers/reports_provider.dart';
import 'package:soko_flow/data/providers/sales-count_provider.dart';
import 'package:soko_flow/data/providers/targets_provider.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/currency_formatter.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  ReportsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  static const double barWidth = 30;
  static const shadowOpacity = 0.2;
  static const mainItems = <int, List<double>>{
    0: [11, 9],
    1: [3, 17],
    2: [7, 13],
    3: [17, 3],
    4: [12, 8],
    5: [15, 5],
  };
  int touchedIndex = -1;


  Widget leftTitles(double value, TitleMeta meta) {
    var style = Styles.normalText(context).copyWith(color: Colors.black38, fontSize: 12, fontWeight: FontWeight.w600);
    String text;
    if (value == 0) {
      text = '1';
    } else {
      text = '${value.toInt()}';
    }
    return SideTitleWidget(
      angle: 0,
      axisSide: meta.axisSide,
      space: 4.0,
      child: Text(
        (int.parse(text)/ 1000).toString(),
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }



  BarChartGroupData generateGroup(
      int x,
      double value1,
      double value2,
      ) {
    bool isTop = value1 > 0;
    final sum = value1 + value2;
    final isTouched = touchedIndex == x;
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      showingTooltipIndicators: isTouched ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: sum,
          width: barWidth,
          borderRadius: isTop
              ? const BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          )
              : const BorderRadius.only(
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
          rodStackItems: [
            BarChartRodStackItem(
              0,
              value1,
              Styles.graphDarkColor,
              BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
            BarChartRodStackItem(
              value1,
              value1 + value2,
              Styles.graphLightColor.withOpacity(.1),
              BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
            BarChartRodStackItem(
              value1 + value2,
              value1 + value2,
              const Color(0xffff4d94),
              BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
            BarChartRodStackItem(
              value1 + value2,
              value1 + value2,
              const Color(0xff19bfff),
              BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            ),
          ],
        ),

      ],
    );
  }

  bool isShadowBar(int rodIndex) => rodIndex == 1;
  String ordersSelectedFilter = "Weekly";
  String salesSelectedFilter = "Weekly";
  String graphSelectedFilter = "Weekly";

  List<DropdownMenuItem<String>> menuItems = [

    const DropdownMenuItem(value: "Weekly", child: Text("Weekly")),
    const DropdownMenuItem(value: "Monthly", child: Text("Monthly")),
    const DropdownMenuItem(value: "Today", child: Text("Today")),
  ];

  @override
  Widget build(BuildContext context) {
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
            child: ListView(
              children: [
                SizedBox(
                  height: defaultPadding(context),
                ),
                Stack(
                  children: [
                    Material(
                      child: InkWell(
                        splashColor: Theme
                            .of(context)
                            .splashColor,
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
                        "Reports",
                        style: Styles.heading2(context),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Material(
                        child: InkWell(
                          splashColor: Theme
                              .of(context)
                              .splashColor,
                          onTap: () => Get.toNamed(RouteHelper.getInitial()),
                          child: Icon(
                            Icons.home_sharp,
                            size: defaultPadding(context) * 2,
                            color: Styles.appPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: const BorderRadius.all(Radius.circular(5))

                  ),
                  child: Consumer(
                      builder: (context, ref, _) {
                        return ref.watch(targetsProvider).when(
                            data: (data){
                              String ordersCount = "";
                              String percentageAchieved = "";
                              if(ordersSelectedFilter == "Weekly"){
                                ordersCount = data.achievedWeeklyOrderTarget.toString();
                                percentageAchieved = roundUpAbsolute((double.parse(ordersCount??"1") /
                                    double.parse((int.parse(data.targetsOrder!) / 4).toString()) *
                                    100))
                                    .toString();
                              }
                              if(ordersSelectedFilter == "Monthly"){
                                ordersCount = data.achievedMonthlyOrderTarget!;
                                percentageAchieved = roundUpAbsolute((double.parse(ordersCount??"1") /
                                    double.parse((int.parse(data.targetsOrder!)).toString()) *
                                    100))
                                    .toString();
                              }
                              if(ordersSelectedFilter == "Today"){
                                ordersCount = data.achievedWeeklyOrderTarget.toString();
                                percentageAchieved = roundUpAbsolute((double.parse(ordersCount??"1") /
                                    double.parse((int.parse(data.targetsOrder!) / 24).toString()) *
                                    100))
                                    .toString();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(left: 20.0, top: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total orders", style:  Styles.normalText(context).copyWith(fontWeight: FontWeight.w700, color: Colors.black45),),
                                        Container(
                                          height: 32,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey.shade400, width: 2),
                                              borderRadius: const BorderRadius.all(Radius.circular(5))

                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                            child: DropdownButton<String>(
                                                style: Styles.heading4(context).copyWith(color: Colors.grey),
                                                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                                underline: const Divider(color: Colors.transparent,),
                                                onChanged:(String? value){
                                                  setState(() {
                                                    ordersSelectedFilter = value!;
                                                  });
                                                },
                                                value: ordersSelectedFilter,
                                                items: menuItems
                                            ),
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Padding(
                                    padding:  EdgeInsets.only(left: 20.0, top: 10, right: 10),
                                    child: Row(
                                      children: [
                                        Text("${ordersCount}", style: Styles.heading2(context),),
                                        SizedBox(width: 10,),
                                        // Icon(Icons.upload, color: Styles.appPrimaryColor, size: 20,),
                                        // SizedBox(width: 10,),
                                        // Text("+8.4%", style: Styles.heading4(context).copyWith(color: Styles.appPrimaryColor),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: RichText(
                                      text: TextSpan(
                                          text: 'You have achieved ',
                                          style: Styles.smallGreyText(context).copyWith(fontSize: 10),
                                          children: <TextSpan>[
                                            TextSpan(text: '${percentageAchieved} %',
                                              style: Styles.heading4(context).copyWith(color: Styles.appSecondaryColor),

                                            ),
                                            TextSpan(text: ' of your ${ordersSelectedFilter} target',
                                              style:Styles.smallGreyText(context).copyWith(fontSize: 10),

                                            )
                                          ]
                                      ),
                                    ),
                                  ),

                                ],
                              );
                            }, error: (e, error){
                          return Text(e.toString());
                        }, loading: (){
                          return Center(child: CircularProgressIndicator());
                        });
                      }
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: const BorderRadius.all(Radius.circular(5))

                  ),
                  child: Consumer(
                      builder: (context, ref, _) {
                        return ref.watch(targetsProvider).when(
                            data: (data){
                              String salesCount = "";
                              String percentageAchieved = "";
                              if(salesSelectedFilter == "Weekly"){
                                salesCount = data.achievedWeeklySalesTarget.toString();
                                percentageAchieved = roundUpAbsolute((double.parse(salesCount??"1") /
                                    double.parse((int.parse(data.targetSales!) / 4).toString()) *
                                    100))
                                    .toString();
                              }
                              if(salesSelectedFilter == "Monthly"){
                                salesCount = data.achievedMonthlySalesTarget.toString();
                                percentageAchieved = roundUpAbsolute((double.parse(salesCount??"1") /
                                    double.parse((int.parse(data.targetSales!)).toString()) *
                                    100))
                                    .toString();
                              }
                              if(salesSelectedFilter == "Today"){
                                salesCount = data.achievedDailySalesTarget.toString();
                                percentageAchieved = roundUpAbsolute((double.parse(salesCount??"1") /
                                    double.parse((int.parse(data.targetSales!) / 24).toString()) *
                                    100))
                                    .toString();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(left: 20.0, top: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Total Sales (in Volume)", style:  Styles.normalText(context).copyWith(fontWeight: FontWeight.w700, color: Colors.black45),),
                                        Container(
                                          height: 32,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey.shade400, width: 2),
                                              borderRadius: const BorderRadius.all(Radius.circular(5))

                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                            child: DropdownButton<String>(
                                                style: Styles.heading4(context).copyWith(color: Colors.grey),
                                                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                                underline: const Divider(color: Colors.transparent,),
                                                onChanged:(String? value){
                                                  setState(() {
                                                    salesSelectedFilter = value!;
                                                  });
                                                },
                                                value: salesSelectedFilter,
                                                items: menuItems
                                            ),
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Padding(
                                    padding:  EdgeInsets.only(left: 20.0, top: 10, right: 10),
                                    child: Row(
                                      children: [
                                        Text("${salesCount} ", style: Styles.heading2(context),),
                                        SizedBox(width: 10,),
                                        // Icon(Icons.upload, color: Styles.appPrimaryColor, size: 20,),
                                        // SizedBox(width: 10,),
                                        // Text("+8.4%", style: Styles.heading4(context).copyWith(color: Styles.appPrimaryColor),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: RichText(
                                      text: TextSpan(
                                          text: 'You have achieved ',
                                          style: Styles.smallGreyText(context).copyWith(fontSize: 10),
                                          children: <TextSpan>[
                                            TextSpan(text: '${percentageAchieved} %',
                                              style: Styles.heading4(context).copyWith(color: Styles.appSecondaryColor),

                                            ),
                                            TextSpan(text: ' of your ${salesSelectedFilter} target',
                                              style:Styles.smallGreyText(context).copyWith(fontSize: 10),

                                            )
                                          ]
                                      ),
                                    ),
                                  ),

                                ],
                              );
                            }, error: (e, error){
                          return Text(e.toString());
                        }, loading: (){
                          return Center(child: CircularProgressIndicator());
                        });
                      }
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: const BorderRadius.all(Radius.circular(5))

                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, top: 20, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Sales Analytics", style:  Styles.heading3(context).copyWith(fontWeight: FontWeight.w700, color: Colors.black45),),
                                    Container(
                                      height: 32.h,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade400,
                                              width: 2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.h, vertical: 2.w),
                                        child: DropdownButton<String>(
                                            style: Styles.heading4(context)
                                                .copyWith(color: Colors.grey),
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down_rounded),
                                            underline: const Divider(
                                              color: Colors.transparent,
                                            ),
                                            onChanged: (String? value) {
                                              print("the value is: $value");
                                              if(value == "Weekly"){
                                                print("week");
                                                setState(() {
                                                  graphSelectedFilter = "Weekly";
                                                });
                                                ref.watch(graphFilterProvider.state).state = GraphFilters.week;
                                              }
                                              if(value == "Monthly"){
                                                print("month");
                                                setState(() {
                                                  graphSelectedFilter = "Monthly";
                                                });
                                                ref.watch(graphFilterProvider.state).state = GraphFilters.month;
                                              }
                                              if(value == "Today"){
                                                setState(() {
                                                  graphSelectedFilter = "Today";
                                                });
                                                ref.watch(graphFilterProvider.state).state = GraphFilters.today;
                                              }
                                            },
                                            value: graphSelectedFilter,
                                            items: menuItems),
                                      ),
                                    )

                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              AspectRatio(
                                aspectRatio: .7,
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: BarChart(
                                      BarChartData(
                                        alignment: BarChartAlignment.center,
                                        maxY: ref.watch(maxYprovider),
                                        groupsSpace: 15.w,
                                        barTouchData: BarTouchData(
                                          handleBuiltInTouches: false,
                                          touchCallback: (FlTouchEvent event,
                                              barTouchResponse) {
                                            if (!event
                                                .isInterestedForInteractions ||
                                                barTouchResponse == null ||
                                                barTouchResponse.spot == null) {
                                              setState(() {
                                                touchedIndex = -1;
                                              });
                                              return;
                                            }
                                            final rodIndex = barTouchResponse
                                                .spot!.touchedRodDataIndex;
                                            if (isShadowBar(rodIndex)) {
                                              setState(() {
                                                touchedIndex = -1;
                                              });
                                              return;
                                            }
                                            setState(() {
                                              touchedIndex = barTouchResponse
                                                  .spot!.touchedBarGroupIndex;
                                            });
                                          },
                                        ),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          rightTitles: AxisTitles(
                                            sideTitles:
                                            SideTitles(showTitles: false),
                                          ),
                                          topTitles: AxisTitles(
                                            sideTitles:
                                            SideTitles(showTitles: false),
                                          ),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 40,
                                              getTitlesWidget: ref.watch(graphTitlesProvider.notifier).bottomTitles,
                                            ),
                                          ),
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: leftTitles,
                                              // interval: 5,
                                              reservedSize: ref.watch(graphFilterProvider.state).state == GraphFilters.month? 50.sp: 35.sp,
                                            ),
                                          ),
                                        ),
                                        gridData: FlGridData(
                                          show: false,
                                          // checkToShowHorizontalLine: (value) => value % 10 == 0,
                                        ),
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        barGroups: ref.watch(graphDataProvider).entries
                                            .map((e) => generateGroup(
                                          e.key,
                                          e.value[0],
                                          e.value[1],
                                        ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 12,
                                        width: 12,
                                        decoration: BoxDecoration(
                                            color: Styles.appPrimaryColor,
                                            borderRadius:const BorderRadius.all(Radius.circular(1))
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Text("Sales", style: Styles.smallGreyText(context).copyWith(fontWeight: FontWeight.w600),)
                                    ],
                                  ),
                                  SizedBox(width: 10,),
                                  Row(
                                    children: [
                                      Container(
                                        height: 12,
                                        width: 12,
                                        decoration: BoxDecoration(
                                            color: Styles.graphLightColor,
                                            borderRadius:const BorderRadius.all(Radius.circular(1))
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Text("Targets", style: Styles.smallGreyText(context).copyWith(fontWeight: FontWeight.w600),)
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}
