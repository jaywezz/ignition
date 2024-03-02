import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/find_me.dart';
import 'package:soko_flow/data/providers/deliveries/deliveries_provider.dart';
import 'package:soko_flow/models/derivery_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/currency_formatter.dart';
import 'package:soko_flow/views/customers/drive_to_customer.dart';
import 'package:soko_flow/views/deliveries/detailed_delivery/detailed_delivery_screen.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/receive_stock/receive_stock_details_screen.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ReceiveStock extends ConsumerStatefulWidget {
  ReceiveStock({Key? key}) : super(key: key);

  @override
  ConsumerState<ReceiveStock> createState() => _ReceiveStockState();
}

class _ReceiveStockState extends ConsumerState<ReceiveStock> {
  // final bool isSelected = false;
  // String customer_id = "";
  // String  customer_name= "";

  List<DeliveriesModel> selectedDeliveries = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool loadingMaps = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: selectedDeliveries.isEmpty
          ? SizedBox()
          : Container(
        height: MediaQuery.of(context).size.height * .1,
        padding: EdgeInsets.only(
            left: defaultPadding(context),
            right: defaultPadding(context),
            bottom: defaultPadding(context)),
        child: Column(children: [
          ref.watch(deliveriesNotifierProvider).isLoading
              ? CircularProgressIndicator()
              : FullWidthButton(
            action: () async {
              Get.to(ReceiveStockItems(deliveries: selectedDeliveries));
            },
            child: Text(
              "Next ( ${selectedDeliveries.length} Selected)",
              style: Styles.heading3(context)
                  .copyWith(color: Colors.white),
            ),
            // text: "Accept ${selectedDeliveries.length} Deliveries",
          ),
        ]),
      ),
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
                            "Receive Stock",
                            style: Styles.heading3(context),
                          ),
                        ),
                        // Align(
                        //   alignment: Alignment.topRight,
                        //   child: Material(
                        //     child: InkWell(
                        //       splashColor: Theme.of(context).splashColor,
                        //       onTap: () => Get.toNamed(RouteHelper.getInitial()),
                        //       child: Icon(
                        //         Icons.home_sharp,
                        //         size: defaultPadding(context) * 2,
                        //         color: Styles.appSecondaryColor,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    SizedBox(
                      height: defaultPadding(context),
                    ),
                    SizedBox(
                      height: defaultPadding(context) * 1.3,
                    ),


                    // "Waiting Acceptance"
                    ref.watch(deliveriesProvider).when(data: (data){
                      for(DeliveriesModel delivery in data){
                        print("st: ${delivery.deliveryCode}");
                        print("status: ${delivery.deliveryStatus}");
                      }
                      data = data.where((element) =>  element.deliveryStatus ==  "Waiting acceptance").toList();
                      for(DeliveriesModel delivery in data){
                        print("status2: ${delivery.deliveryStatus}");
                      }
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
                                  child: Text("No deliveries to accept", style: Styles.heading3(context).copyWith(color: Colors.black54)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }else{

                        return Expanded(
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:data.length,
                              itemBuilder: (context, index) {
                                double totalPrice = 0;
                                data[index].deliveryItems.forEach((item) {
                                  totalPrice += double.parse(item.sellingPrice!) * double.parse(item.allocatedQuantity!);
                                });


                                return GestureDetector(
                                    onTap: () {
                                      print("clicked");
                                      if (selectedDeliveries.isEmpty) {
                                        Get.to(ReceiveStockItems(deliveries: [data[index]]));
                                      } else {
                                        if(selectedDeliveries.contains(data[index])) {
                                          print("removing");
                                          selectedDeliveries.remove(data[index]);
                                        } else {
                                          print("adding");
                                          selectedDeliveries.add(data[index]);
                                        }
                                      }
                                      setState(() {});
                                    },
                                    onLongPress: () {
                                      if(selectedDeliveries.contains(data[index])){
                                        //  Do nothing
                                      }else{
                                        selectedDeliveries.add(data[index]);
                                        setState(() {});
                                      }
                                    },
                                    child: Card(
                                      color: selectedDeliveries.contains(data[index])
                                          ? Styles.appSecondaryColor.withOpacity(.2)
                                          : null,
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
                                                    Row(
                                                      children: [
                                                        Text(data[index].customer.customerName!, style: Styles.heading3(context).copyWith(color:  selectedDeliveries.contains(data[index])?Colors.white:Colors.black),
                                                        ),
                                                        SizedBox(width: 10,),
                                                        data[index].type == "van_sale"?Icon(
                                                          Icons.fire_truck,
                                                          color: Styles.appSecondaryColor,
                                                          size: 17,
                                                        ):Icon(
                                                          Icons.warehouse,
                                                          color: Styles.appSecondaryColor,
                                                          size: 17,
                                                        )

                                                      ],
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    Text(data[index].deliveryNote ?? "No info..", style: Styles.smallGreyText(context).copyWith(color:  selectedDeliveries.contains(data[index])?Colors.white:Colors.black),
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
                                                    Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Row(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                ref.watch(findMeProvider).whenData((value) {
                                                                  Navigator.of(context).push(
                                                                      MaterialPageRoute(builder: (context) =>
                                                                          CustomerTrackingPage(
                                                                            shopName:  data[index].customer.customerName!,
                                                                            sourceLocation: LatLng(value.latitude, value.longitude),
                                                                            destination: LatLng(double.parse(data[index].customer.latitude!), double.parse(data[index].customer.longitude!)),
                                                                          )));
                                                                });

                                                              },
                                                              icon: Icon(
                                                                Icons.directions_outlined,
                                                                size: 17,
                                                                color: Color(0XFFB01E68),
                                                              )),
                                                          GestureDetector(
                                                              onTap: () async {
                                                                print("calling");
                                                                final Uri launchUri = Uri(
                                                                  scheme: 'tel',
                                                                  path: data[index].customer.phoneNumber,
                                                                );
                                                                await launchUrl(launchUri);
                                                              },
                                                              child: Icon(
                                                                Icons.call,
                                                                size: 17,
                                                                color:  Color(0XFFB01E68),
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      DateFormat.yMMMEd().format( data[index].createdAt).toString(),
                                                      style: Styles.heading4(context).copyWith(fontSize:10,color:  selectedDeliveries.contains(data[index])?Colors.white:Colors.black), maxLines: 3,
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
                              }),
                        );
                      }
                    }, error: (error, stackTrace) {
                      print("stack: $stackTrace");
                      return  Text(error.toString(), style: Styles.heading3(context),);
                    },loading: (){
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
