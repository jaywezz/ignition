import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/data/providers/deliveries/deliveries_provider.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/currency_formatter.dart';
import 'package:soko_flow/views/deliveries/detailed_delivery/detailed_delivery_screen.dart';

class Deliveries extends ConsumerStatefulWidget {
  Deliveries({Key? key}) : super(key: key);

  @override
  ConsumerState<Deliveries> createState() => _DeliveriesState();
}

class _DeliveriesState extends ConsumerState<Deliveries> {
  final bool isSelected = false;
  String customer_id = "";
  String  customer_name= "";

  @override
  void initState() {
    // TODO: implement initState
    if(Get.arguments["customer_id"] != null){
      setState(() {
        customer_id = Get.arguments["customer_id"].toString();
      });
    }
    if(Get.arguments["customer_name"] != null){
      setState(() {
        customer_name = Get.arguments["customer_name"];
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          // height: double.infinity,
          width: double.infinity,

          //color: Styles.appBackgroundColor,
          child: RefreshIndicator(
            onRefresh: ()async{
              return await ref.refresh(deliveriesProvider);
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                    left: defaultPadding(context),
                    right: defaultPadding(context),
                    bottom: defaultPadding(context)),
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(30))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            "${customer_name} Deliveries",
                            style: Styles.heading3(context),
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
                                color: Styles.appSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: defaultPadding(context),
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Today',
                          style: Styles.heading3(context),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          DateFormat.MMMMEEEEd().format(DateTime.now()),
                          style: Styles.smallGreyText(context),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: defaultPadding(context) * 1.3,
                    ),


                    ref.watch(deliveriesProvider).when(data: (data){
                      data = data.where((element) =>  element.customer.id.toString() ==  customer_id.toString()).toList();
                      data = data.where((element) => element.deliveryStatus != "Waiting acceptance").toList();
                      data = data.where((element) => element.deliveryStatus != "rejected").toList();

                      if(data.isEmpty){
                        return RefreshIndicator(
                          onRefresh: ()async{
                            return await ref.refresh(deliveriesProvider);
                          },
                          child: ListView(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("No deliveries today", style: Styles.heading3(context).copyWith(color: Colors.black54)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }else{

                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:data.length,
                            // mydeliveries.length,
                            itemBuilder: (context, index) {
                              double totalPrice = 0;
                              data[index].deliveryItems.forEach((item) {
                                totalPrice += double.parse(item.sellingPrice!) * double.parse(item.allocatedQuantity!);
                              });

                              return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                        DetailedDeliveryScreen(delivery: data[index], initialScreen: 'customer_deliveries'));
                                  },
                                  child: Card(
                                    elevation: 2,
                                    child: Container(
                                      child: Row(
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 5,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.only(left: 10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(data[index].customer.customerName!, style: Styles.heading3(context),
                                                  ),
                                                  const SizedBox(height: 10,),
                                                  Text(data[index].deliveryNote ?? "No info..", style: Styles.smallGreyText(context),
                                                    maxLines: 3,
                                                  ),
                                                  SizedBox(height: 5.h,),

                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text("Kshs. ${formatCurrency.format(totalPrice)}", style: Styles.heading3(context).copyWith(color: Styles.appYellowColor),
                                                    maxLines: 3,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Padding(padding: const EdgeInsets.only(left: 5),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10.0.sp),
                                                    child: Container(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(1.0),
                                                        child:data[index].deliveryStatus == "cancelled"
                                                            ?Text("Cancelled", style: Styles.heading4(context).copyWith(color: Colors.redAccent),)
                                                            :data[index].deliveryStatus == "Partial delivery"
                                                            ?Text("Partial", style: Styles.heading4(context).copyWith(color: Styles.appSecondaryColor),)
                                                            :data[index].deliveryStatus == "DELIVERED"
                                                            ?Text("Delivered", style: Styles.heading4(context).copyWith(color: Colors.white),)
                                                            :Text("Pending", style: Styles.heading4(context).copyWith(color: Colors.grey),),
                                                      ),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(5.sp)),
                                                          color:data[index].deliveryStatus == "cancelled"
                                                              ? Colors.redAccent.withOpacity(.3)
                                                              :data[index].deliveryStatus == "Partial delivery"
                                                              ?Styles.appSecondaryColor.withOpacity(.3)
                                                              :data[index].deliveryStatus == "DELIVERED"
                                                              ?Colors.green
                                                              :Colors.grey.withOpacity(.3)
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                  Text(
                                                    DateFormat.yMMMEd().format( data[index].createdAt).toString(),
                                                    style: Styles.heading4(context).copyWith(color: Colors.black), maxLines: 3,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(defaultPadding(context) * 0.2), width: double.infinity,),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            10)),
                                  )
                              );

                              // -------------------------
                            });
                      }
                    }, error: (error, stackTrace) => Text(error.toString(), style: Styles.heading3(context),), loading: (){
                      return CircularProgressIndicator();
                    }),


                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final List cuisines2 = const [
    {"name": "Indian", "icon": "assets/icons/h.png"},
    {"name": "Italian", "icon": "assets/icons/i.png"},
    {"name": "kenyan", "icon": "assets/icons/d.png"},
    {"name": "French", "icon": "assets/icons/e.png"},
    {"name": "Ghanaian", "icon": "assets/icons/j.png"},
  ];

  final List cuisines1 = const [
    {"name": "All", "icon": "assets/icons/a.png"},
    {"name": "Past 1 Month", "icon": "assets/icons/b.png"},
    {"name": "Last 3 Months", "icon": "assets/icons/f.png"},
    {"name": "Last 6 Months", 'icon': "assets/icons/g.png"},
    {"name": "Last 1 year", "icon": "assets/icons/c.png"},
  ];
}

class ProductsWidget extends StatelessWidget {
  const ProductsWidget(
      {Key? key,
      required this.quantity,
      required this.text,
      required this.amount})
      : super(key: key);
  final String text;
  final String quantity;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: Styles.smallGreyText(context),
        ),
        Text(
          quantity,
          style: Styles.smallGreyText(context),
        ),
        Text(
          amount,
          style: Styles.smallGreyText(context),
        ),
      ],
    );
  }
}
