import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/constants.dart';

import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/customer_provider.dart';
import 'package:soko_flow/controllers/geolocation_controller.dart';
// import 'package:soko_flow/data/comments_provider.dart';
import 'package:soko_flow/data/providers/customer_provider.dart';
import 'package:soko_flow/models/company_outlets/company_outlets_model.dart';
import 'package:soko_flow/models/company_routes/company_routes_model.dart';

import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/services/auth_service.dart';
import 'package:soko_flow/utils/size_utils2.dart';

import 'package:soko_flow/widgets/inputs/custom_dropdown.dart';
import 'package:soko_flow/widgets/inputs/defaut_input_field.dart';
Logger _log = Logger(printer: PrettyPrinter());

enum ProfilePictureOptions { REMOVE, TAKE_CAMERA_PHOTO }

class EditDetailsScreen extends ConsumerStatefulWidget {
  const EditDetailsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditDetailsScreen> createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends ConsumerState<EditDetailsScreen> {
  int? customerId;
  String? customerName;
  String? customerAddress;
  String? customerEmail;
  String? customerPhone;

  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController alternativePhoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  CompanyOutletsModel? selectedOutlet = null;
  List<Subregion> subRegions = [];
  List<RegionalRoutes> routes = [];

  Subregion? selectedSubegion;
  RegionalRoutes? selectedRoute;

  Position? userCurrentPosition;
  //!Get user current position
  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    userCurrentPosition = cPosition;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    locateUserPosition();
    getCustomerData();
    super.initState();
  }

  getCustomerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt('customerId');
    customerNameController.text= prefs.getString('customerName')!;
    customerAddress = prefs.getString('customerAddress');
    emailController.text = prefs.getString('customerEmail')!;
    phoneNumberController.text = await prefs.getString('customerPhone')!;
    contactPersonController.text = await prefs.getString('contactPerson')!;
  }
  bool editLocation = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    ref.watch(companyRoutesProvider).whenData((value) {
      setState(() {
        if (value.isNotEmpty) {
          selectedSubegion = value[0];
          subRegions.addAll(value);
          if (subRegions.isNotEmpty) {
            routes.addAll(subRegions[0].area!);
          }
        }
      });
    });
    super.didChangeDependencies();
  }

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GeolocationController controller = Get.put(GeolocationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Theme.of(context).splashColor,
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Styles.darkGrey,
            ),
          ),
        ),
        title: Center(
          child: Text(
            'Edit Customer',
            style: Styles.heading2(context),
          ),
        ),
        actions: [

        ],
      ),
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/logo/bg.png'),
                      fit: BoxFit.cover),
                  borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(30))),
              child: GetBuilder<GeolocationController>(builder: (controller) {
                return SizedBox(
                    height: double.infinity,
                    width: double.infinity,

                    //color: Styles.appBackgroundColor,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: defaultPadding(context),
                          right: defaultPadding(context),
                          bottom: defaultPadding(context)),
                      child: ListView(
                        children: [
                          SizedBox(
                            height: defaultPadding(context),
                          ),

                          // SizedBox(
                          //   height: defaultPadding(context) * 2,
                          // ),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10, left: 20, right: 20, bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // profile image
                                  SizedBox(height: defaultPadding(context)),
                                  DefaultInputField(
                                    title: "Outlet Name",
                                    hintText: "Outlet Name",
                                    textEditingController:
                                    customerNameController,
                                    validator: (onValidateVal) {
                                      if (onValidateVal.isEmpty) {
                                        return "Outlet Name required";
                                      }
                                    },

                                    // onsaved: (v) {
                                    //   controller.customerName = v!;
                                    // }
                                  ),

                                  DefaultInputField(
                                    title: "Contact Person Name",
                                    hintText: "John Doe",
                                    textEditingController: contactPersonController,
                                    validator: (onValidateVal) {
                                      if (onValidateVal.isEmpty) {
                                        return "Contact Person Name required";
                                      }
                                    },
                                    // onsaved: (v) {
                                    //   controller.contactPerson = v!;
                                    // }
                                  ),

                                  DefaultInputField(
                                    title: "Contact Person Number",
                                    textEditingController:
                                    phoneNumberController,
                                    validator: (onValidateVal) {
                                      if (onValidateVal.isEmpty) {
                                        return "Contact Person Number required";
                                      }
                                    },
                                    // onsaved: (v) {
                                    //   controller.phoneNumber = v!;
                                    // },
                                    hintText: "07********45",
                                    inputtype: true,
                                  ),
                                  DefaultInputField(
                                    title:
                                    "Alternative Contact Person Number",
                                    textEditingController:
                                    alternativePhoneNumberController,
                                    hintText: "07********45",
                                    inputtype: true,
                                  ),

                                  DefaultInputField(
                                    title: "Contact Person Email",
                                    hintText: "j***@sokoflow.com(Optional)",
                                    textEditingController: emailController,
                                  ),



                                  Text(
                                    "Select outlet type",
                                    style: Styles.heading3(context),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ref.watch(companyOutletsProvider).when(
                                      data: (data) {
                                        if (data!.isEmpty) {
                                          return Text(
                                            "No outlets added",
                                            style: Styles.heading3(context)
                                                .copyWith(color: Colors.black38),
                                          );
                                        } else {
                                          return SizedBox(
                                            height: Responsive.isMobile(context)
                                                ? 45.h
                                                : 55.h,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .white, //background color of dropdown button
                                                border: Border.all(
                                                    color: Styles.darkGrey
                                                        .withOpacity(
                                                        .3)), //border of dropdown button
                                                borderRadius:
                                                BorderRadius.circular(10.r),
                                              ),
                                              child: DropdownButtonFormField<
                                                  CompanyOutletsModel>(
                                                isExpanded: true,
                                                decoration: InputDecoration(
                                                  disabledBorder:
                                                  InputBorder.none,
                                                  enabledBorder: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                ),
                                                hint: Row(
                                                  children: const [
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 8.0),
                                                      child: Icon(
                                                          Icons.arrow_drop_down),
                                                    ),
                                                  ],
                                                ), // Not necessary for Option 1
                                                style: Styles.heading1(context)
                                                    .copyWith(
                                                    color: Colors.black54),
                                                value: selectedOutlet,
                                                onChanged: (value) {
                                                  selectedOutlet = value;
                                                },
                                                items: data.map(
                                                        (CompanyOutletsModel? value) {
                                                      return DropdownMenuItem(
                                                        value: value,
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 15.0),
                                                          child: Text(
                                                            value!.outletName!,
                                                            style: Styles.heading3(
                                                                context)
                                                                .copyWith(
                                                                color: Colors
                                                                    .black45),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                icon: const Padding(
                                                  //Icon at tail, arrow bottom is default icon
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                    child: Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: Colors.black38,
                                                    )),
                                              ),
                                            ),
                                          );
                                        }
                                      }, error: (error, stack) {
                                    return Text(
                                      "An error occured getting Outlets Types",
                                      style: Styles.heading3(context)
                                          .copyWith(color: Colors.red),
                                    );
                                  }, loading: () {
                                    return Text(
                                      "Getting outlet types ...",
                                      style: Styles.heading3(context)
                                          .copyWith(color: Colors.black38),
                                    );
                                  }),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  editLocation == false?SizedBox()
                                      :Column(
                                    children: [
                                      Text(
                                        "Select customer region",
                                        style: Styles.heading3(context),
                                      ),
                                      ref.watch(companyRoutesProvider).when(
                                          data: (data) {
                                            if (data.isEmpty) {
                                              return Text(
                                                "No routes added",
                                                style: Styles.heading3(context)
                                                    .copyWith(color: Colors.black38),
                                              );
                                            } else {
                                              print("the data: ${data.length}");
                                              // selectedSubegion = data[0];
                                              return Column(
                                                children: [
                                                  SizedBox(
                                                    height:
                                                    Responsive.isMobile(context)
                                                        ? 45.h
                                                        : 55.h,
                                                    child: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .white, //background color of dropdown button
                                                        border: Border.all(
                                                            color: Styles.darkGrey
                                                                .withOpacity(
                                                                .3)), //border of dropdown button
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                      ),
                                                      child: DropdownButtonFormField<Subregion>(
                                                        isExpanded: true,
                                                        decoration:
                                                        const InputDecoration(
                                                          disabledBorder:
                                                          InputBorder.none,
                                                          enabledBorder:
                                                          InputBorder.none,
                                                          focusedBorder:
                                                          InputBorder.none,
                                                        ),
                                                        hint: Row(
                                                          children: const [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                  8.0),
                                                              child: Icon(Icons.arrow_drop_down),
                                                            ),
                                                          ],
                                                        ), // Not necessary for Option 1
                                                        style:
                                                        Styles.heading1(context).copyWith(color: Colors.black54),
                                                        value: selectedSubegion,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedSubegion = value;
                                                            print("region sel: ${selectedSubegion!.name}");
                                                            if (selectedSubegion!.area!.isNotEmpty) {
                                                              selectedRoute =
                                                              selectedSubegion!.area![0];
                                                            }
                                                            routes.clear();
                                                            routes.addAll(selectedSubegion!.area!);
                                                            for (RegionalRoutes routes in routes) {
                                                              print("route: ${routes.name}");
                                                            }
                                                          });
                                                        },
                                                        items: data
                                                            .map((Subregion? value) {
                                                          return DropdownMenuItem(
                                                            value: value,
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                  15.0),
                                                              child: Text(
                                                                value!.name!,
                                                                style: Styles
                                                                    .heading3(
                                                                    context)
                                                                    .copyWith(
                                                                    color: Colors
                                                                        .black45),
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                        icon: const Padding(
                                                          //Icon at tail, arrow bottom is default icon
                                                            padding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: 15.0),
                                                            child: Icon(
                                                              Icons
                                                                  .keyboard_arrow_down,
                                                              color: Colors.black38,
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                          }, error: (error, stack) {
                                        return Text(
                                          "An error occurred getting routes ${error.toString()}",
                                          style: Styles.heading3(context)
                                              .copyWith(color: Colors.red),
                                        );
                                      }, loading: () {
                                        return Text(
                                          "Getting routes ...",
                                          style: Styles.heading3(context)
                                              .copyWith(color: Colors.black38),
                                        );
                                      }),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Select customer route",
                                        style: Styles.heading3(context),
                                      ),
                                      SizedBox(
                                        height: Responsive.isMobile(context)
                                            ? 45.h
                                            : 55.h,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .white, //background color of dropdown button
                                            border: Border.all(
                                                color: Styles.darkGrey.withOpacity(
                                                    .3)), //border of dropdown button
                                            borderRadius:
                                            BorderRadius.circular(10.r),
                                          ),
                                          child: DropdownButtonFormField<
                                              RegionalRoutes>(
                                            isExpanded: true,
                                            decoration: const InputDecoration(
                                              disabledBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                            ),
                                            hint: Row(
                                              children: const [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                                  child:
                                                  Icon(Icons.arrow_drop_down),
                                                ),
                                              ],
                                            ), // Not necessary for Option 1
                                            style: Styles.heading1(context)
                                                .copyWith(color: Colors.black54),
                                            value: selectedRoute,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedRoute = value!;
                                              });
                                            },
                                            items: routes
                                                .toSet()
                                                .map((RegionalRoutes? value) {
                                              return DropdownMenuItem(
                                                value: value,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                                  child: Text(
                                                    value!.name!,
                                                    style:
                                                    Styles.heading3(context)
                                                        .copyWith(
                                                        color: Colors
                                                            .black45),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            icon: const Padding(
                                              //Icon at tail, arrow bottom is default icon
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.0),
                                                child: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.black38,
                                                )),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      GetBuilder<GeolocationController>(
                                          builder: (geocontroller) {
                                            return Obx(() => DefaultInputField(
                                              title: "Address",

                                              textEditingController:
                                              TextEditingController(
                                                  text: geocontroller
                                                      .address.value),
                                              // initialValue:
                                              //     geocontroller.address.value,
                                              readOnly: true,
                                              hintText:
                                              geocontroller.address.value,
                                              // textStyle: Styles.normalText(context).copyWith(color: Colors.grey),
                                            ));
                                          }),
                                    ],
                                  ),
                                  TextButton(onPressed: ()async{
                                    print("subregions: ${subRegions.length}");
                                    if(editLocation == false){
                                      showDialog(context: context, builder: (context){
                                        return AlertDialog(
                                          actions: [
                                            TextButton(onPressed: (){
                                              Get.back();
                                            }, child: Text("Cancel", style: Styles.heading4(context).copyWith(color: Colors.black38),)),
                                            SizedBox(width: 5,),
                                            TextButton(onPressed: ()async{
                                              await ref.watch(companyRoutesProvider).whenData((value) {
                                                if (value.isNotEmpty) {
                                                  // selectedSubegion = value[0];
                                                  selectedSubegion = null;
                                                  subRegions.addAll(value);
                                                  if (subRegions.isNotEmpty) {
                                                    routes.clear();
                                                    routes.addAll(subRegions[0].area!);
                                                  }
                                                  if (subRegions.isNotEmpty) {
                                                    routes.addAll(subRegions[0].area!);
                                                  }
                                                }
                                                print("the selected sub : ${selectedSubegion!.name}");
                                              });
                                              setState(() {
                                                editLocation = !editLocation;
                                              });
                                              Get.back();
                                            }, child: Text("Edit", style: Styles.heading4(context).copyWith(color: Colors.blue),)),
                                          ],
                                          content:Text("Are you sure you want to edit customer Geo-data", style: Styles.heading3(context),),
                                        );
                                      });
                                    }else{
                                      setState(() {
                                        editLocation = false;
                                      });
                                    }

                                  }, child: Center(child: Text(editLocation?"Cancel location Edit":"Edit location info", style: Styles.heading3(context).copyWith(color: Colors.blue),)))
                                ],

                              ),
                            ),
                          ),
                          SizedBox(height: defaultPadding(context) * 2),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: defaultPadding(context)),
                              child: Column(
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize:
                                        Size(double.infinity, 50),
                                        backgroundColor:
                                        Styles.appPrimaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                defaultRadius1)),
                                      ),
                                      onPressed: () async {
                                        Logger().i("Hi");
                                        Position position = await ref
                                            .read(customerNotifierProvider
                                            .notifier)
                                            .getGeoLocationPosition();
                                        Logger().e(position.latitude);
                                        Logger().e(
                                          controller.address.value,
                                        );
                                        Logger().i("Validated");
                                        Logger().i(position.latitude);
                                        ref.read(addCustomerNotifierProvider.notifier)
                                            .editCustomer(
                                          customer_name:customerNameController.text.trim(),
                                          email:emailController.text.trim(),
                                          contact_person:contactPersonController.text.trim(),
                                          phone_number:phoneNumberController.text.trim(),
                                          alternativePhone:alternativePhoneNumberController.text.trim(),
                                          outlet:selectedOutlet ==null?null:selectedOutlet!.outletName!,
                                          latitude:editLocation?position.latitude.toString():null,
                                          longitude:editLocation?position.longitude.toString():null,
                                          routeCode:selectedRoute == null?null:selectedRoute!.id!.toString(),
                                          address:editLocation?controller.address.value:null,
                                          businessCode: AuthService.instance.authUser!.user!.businessCode!,
                                        );
                                      },
                                      child: Text(
                                        "Edit Info",
                                        style: Styles.buttonText2(context)
                                            .copyWith(fontSize: 22),
                                      )),
                                  Material(
                                    child: InkWell(
                                      splashColor:
                                      Theme.of(context).splashColor,
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                            defaultPadding(context)),
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
                              ))
                        ],
                      ),
                    ));
              }),
            ),
            ref.watch(addCustomerNotifierProvider).isLoading
                ? Stack(
              children: [
                Opacity(
                  opacity: 0.3,
                  child: const ModalBarrier(
                      dismissible: false, color: Colors.black54),
                ),
                Center(child: CircularProgressIndicator.adaptive()),
              ],
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  bool validateSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
