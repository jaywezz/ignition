import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/logic/routes/routes.dart';
import 'package:soko_flow/services/navigation_services.dart';
import 'package:soko_flow/widgets/buttons/pill_button.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../routes/route_helper.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener((() {
      setState(() {
        currentIndex = _tabController.index;
      });
    }));
    super.initState();
  }

  String? value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Styles.appPrimaryColor,
        body: Container(
          padding: EdgeInsets.only(
            top: defaultPadding(context) * 2.5,
            left: defaultPadding(context),
            right: defaultPadding(context),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Material(
                    color: Styles.appPrimaryColor,
                    child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Styles.appBackgroundColor,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Custom',
                      style: Styles.heading2(context)
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Material(
                      color: Styles.appPrimaryColor,
                      child: InkWell(
                        splashColor: Theme.of(context).splashColor,
                        onTap: () => Get.toNamed(RouteHelper.getInitial()),
                        child: Icon(
                          Icons.home_sharp,
                          size: defaultPadding(context) * 2,
                          color: Styles.appBackgroundColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding(context) * 4,
                  vertical: defaultPadding(context) * 0.5,
                ),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(defaultPadding(context) * 1.4)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: double.infinity - defaultPadding(context) * 3,
                      height: defaultPadding(context) * 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: PillButton(
                                selected: currentIndex == 0 ? true : false,
                                action: () {
                                  setState(() {
                                    _tabController.animateTo(0);
                                  });
                                },
                                text: "Month"),
                          ),
                          SizedBox(
                            width: defaultPadding(context) / 2,
                          ),
                          Expanded(
                            child: PillButton(
                                selected: currentIndex == 1 ? true : false,
                                action: () {
                                  setState(() {
                                    _tabController.animateTo(1);
                                  });
                                },
                                text: "Year"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(controller: _tabController, children: [
                  SfDateRangePicker(
                    //enableMultiView: true,
                    view: DateRangePickerView.month,
                    todayHighlightColor: Styles.appBackgroundColor2,
                    selectionMode: DateRangePickerSelectionMode.range,
                    onSelectionChanged: _onSelectionChanged,
                    navigationDirection:
                        DateRangePickerNavigationDirection.vertical,
                    monthViewSettings: DateRangePickerMonthViewSettings(
                        firstDayOfWeek: 1,
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                            textStyle: Styles.heading3(context)
                                .copyWith(color: Styles.appBackgroundColor))),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: Styles.heading3(context).copyWith(
                          color: Styles.appBackgroundColor,
                          fontWeight: FontWeight.bold),
                    ),
                    selectionTextStyle: Styles.heading3(context)
                        .copyWith(color: Styles.appPrimaryColor),
                    startRangeSelectionColor: Styles.appBackgroundColor,
                    endRangeSelectionColor: Styles.appBackgroundColor,
                    //selectionColor: Styles.appBackgroundColor,
                    rangeSelectionColor: Colors.white.withOpacity(.2),
                    rangeTextStyle: Styles.heading3(context)
                        .copyWith(color: Styles.appBackgroundColor),
                    headerStyle: DateRangePickerHeaderStyle(
                        textAlign: TextAlign.center,
                        textStyle: Styles.heading2(context)
                            .copyWith(color: Styles.appBackgroundColor)),
                  ),
                  SfDateRangePicker(
                    //enableMultiView: true,
                    view: DateRangePickerView.year,
                    navigationDirection:
                        DateRangePickerNavigationDirection.vertical,
                    todayHighlightColor: Styles.appBackgroundColor2,
                    monthViewSettings: DateRangePickerMonthViewSettings(
                        firstDayOfWeek: 1,
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                            textStyle: Styles.heading3(context)
                                .copyWith(color: Styles.appBackgroundColor))),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: Styles.heading3(context).copyWith(
                          color: Styles.appBackgroundColor,
                          fontWeight: FontWeight.bold),
                    ),
                    yearCellStyle: DateRangePickerYearCellStyle(
                        textStyle: Styles.heading3(context).copyWith(
                            color: Styles.appBackgroundColor,
                            fontWeight: FontWeight.bold)),
                    selectionTextStyle: Styles.heading3(context)
                        .copyWith(color: Styles.appPrimaryColor),
                    startRangeSelectionColor: Styles.appBackgroundColor,
                    endRangeSelectionColor: Styles.appBackgroundColor,
                    //selectionColor: Styles.appBackgroundColor,
                    rangeSelectionColor: Colors.white.withOpacity(.2),
                    rangeTextStyle: Styles.heading3(context)
                        .copyWith(color: Styles.appBackgroundColor),
                    headerStyle: DateRangePickerHeaderStyle(
                        textAlign: TextAlign.center,
                        textStyle: Styles.heading2(context)
                            .copyWith(color: Styles.appBackgroundColor)),
                  ),
                ]),
              )
            ],
          ),
        ));
  }

  void _onSelectionChanged(
      DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
    print(dateRangePickerSelectionChangedArgs);
  }
}
