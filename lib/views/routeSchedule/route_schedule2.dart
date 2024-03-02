import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/customer_checking_controller.dart';
import 'package:soko_flow/controllers/customer_provider.dart';
import 'package:soko_flow/controllers/customers_controller.dart';
import 'package:soko_flow/controllers/routes_controller.dart';
import 'package:soko_flow/data/providers/routes_provider.dart';
import 'package:soko_flow/data/repository/routes_repo.dart';
import 'package:soko_flow/models/customer_checkin.dart';
import 'package:soko_flow/models/customer_model/customer_model.dart';
import 'package:soko_flow/models/route_schedule_model.dart';
import 'package:soko_flow/views/customers/map_view.dart';
import 'package:soko_flow/views/home/components/home_schedule_card.dart';
import 'package:soko_flow/views/home/last_31days.dart';
import 'package:soko_flow/widgets/custom_button.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../routes/route_helper.dart';
import 'package:http/http.dart' as http;

class RouteSchedule2 extends ConsumerStatefulWidget {
  @override
  _RouteSchedule2State createState() => _RouteSchedule2State();
}

class _RouteSchedule2State extends ConsumerState<RouteSchedule2> {

  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  // Map<DateTime, List<Event>>? kEvents;
  DateTime? _rangeEnd;
  TextEditingController dateInputController = TextEditingController();
  TextEditingController routeNameController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  // TimeOfDay time = const TimeOfDay(hour: 10, minute: 15);

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }
  //
  @override
  void dispose() {
    // _selectedEvents.dispose();
    super.dispose();
  }


  void getUserRoutes() async{
    await ref.watch(userRoutesNotifierProvider.notifier).filterUserRoutes();
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // ref.watch(routesTypeProvider.state).state = ScheduleTypes.Individual;
    getUserRoutes();
    super.didChangeDependencies();
  }




  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    ref.watch(selectedEventsProvider.state).state = [];
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      ref.watch(selectedEventsProvider).addAll(
          ref.watch(userRoutesNotifierProvider.notifier).getEventsForDay(selectedDay));
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    ref.watch(selectedEventsProvider.state).state = [];
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      ref.watch(selectedEventsProvider).addAll(
          ref.watch(userRoutesNotifierProvider.notifier).getEventsForRange(start, end));
    } else if (start != null) {
      ref.watch(selectedEventsProvider).addAll(
          ref.watch(userRoutesNotifierProvider.notifier).getEventsForDay(start));
    } else if (end != null) {
      ref.watch(selectedEventsProvider).addAll(
          ref.watch(userRoutesNotifierProvider.notifier).getEventsForDay(end));
    }
  }

  showSnackBar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final customersProvider =ref.watch(customerNotifierProvider.notifier);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
            top: defaultPadding(context) * 2,
            left: defaultPadding(context),
            right: defaultPadding(context),
            bottom: defaultPadding(context)),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            SizedBox(
              height: defaultPadding(context),
            ),
            Stack(
              children: [
                Material(
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
                    'Route Schedule',
                    style: Styles.heading2(context),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Material(
                    child: InkWell(
                      splashColor: Theme.of(context).splashColor,
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

            SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.sp)
                  ),
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        action: () {
                          ref.read(routesTypeProvider.state).state = ScheduleTypes.Individual;
                          ref.read(userRoutesNotifierProvider.notifier).filterUserRoutes();
                        },
                        text: 'Individual',
                        isSelected:  ref.watch(routesTypeProvider) == ScheduleTypes.Individual,
                      ),
                      CustomButton(
                        action: () {
                          ref.read(routesTypeProvider.state).state = ScheduleTypes.Assigned;
                          ref.read(userRoutesNotifierProvider.notifier).filterUserRoutes();
                        },
                        text: 'Assigned',
                        isSelected:  ref.watch(routesTypeProvider) == ScheduleTypes.Assigned,
                      ),

                      // CustomButton(
                      //   action: () {
                      //     ref.read(routesTypeProvider.state).state = ScheduleTypes.Routes;
                      //     ref.read(userRoutesNotifierProvider.notifier).filterUserRoutes();
                      //   },
                      //   text: 'Route',
                      //   isSelected: ref.watch(routesTypeProvider.state).state == ScheduleTypes.Routes,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: defaultPadding(context),
            ),
            RefreshIndicator(
              onRefresh: (){
                return ref.read(routesRepository).getUserRoutes(true);
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: TableCalendar<UserRouteModel>(
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  onDayLongPressed: (DateTime? date, dh){
                    Get.bottomSheet(
                      ScheduleVisitWidget(date: date!),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );

                  },
                  eventLoader: ref.watch(userRoutesNotifierProvider.notifier).getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: CalendarStyle(
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: false,
                  ),
                  onDaySelected: _onDaySelected,
                  onRangeSelected: _onRangeSelected,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
              ),
            ),

            Expanded(
              child:  RefreshIndicator(
                onRefresh: (){
                  return ref.read(routesRepository).getUserRoutes(true);
                },
                child: ListView.builder(
                  // key: PageStorageKey(ind),
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: ref.watch(selectedEventsProvider).length,
                    itemBuilder: (builder, index){
                      // print("customer  schedule lenght: ${customerValue.length}");
                      List<UserRouteModel> userRoutes = ref.watch(selectedEventsProvider);
                      print("user routesd:$userRoutes");
                      if(userRoutes == []){
                        return Text("No schedules for day selected", style: Styles.heading2(context).copyWith(
                            color: Colors.black38
                        ),);
                      }

                      return GestureDetector(
                        onTap: ()async{
                          var checkinController = Get.find<CustomerCheckingController>();
                          Position position =
                              await customersProvider
                              .getGeoLocationPosition();

                          String cstIndex = userRoutes[index].account
                              .toString();
                          print('index: $cstIndex');
                          print(cstIndex.runtimeType);
                          CustomerCheckinModel checkinCode =
                              await checkinController.createCheckinSession(
                            // "${controller.lstcustomers[index].id!.toString()}",
                              position.latitude.toString(),
                              position.longitude.toString(),
                              // "4158",
                              cstIndex,
                              "xtUxiU");
                          await checkinController.addCheckingData(checkinCode.checkingCode!,
                            userRoutes[index].account!,
                            userRoutes[index].customerName!,
                            userRoutes[index].address!,
                            userRoutes[index].email ?? "",
                            userRoutes[index].telephone!,
                            userRoutes[index].latitude ?? "0.0",
                            userRoutes[index].longitude ?? "0.0",
                          );
                          Get.toNamed(RouteHelper.getCustomerDetails(),);

                        },
                        child: HomeScheduleCard(todaySchedules: userRoutes[index],)
                      );
                    }),
              )
            ),
          ],
        ),
      ),
    );
  }
  //
  // Widget scheduleVisit(DateTime date){
  //   TimeOfDay? _time= TimeOfDay(hour: 10, minute: 15);
  //   String formatted = "${DateFormat.MMMMEEEEd().format(date).toString()} at ${_time.hour}:${_time.minute}";
  //
  //   return
  //
  // }
}

class ScheduleVisitWidget extends ConsumerStatefulWidget {
  final DateTime date;
  const ScheduleVisitWidget({Key? key, required this.date}) : super(key: key);

  @override
  ConsumerState<ScheduleVisitWidget> createState() => _ScheduleVisitWidgetState();
}

class _ScheduleVisitWidgetState extends ConsumerState<ScheduleVisitWidget> {
  TimeOfDay _time= TimeOfDay(hour: 10, minute: 15);
  TextEditingController customerController = TextEditingController();
  TextEditingController routeNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String formatted = "${DateFormat.MMMMEEEEd().format(widget.date).toString()} at ${_time.hour}:${_time.minute}";

    return SingleChildScrollView(
      child: Padding(
        padding:EdgeInsets.all(13.0.sp),
        child: Container(
          height: MediaQuery.of(context).size.height * .29.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(formatted, style: Styles.heading4(context),),
                  SizedBox(width: 10.w,),
                  TextButton(
                    onPressed: ()async{
                      TimeOfDay? _timeSelecting =await showTimePicker(context: context, initialTime: _time);
                      setState(() {
                        _time = _timeSelecting!;
                      });
                    }, child: Text("Change Time", style: Styles.heading4(context).copyWith(color: Colors.blue),),)

                ],
              ),
              SizedBox(height: 15.h,),
              Text("Select customer to Visit", style: Styles.heading4(context),),
              SizedBox(height: 10.h,),
              TypeAheadField<CustomerDataModel>(
                textFieldConfiguration: TextFieldConfiguration(
                    controller: customerController,
                    autofocus: true,
                    style: DefaultTextStyle.of(context).style.copyWith(
                        fontStyle: FontStyle.italic
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.person_add, color: Styles.appPrimaryColor,),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Styles.appPrimaryColor),
                          borderRadius: BorderRadius.circular(10)
                      ),//label text of field
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Styles.appPrimaryColor),
                          borderRadius: BorderRadius.circular(10)
                      ),
                    )
                ),
                suggestionsCallback: (pattern) async {
                  List<CustomerDataModel> customers = await ref.watch(userRoutesNotifierProvider.notifier).getCustomersForSchedule();
                  return customers.where((customer){
                    final nameLower =  customer.customerName!.toLowerCase();
                    final queryLower =  pattern.toLowerCase();

                    return nameLower.contains(queryLower);
                  }).toList();
                },
                itemBuilder: (context, CustomerDataModel customers) {
                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text(customers.customerName!, style: Styles.heading3(context),),
                    subtitle: Text(customers.address!, style: Styles.heading4(context)),
                  );
                },
                onSuggestionSelected: (CustomerDataModel customer) {
                  ref.watch(selectedCustomerProvider.state).state = customer;
                  customerController.text = customer.customerName!;
                },
              ),
              SizedBox(height: 14,),
              Center(
                  child: TextField(
                    controller: routeNameController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.edit, color: Styles.appPrimaryColor,), //icon of text field
                      labelText: "Enter Description",
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Styles.appPrimaryColor),
                          borderRadius: BorderRadius.circular(10)
                      ),//label text of field
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Styles.appPrimaryColor),
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    //set it true, so that user will not able to edit text
                  )
              ),

          ref.watch(userRoutesNotifierProvider).isLoading?Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Scheduling . . .", style: Styles.bttxt1(context),),
            ],
          )
              :  Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: (){
                    Get.back();
                  },
                  child: Text("Cancel", style: Styles.normalText(context).copyWith(fontWeight: FontWeight.w700),)),
              TextButton(
                  onPressed: ()async{
                    DateTime combinedTime = DateTime(widget.date.year, widget.date.month, widget.date.day,
                        _time.hour, _time.minute);
                    if(routeNameController.text == ""){
                      showCustomSnackBar("Please provide the required fields", isError: true);
                    }else if(ref.read(selectedCustomerProvider.state).state.id == null){
                      showCustomSnackBar("Select a customer", isError: true);
                    }else{
                      print("the time: ${combinedTime.toString()}");
                      await ref.read(userRoutesNotifierProvider.notifier).addCustomerVisit(routeNameController.text, ref.read(selectedCustomerProvider).id!.toString(),
                          combinedTime.toString());
                      ref.read(userRoutesNotifierProvider.notifier).filterUserRoutes();
                      routeNameController.clear();
                      Get.back();
                    }


                  },
                  child: Text("Schedule Visit", style: Styles.bttxt1(context),))
            ],
              )
            ],
          ),
        ),
      ),
    );

  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);


class ExpandableText extends StatefulWidget {
  ExpandableText(this.text);

  final String text;
  bool isExpanded = false;

  @override
  _ExpandableTextState createState() => new _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      new ConstrainedBox(
          constraints: widget.isExpanded
              ? new BoxConstraints()
              : new BoxConstraints(maxHeight: 50.0),
          child: new Text(
            widget.text,
            softWrap: true,
            overflow: TextOverflow.fade,
          )),
      widget.isExpanded
          ? new Container()
          : new TextButton(
          child: const Text('...'),
          onPressed: () => setState(() => widget.isExpanded = true))
    ]);
  }
}