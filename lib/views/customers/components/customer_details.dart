import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as d;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:geofence_service/models/geofence.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/controllers/customer_checking_controller.dart';
import 'package:soko_flow/controllers/orders_controller.dart';
import 'package:soko_flow/controllers/product_controller.dart';
import 'package:soko_flow/controllers/routes_controller.dart';
import 'package:soko_flow/controllers/user_deliveries_controller.dart';
import 'package:soko_flow/data/providers/customer_provider.dart';
import 'package:soko_flow/data/providers/routes_provider.dart';
import 'package:soko_flow/data/providers/visit_order_count_provider.dart';
import 'package:soko_flow/data/repository/customer/user_onBoard_permisions_repo.dart';
import 'package:soko_flow/data/repository/get_data_count.dart';
import 'package:soko_flow/models/customer_model/customer_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/app_constants.dart';
import 'package:soko_flow/views/customers/components/checkout_form/checkout_form_screen.dart';
import 'package:soko_flow/views/customers/components/edit_customer_details.dart';

import 'package:soko_flow/views/customers/customers_screen.dart';
import 'package:soko_flow/views/customers/payment_screen.dart';
import 'package:soko_flow/views/customers/surveys/survey_questions.dart';
import 'package:soko_flow/views/customers/order_history_screen.dart';
import 'package:soko_flow/views/customers/surveys/surveys.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/logic/routes/routes.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/Customer_checkout_screen.dart';
import 'package:soko_flow/views/customers/sales/new_sales_order.dart';
import 'package:soko_flow/views/customers/sales_history_screen.dart';
import 'package:soko_flow/views/customers/shop_deliveries.dart';
import 'package:soko_flow/views/customers/sales/van_sales.dart';
import 'package:soko_flow/widgets/buttons/full_width_button.dart';
import 'package:http/http.dart' as http;

import '../../../controllers/product_category_controller.dart';
import '../../../data/api_handler.dart';
import '../../../data/providers/client_provider.dart';
import '../../../models/customer_checkin_details.dart';
import '../../../services/notification_services.dart';
import '../shpDeliveries.dart';

class CheckoutDialogWidget extends ConsumerStatefulWidget {
  final String checkinCode;
  const CheckoutDialogWidget({Key? key, required this.checkinCode})
      : super(key: key);

  @override
  ConsumerState<CheckoutDialogWidget> createState() => _CheckoutDialogWidgetState();
}

class _CheckoutDialogWidgetState extends ConsumerState<CheckoutDialogWidget> {
  bool isCheckingOut = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: double.maxFinite,
          child: Text(
            "Are you sure you want to Checkout?",
            style: Styles.normalText(context),
          )),
      actions: [
        TextButton(
          child: Text(
            "Cancel",
            style: Styles.heading3(context).copyWith(color: Colors.grey),
          ),
          onPressed: () => Get.back(),
        ),
        TextButton(
          child: Text(
            isCheckingOut ? "Checking out .." : "Checkout",
            style:
                Styles.heading3(context).copyWith(color: Styles.appYellowColor),
          ),
          onPressed: () async {
            setState(() {
              isCheckingOut = true;
            });
            setState(() {
              isCheckingOut = true;
            });
            if (widget.checkinCode != "") {
              try{
                // await ref.read(customerNotifier.notifier).submitCheckOutForm();
                await Get.find<CustomerCheckingController>()
                    .customerCheckout(widget.checkinCode);
                setState(() {
                  isCheckingOut = false;
                });
                Get.to(CustomersScreen());
              }catch(e){
                Get.back();
                showCustomSnackBar("An error occurred checking out", isError: true);
              }

            }
          },
        ),
      ],
    );
  }
}

class CustomerDetailsScreen extends ConsumerStatefulWidget {
  final CustomerDataModel customer;
  const CustomerDetailsScreen({Key? key, required this.customer})
      : super(key: key);
  @override
  ConsumerState<CustomerDetailsScreen> createState() =>
      _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends ConsumerState<CustomerDetailsScreen> {
  int? customerId;
  String? customerName;
  String? customerAddress;
  String? customerEmail;
  String? customerPhone;
  File? _pickedImage;
  String? checkingCode;
  double? lat;
  double? long;
  String? _timeString;
  late Timer _timer;
  int seconds = 0;
  String pendingAmount = "0";

  @override
  void dispose() async {
    super.dispose();
    _timer.cancel();
    String checkinCode = await checkingCode.toString();
    print("checking code: $checkinCode");
    if (checkinCode != "") {
      await Get.find<CustomerCheckingController>()
          .customerCheckout(checkinCode);
    }
  }

  @override
  void initState() {
    super.initState();
    getCustomerData();
    var now = DateTime.now();
    var twoHours = now.add(Duration(seconds: 0)).difference(now);
    seconds = twoHours.inSeconds;
    startTimer();

    // _customerCheckinDetails();
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  // String isCreditor = "not_creditor";

  @override
  void didChangeDependencies() {
    // ref.watch(customerCreditStatusProvider(customerId.toString())).whenData((value){
    //   /// Creditor statuses: not_creditor, waiting_approval, approved. disapproved
    //   setState(() {
    //     isCreditor = value.data["data"];
    //   });
    // });
    super.didChangeDependencies();
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage!.path);
    TimeOfDay time = const TimeOfDay(hour: 10, minute: 15);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  void _remove() {
    setState(() {
      _pickedImage = null;
    });
    Navigator.pop(context);
  }

  getCustomerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    checkingCode = prefs.getString('checkinCode');
    customerId = prefs.getInt('customerId');
    customerName = prefs.getString('customerName');
    customerAddress = prefs.getString('customerAddress');
    customerEmail = prefs.getString('customerEmail');
    customerPhone = await prefs.getString('customerPhone');
    lat = await double.parse(prefs.getString('lat')!);
    long = await double.parse(prefs.getString('long')!);

    await Get.find<OrdersController>()
        .getPendingVanPayments(customerId!.toString())
        .then((value) => pendingAmount = value.toString());
  }


  @override
  Widget build(BuildContext context) {
    //Logger().e("CustomerId: " + customerId.toString());
    final List<Map> myInventoryItems = [
      {'icon': Icons.local_shipping_outlined, 'name': 'Van Sales'},
      {'icon': Icons.shopping_cart, 'name': 'Pre-Orders'},
      {'icon': Icons.check_box_rounded, 'name': 'Deliveries'},
      {'icon': Icons.local_shipping_rounded, 'name': 'Sales History'},
      {'icon': Icons.shopping_cart, 'name': 'Pre-Order History'},
      {'icon': Icons.restart_alt_outlined, 'name': 'Schedule Visit'},
      {'icon': Icons.restart_alt_outlined, 'name': 'Merchandising'},
    ];
    // Get.lazyPut(() => ProductController(productRepo: Get.find()));
    // Get.lazyPut(
    //     () => ProductCategoryController(productCategoryRepo: Get.find()));
    List<GridData> choices = [
      GridData(
          value: "van_sales",
          title: 'Van Sales',
          image: 'assets/icons/van_sales.png',
          onPressed: () async {
            // await Get.find<ProductCategoryController>().getProductCategories();
            // await Get.find<ProductController>().getProducts();
            Get.to(VanSales(customer: widget.customer), arguments: {
              "customer_id": customerId,
              "customer_name": customerName
            });
          },
          canPerformAction: true),
      GridData(
          value: "van_sales",
          title: 'Van Sales History',
          image: 'assets/icons/sales_history.png',
          onPressed: () {
            Get.to(SalesHistoryScreen(), arguments: {
              "customer_id": customerId,
              "customer_name": customerName
            });
          },
          canPerformAction: true),
      GridData(
          value: "new_sales",
          title: 'Pre-Orders',
          image: 'assets/icons/new_sales_order.png',
          onPressed: () async {
            // await Get.find<ProductController>().getProducts();
            // await Get.find<ProductCategoryController>().getProductCategories();
            Get.to(
                NewSalesOrder(
                  nopayment: true,
                  customer: widget.customer,
                ),
                arguments: {
                  "customer_id": customerId,
                  "customer_name": customerName,
                });
          },
          canPerformAction: true),
      GridData(
          value: "new_sales",
          title: 'Pre-Order History',
          image: 'assets/icons/order_history.png',
          onPressed: () {
            print("orders screens");
            Get.to(OrdersScreen(), arguments: {
              "customer_id": customerId,
              "customer_name": customerName
            });
          },
          canPerformAction: true
          //OrderHistory(),
          ),
      GridData(
          value: "deliveries",
          title: 'Deliveries',
          image: 'assets/icons/deliveries.png',
          onPressed: () {
            Get.to(Deliveries(), arguments: {
              "customer_id": customerId,
              "customer_name": customerName
            });
          },
          canPerformAction: true),
      GridData(
          value: "schedule_visits",
          title: 'Schedule Visit',
          image: 'assets/icons/schedule.png',
          onPressed: () {
            print("bottom sheet");
            // openBottomSheet();
          },
          canPerformAction: true),
      GridData(
          value: "merchanizing",
          title: 'Merchandising',
          image: 'assets/icons/merchadizing.png',
          onPressed: () {
            Get.to(SurveysScreen(), arguments: {
              "customer_id": customerId,
              "customer_name": customerName
            });
          },
          canPerformAction: true),
      // GridData(
      //     value: "schedule_visits",
      //     title: 'Payments',
      //     image: 'assets/icons/merchadizing.png',
      //     onPressed: () {
      //       Get.to(PaymentScreen());
      //     },
      //     canPerformAction: true),
    ];
    return WillPopScope(
      onWillPop: () async {
        bool exit_app = false;

        if (checkingCode == "") {
          return true;
        } else {
          // Get.to(CheckoutFormScreen());
          Get.dialog(CheckoutDialogWidget(checkinCode: checkingCode!));

        }
        return exit_app;
      },
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            //color: Styles.appBackgroundColor,
            child: GetBuilder<CustomerCheckingController>(
                builder: (checkingController) {
              return Container(
                padding: EdgeInsets.only(
                    left: defaultPadding(context),
                    right: defaultPadding(context),
                    bottom: defaultPadding(context)),
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(30))),
                child: StreamBuilder<Geofence>(
                    stream: checkingController.geofenceStreamController.stream,
                    builder: (context, snapshot) {
                      bool isCurrentCustomer = false;
                      bool isCloseCustomer = false;
                      if (checkingController.checkUserCustomerLocation(
                              customerId.toString(), lat ?? 0.0, long ?? 0.0) ==
                          UserCustomerLocation.CLOSE) {
                        isCloseCustomer = true;
                      } else if (checkingController.checkUserCustomerLocation(
                              customerId.toString(), lat ?? 0.0, long ?? 0.0) ==
                          UserCustomerLocation.CURRENT) {
                        if (checkingCode == null) {
                          Get.dialog(AlertDialog(
                            title: Text(
                              "Customer available",
                              style: Styles.heading2(context),
                            ),
                            content: Container(
                                width: double.maxFinite,
                                child: Text(
                                  "Selected customer is available. Do you wish to check in",
                                  style: Styles.normalText(context),
                                )),
                            actions: [
                              TextButton(
                                child: Text(
                                  "Cancel",
                                  style: Styles.heading3(context)
                                      .copyWith(color: Colors.grey),
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  "Check in",
                                  style: Styles.heading3(context)
                                      .copyWith(color: Styles.appYellowColor),
                                ),
                                onPressed: () async {
                                  isCurrentCustomer = true;
                                  await checkingController.createCheckinSession(
                                      lat.toString(),
                                      long.toString(),
                                      customerId.toString(),
                                      "xtUxiU");
                                  await checkingController.addCheckingData(
                                    "",
                                    customerId!,
                                    customerName!,
                                    customerAddress!,
                                    customerEmail!,
                                    customerPhone!,
                                    lat!.toString(),
                                    long!.toString(),
                                  );
                                },
                              ),
                            ],
                          ));
                        }
                        {
                          isCurrentCustomer = true;
                        }
                      }
                      // checkingController.checkUserCustomerLocation(customerId.toString(), lat!, long!);
                      return Stack(
                        children: [
                          ListView(children: [
                            SizedBox(
                              height: defaultPadding(context),
                            ),
                            Stack(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (checkingCode == "") {
                                      Get.back();
                                    } else {
                                        // Get.to(CheckoutFormScreen());
                                      Get.dialog(CheckoutDialogWidget(checkinCode: checkingCode!));


                                    }
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Styles.darkGrey,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      customerName.toString(),
                                      style: Styles.heading2(context),
                                    ),
                                  ),
                                ),
                                ref.watch(customerCreditStatusProvider(customerId.toString())).when(
                                    data: (data){
                                      return data.data["data"] == "approved"?Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/Group 516.svg",
                                                color: Styles.appSecondaryColor,
                                                height: 13.4,
                                                width: 13.25,
                                              ),
                                              SizedBox(width: 3,),
                                              Text("Approved", style: Styles.heading4(context).copyWith(fontSize:10,color: Styles.appSecondaryColor),)
                                            ],
                                          ),
                                        ),
                                      ):Align(
                                        alignment: Alignment.topRight,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (data.data["data"] == "approved") {
                                              Fluttertoast.showToast(msg: "Creditor status active");

                                            }else if(data.data["data"] == "waiting_approval"){
                                              Fluttertoast.showToast(msg: "Waiting approval");
                                            } else if(data.data["data"] == "not_creditor" || data.data["data"] == "0"){
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: StatefulBuilder(
                                                          builder: (BuildContext context, StateSetter setState) {
                                                            bool isAddingCreditor = false;
                                                            return Column(
                                                              children: [
                                                                Text("Become Creditor",
                                                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Text(
                                                                    "Are you sure you want to convert this customer to a creditor customer?",
                                                                    textAlign: TextAlign.center,
                                                                    style: Theme.of(context).textTheme.bodyLarge),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                isAddingCreditor?CircularProgressIndicator(
                                                                  value: 1,
                                                                ):FullWidthButton(
                                                                    color: Styles.appButtonColor,
                                                                    action: () async {
                                                                      setState(){
                                                                        isAddingCreditor = true;
                                                                      }
                                                                      try {
                                                                        d.Response res = await ref.watch( onBoardPermissionsRepositoryProvider).requestCreditorStatus(customerId.toString());
                                                                        Fluttertoast.showToast(msg: res.data["message"], backgroundColor: Colors.green);
                                                                        await ref.refresh(customerCreditStatusProvider(customerId.toString()));
                                                                        Navigator.pop(context);
                                                                        setState(){
                                                                          isAddingCreditor = false;
                                                                        }
                                                                      } catch (e) {
                                                                        setState(){
                                                                          isAddingCreditor = false;
                                                                        }
                                                                        Fluttertoast.showToast(msg: e.toString(), backgroundColor: Styles.appButtonColor);
                                                                      }
                                                                    },
                                                                    text: "Submit")
                                                              ],
                                                            );
                                                          }
                                                      ),
                                                    );
                                                  });
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: data.data["data"] == "not_creditor"
                                                ? Styles.appPrimaryColor
                                                : Color.fromARGB(255, 139, 19, 10),
                                            shape: new RoundedRectangleBorder(
                                              borderRadius:
                                              new BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          child: Icon(data.data["data"] == "waiting_approval"
                                              ? Icons.check
                                              : Icons.add),
                                        ),
                                      );
                                    },
                                    error: (e,s){
                                      return Text("");
                                    },
                                    loading: (){
                                      return Align(
                                        alignment: Alignment.topRight,
                                        child: CircularProgressIndicator(
                                          value: 1,
                                        ),
                                      );
                                    })

                              ],
                            ),
                            SizedBox(
                              height: defaultPadding(context),
                            ),
                            Card(
                              child: Container(
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: defaultPadding(context),
                                      left: defaultPadding(context),
                                      right: defaultPadding(context)),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Choose option',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Styles
                                                            .appSecondaryColor),
                                                  ),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: [
                                                        InkWell(
                                                          onTap:
                                                              _pickImageCamera,
                                                          splashColor:
                                                              Colors.black,
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Icon(
                                                                  Icons.camera,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Camera',
                                                                style: Styles
                                                                    .heading3(
                                                                        context),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap:
                                                              _pickImageGallery,
                                                          splashColor:
                                                              Colors.black,
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Icon(
                                                                  Icons.image,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Gallery',
                                                                style: Styles
                                                                    .heading3(
                                                                        context),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: _remove,
                                                          splashColor:
                                                              Colors.black,
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .remove_circle,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Remove',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .red),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child:  Container(
                                          height: defaultPadding(context) * 8,
                                          width: defaultPadding(context) * 10,
                                          decoration: BoxDecoration(
                                              image:widget.customer.image == null?null: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/logo/Fav.png")),
                                              color: Styles.appBackgroundColor,
                                              border: Border.all(
                                                  width: 2,
                                                  color: Styles.appSecondaryColor)),
                                          // child: Center(
                                          //   child: Icon(
                                          //     Icons.camera,
                                          //     color: Colors.black,
                                          //   ),
                                          // ),
                                          child: widget.customer.image==null?SizedBox():CachedNetworkImage(imageUrl: "${AppConstants.STORAGE_URL}/storage/${widget.customer.image}",),
                                        ),
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Icon(
                                      //       Icons.shop,
                                      //       color: Styles.appPrimaryColor,
                                      //     ),
                                      //     SizedBox(
                                      //       width: defaultPadding(context),
                                      //     ),
                                      //     Text(
                                      //       'Shop',
                                      //       style: Styles.heading4(context),
                                      //     )
                                      //   ],
                                      // ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_city_rounded,
                                            color: Styles.appSecondaryColor,
                                          ),
                                          SizedBox(
                                            width: defaultPadding(context),
                                          ),
                                          Text(
                                            customerAddress ??
                                                '23 Olenguruone Rd, Nairobi Kenya',
                                            style: Styles.heading4(context)
                                                .copyWith(
                                                    color: Colors.black54),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Styles.appSecondaryColor,
                                          ),
                                          SizedBox(
                                            width: defaultPadding(context),
                                          ),
                                          Text(
                                            'Owner: ${customerName ?? "John"}',
                                            style: Styles.heading4(context)
                                                .copyWith(
                                                    color: Colors.black54),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.credit_card,
                                            color: Styles.appSecondaryColor,
                                          ),
                                          SizedBox(
                                            width: defaultPadding(context),
                                          ),
                                          Text(
                                            'Pending Payments: Ksh. ${pendingAmount}',
                                            style: Styles.heading4(context)
                                                .copyWith(
                                                    color: Colors.black54),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: defaultPadding(context),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                _makePhoneCall(customerPhone!);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Styles.appButtonColor,
                                                shape:
                                                    new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                              child: Text(
                                                "Call",
                                                style: Styles.heading3(context)
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                _sendSMS(customerPhone!);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Styles.appButtonColor,
                                                shape:
                                                    new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                              child: Text(
                                                "Message",
                                                style: Styles.heading3(context)
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Get.to(EditDetailsScreen());
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Styles.appButtonColor,
                                                shape:
                                                    new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                              child: Text(
                                                "Edit Info",
                                                style: Styles.heading3(context)
                                                    .copyWith(
                                                        color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ref
                                .watch(customerVisitsOrderProvider(
                                    customerId.toString()))
                                .when(data: (data) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        data.data["checkingCount"].toString(),
                                        style: Styles.heading3(context)
                                            .copyWith(color: Colors.black54),
                                      ),
                                      Text(
                                        'Total Visits Made',
                                        style: Styles.heading4(context)
                                            .copyWith(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        data.data["orderCount"].toString(),
                                        style: Styles.heading3(context)
                                            .copyWith(color: Colors.black54),
                                      ),
                                      Text(
                                        'Total Orders Placed',
                                        style: Styles.heading4(context)
                                            .copyWith(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }, error: (e, error) {
                              return Text(
                                  "An error occured getting counts ${e.toString()}");
                            }, loading: () {
                              return Center(
                                  child: Text("Getting customer data ...",
                                      style: Styles.heading3(context)));
                            }),
                            SizedBox(
                              height: defaultPadding(context) * .5,
                            ),
                            ref.watch(userOnBoardPermissionsProvider).when(
                                data: (data) {
                              if (data.data["permissions"].length == 0) {
                                return Padding(
                                  padding: EdgeInsets.all(18.0.sp),
                                  child: Center(
                                      child: Text(
                                    "No permissions added.",
                                    style: Styles.heading3(context)
                                        .copyWith(color: Colors.grey[500]),
                                  )),
                                );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: defaultPadding(context) * 5),
                                  child: SizedBox(
                                    child: StaggeredGrid.count(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 8,
                                        children: [
                                          for (GridData choice in choices)
                                            GridCard(
                                              choice: choice,
                                              hasPermission:
                                                  data.data["permissions"][0][choice.value] == "YES",
                                              isActive: isCurrentCustomer,
                                            )
                                        ]),
                                  ),
                                );
                              }
                            }, error: (error, stack) {
                              return Center(
                                  child: Text(
                                error.toString(),
                                style: Styles.heading3(context)
                                    .copyWith(color: Colors.red),
                              ));
                            }, loading: () {
                              return Center(child: CircularProgressIndicator());
                            })
                          ]),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: isCurrentCustomer
                                  ? FullWidthButton(
                                      color: Styles.appButtonColor,
                                      action: () async {
                                        // Get.to(CheckoutFormScreen());
                                        Get.dialog(CheckoutDialogWidget(checkinCode: checkingCode!));

                                      },
                                      text:
                                          'Checkout: ${constructTime(seconds)}',
                                    )
                                  : FullWidthButton(
                                      color: Styles.appButtonColor,
                                      action: () async {
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return CustomersScreen();
                                        }));
                                      },
                                      text: 'Back',
                                    ))
                        ],
                      );
                    }),
              );
            }),
          ),
        ),
      ),
    );
  }

  String constructTime(int seconds) {
    int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return formatTime(hour) +
        ":" +
        formatTime(minute) +
        ":" +
        formatTime(second);
  }

  String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  void startTimer() {
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      setState(() {
        seconds++;
      });
      if (seconds == 18000) {
        _timer.cancel();
        // cancelTimer();
      }
    });
  }

  Future launchEmail(String toEmail, String subject, String message) async {
    final url =
        "mailto:${toEmail}?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}";
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future<void> _sendSMS(String phoneNumber) async {
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: Uri.encodeComponent(phoneNumber),
      queryParameters: <String, String>{
        'body': Uri.decodeComponent(''),
      },
    );
    await launchUrl(smsLaunchUri);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    print("calling");
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
//         ),
//       ),
//     );
//   }
// }

class GridData {
  final String title;
  final String value;
  var image;
  final VoidCallback onPressed;
  //To override disabled cards regardless of location
  final bool canPerformAction;

  GridData({
    required this.title,
    required this.value,
    required this.image,
    required this.onPressed,
    required this.canPerformAction,
  });
}

class GridCard extends ConsumerStatefulWidget {
  const GridCard(
      {Key? key,
      this.choice,
      required this.hasPermission,
      required this.isActive})
      : super(key: key);
  final GridData? choice;
  final bool isActive;
  final bool hasPermission;

  @override
  ConsumerState<GridCard> createState() => _GridCardState();
}

class _GridCardState extends ConsumerState<GridCard> {
  // TextEditingController dateInputController = TextEditingController();
  TextEditingController routeNameController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  DateTime _dateTime = DateTime.now();
  TimeOfDay time = const TimeOfDay(hour: 10, minute: 15);
  int? customerId = 0;
  getCustomerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      customerId = prefs.getInt('customerId');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getCustomerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // dateInputController.text = "${DateFormat.MMMMEEEEd().format(_selectedDate!).toString()} at ${DateFormat.Hm().format(_dateTime)}";
    return widget.hasPermission
        ? GestureDetector(
            onTap: widget.choice!.title == "Schedule Visit"
                ? () {
                    Get.bottomSheet(
                      ScheduleVisitWidget(
                        customerId: customerId.toString(),
                      ),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }
                : widget.choice!.canPerformAction
                    ? widget.choice!.onPressed
                    : widget.isActive
                        ? widget.choice!.onPressed
                        : () => showCustomSnackBar("Not available"),
            child: SizedBox(
              height: 100,
              width: 100,
              child: Card(
                color: widget.choice!.canPerformAction
                    ? Styles.appSecondaryColor
                    : widget.isActive
                        ? Styles.appSecondaryColor
                        : Colors.grey,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(defaultPadding(context)),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Image.asset(
                            widget.choice!.image,
                            color: Colors.white,
                          )
                              // Icon(choice!.image,
                              //     size: defaultPadding(context) * 2.5,
                              //     color: Colors.black45)
                              ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(widget.choice!.title,
                              style: Styles.heading3(context)
                                  .copyWith(color: Colors.white)),
                        ]),
                  ),
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }
}

class ScheduleVisitWidget extends ConsumerStatefulWidget {
  final String customerId;
  const ScheduleVisitWidget({Key? key, required this.customerId})
      : super(key: key);

  @override
  ConsumerState<ScheduleVisitWidget> createState() =>
      _ScheduleVisitWidgetState();
}

class _ScheduleVisitWidgetState extends ConsumerState<ScheduleVisitWidget> {
  NotifyHelper notifyHelper = NotifyHelper();
  String _time = DateFormat("hh:mm a").format(DateTime.now()).toString();
  TextEditingController dateInputController = TextEditingController();
  TextEditingController routeNameController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    dateInputController.text =
        "${DateFormat.MMMMEEEEd().format(_selectedDate ?? DateTime.now()).toString()} at ${_time}";

    return Padding(
      padding: EdgeInsets.all(13.0.sp),
      child: Container(
        height: MediaQuery.of(context).size.height * .29.h,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      dateInputController.text,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.heading4(context),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        var pickedTime = await showTimePicker(
                            context: context,
                            initialEntryMode: TimePickerEntryMode.input,
                            initialTime: TimeOfDay(
                                hour: int.parse(_time.split(":")[0]),
                                minute: int.parse(
                                    _time.split(":")[1].split(" ")[0])));

                        String formmattedTime = pickedTime!.format(context);
                        if (pickedTime == null) {
                          print("Something is wrong");
                        } else {
                          setState(() {
                            _time = formmattedTime;
                          });
                        }
                      },
                      child: Text(
                        "Change Time",
                        style: Styles.heading4(context)
                            .copyWith(color: Colors.blue),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                "Select visiting date",
                style: Styles.heading4(context),
              ),
              SizedBox(
                height: 10.h,
              ),
              Center(
                  child: TextField(
                controller: dateInputController,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.calendar_today,
                    color: Styles.appSecondaryColor,
                  ), //icon of text field
                  labelText: "Enter Visiting Date",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Styles.appSecondaryColor),
                      borderRadius:
                          BorderRadius.circular(10)), //label text of field
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Styles.appSecondaryColor),
                      borderRadius: BorderRadius.circular(10)),
                ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? selectingDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      //DateTime.now() - not to allow to choose before today.
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Styles.appPrimaryColor, // <-- SEE HERE
                              onPrimary: Colors.white, // <-- SEE HERE
                              onSurface: Colors.black, // <-- SEE HERE
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red, // button text color
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                      lastDate: DateTime(2100));
                  setState(() {
                    _selectedDate = selectingDate;
                  });
                  // if (pickedDate != null) {
                  //   print(
                  //       pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  //   String formattedDate =
                  //   DateFormat('yyyy-MM-dd').format(pickedDate);
                  //   print(
                  //       formattedDate); //formatted date output using intl package =>  2021-03-16
                  //   setState(() {
                  //     dateInputController.text =
                  //         formattedDate; //set output date to TextField value.
                  //   });
                  // } else {}
                },
              )),
              SizedBox(
                height: 14,
              ),
              Center(
                  child: TextField(
                controller: routeNameController,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.edit,
                    color: Styles.appSecondaryColor,
                  ), //icon of text field
                  labelText: "Enter Description",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Styles.appSecondaryColor),
                      borderRadius:
                          BorderRadius.circular(10)), //label text of field
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Styles.appSecondaryColor),
                      borderRadius: BorderRadius.circular(10)),
                ),
                //set it true, so that user will not able to edit text
              )),
              ref.watch(userRoutesNotifierProvider).isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Scheduling . . .",
                          style: Styles.bttxt1(context),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              "Cancel",
                              style: Styles.normalText(context)
                                  .copyWith(fontWeight: FontWeight.w700),
                            )),
                        TextButton(
                            onPressed: () async {
                              DateTime combinedTime = DateTime(
                                _selectedDate!.year,
                                _selectedDate!.month,
                                _selectedDate!.day,
                                int.parse(_time.split(":")[0]),
                                int.parse(_time.split(":")[1].split(" ")[0]),
                              );
                              if (routeNameController.text == "") {
                                showCustomSnackBar(
                                    "Please provide the required fields",
                                    isError: true);
                              } else {
                                // DateTime date =
                                //     DateFormat.jm().parse(_time.toString());
                                print(_time);
                                // var myTime = DateFormat("HH:mm").format(date);
                                notifyHelper.scheduledNotification(
                                  int.parse(_time.split(":")[0]),
                                  int.parse(_time.split(":")[1].split(" ")[0]),
                                  routeNameController.text,
                                );
                                notifyHelper.displayNotification(
                                    title:
                                        "You have successfully scheduled a visit",
                                    body:
                                        "You will get a reminder on ${combinedTime.toString()}");
                                // print("MyTime is :$myTime");
                                print("the time: ${combinedTime.toString()}");
                                await ref
                                    .read(userRoutesNotifierProvider.notifier)
                                    .addCustomerVisit(
                                        routeNameController.text,
                                        widget.customerId,
                                        combinedTime.toString());
                                ref
                                    .read(userRoutesNotifierProvider.notifier)
                                    .filterUserRoutes();
                                routeNameController.clear();
                                Get.back();
                              }
                            },
                            child: Text(
                              "Schedule Visit",
                              style: Styles.bttxt1(context),
                            ))
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
