import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soko_flow/configs/constants.dart';

import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/models/company_outlets/company_outlets_model.dart';
import 'package:soko_flow/models/company_routes/company_routes_model.dart';

import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/size_utils2.dart';

import 'package:soko_flow/widgets/inputs/custom_dropdown.dart';
import 'package:soko_flow/widgets/inputs/defaut_input_field.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/customer_provider.dart';
import '../../controllers/customers_controller.dart';
import '../../controllers/geolocation_controller.dart';

import '../../data/providers/customer_provider.dart';
import '../../models/company_outlets/customer_groups.dart';
import '../../services/auth_service.dart';

Logger _log = Logger(printer: PrettyPrinter());

enum ProfilePictureOptions { REMOVE, TAKE_CAMERA_PHOTO }

class AddNewCustomer extends ConsumerStatefulWidget {
  const AddNewCustomer({Key? key}) : super(key: key);

  @override
  ConsumerState<AddNewCustomer> createState() => _AddNewCustomerState();
}

class _AddNewCustomerState extends ConsumerState<AddNewCustomer> {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController alternativePhoneNumberController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subRegionController = TextEditingController();
  final TextEditingController routeController = TextEditingController();
  CompanyOutletsModel? selectedOutlet = null;
  CustomerGroupModel? selectedCustomerGroup = null;
  // List<Subregion> subRegions = [];
  List<RegionalRoutes> routes = [];



  Subregion? selectedSubegion;
  RegionalRoutes? selectedRoute;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      _image = File("${directory.path}/assets/logo/playstore.png");
    });
    return directory.path;
  }

  File? _image;
  Future getImage(ImageSource source) async {
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 40);
      if (image == null) return;

      //final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);
      setState(() {
        this._image = imagePermanent;
      });
    } on PlatformException catch (e) {
      showSnackBar(
        text: e.toString(),
        bgColor: Colors.red,
        txtColor: Colors.white,
      );
      print(e.toString());
    }
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

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
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // ref.watch(companyRoutesProvider).whenData((value) {
    //   setState(() {
    //     if (value.isNotEmpty) {
    //       selectedSubegion = value[0];
    //       subRegions.addAll(value);
    //       print("added all subs:${subRegions.length}");
    //       if (subRegions.isNotEmpty) {
    //         routes.addAll(subRegions[0].area!);
    //       }
    //       print("the routes: $routes");
    //     }
    //   });
    // });
    super.didChangeDependencies();
  }
  FocusNode searchRouteFocusNode = FocusNode();
  FocusNode textFieldRouteFocusNode = FocusNode();

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(RouteHelper.getCustomers());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Theme.of(context).splashColor,
              onTap: () => Get.offNamed(RouteHelper.getCustomers()),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Styles.darkGrey,
              ),
            ),
          ),
          title: Text(
            'New Customer',
            style: Styles.heading2(context),
          ),
          actions: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Theme.of(context).splashColor,
                onTap: () => Get.offNamed(RouteHelper.getInitial()),
                child: Icon(
                  Icons.home_sharp,
                  size: defaultPadding(context) * 2,
                  color: Styles.appPrimaryColor,
                ),
              ),
            ),
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
                                    Center(
                                      child: Container(
                                        height: 140,
                                        child: FractionallySizedBox(
                                          heightFactor: 0.6,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Styles.appPrimaryColor,
                                            radius: 100.0,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.add_a_photo_outlined,
                                                color: Colors.white,
                                              ),
                                              onPressed: () =>
                                                  getImage(ImageSource.camera),
                                            ),
                                            backgroundImage: _image != null
                                                ? FileImage(File(_image!.path))
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),

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
                                      textEditingController:
                                          contactPersonController,
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
                                      "Select customer groups",
                                      style: Styles.heading3(context).copyWith(
                                          color: Colors.black54,),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    ref.watch(customerGroupsProvider).when(
                                        data: (data) {
                                      if (data!.isEmpty) {
                                        return Text(
                                          "No customer groups added",
                                          style: Styles.heading3(context)
                                              .copyWith(color: Colors.black38),
                                        );
                                      } else {
                                        selectedCustomerGroup = data[0];
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
                                                CustomerGroupModel>(
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
                                              value: selectedCustomerGroup,
                                              onChanged: (value) {
                                                selectedCustomerGroup = value;
                                              },
                                              items: data.map(
                                                  (CustomerGroupModel? value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 15.0),
                                                    child: Text(
                                                      value!.groupName!,
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
                                        "An error occured getting customer groups",
                                        style: Styles.heading3(context)
                                            .copyWith(color: Colors.red),
                                      );
                                    }, loading: () {
                                      return Text(
                                        "Getting customer groups ...",
                                        style: Styles.heading3(context)
                                            .copyWith(color: Colors.black38),
                                      );
                                    }),

                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Select outlet type",
                                      style: Styles.heading3(context).copyWith(
                                          color: Colors.black54,),
                                    ),
                                    SizedBox(
                                      height: 8,
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
                                        // selectedOutlet = data[0];
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
                                            child: DropdownButtonFormField<CompanyOutletsModel>(
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

                                    Text(
                                      "Select customer sub Region",
                                      style: Styles.heading3(context).copyWith(
                                          color: Colors.black54,
                                          fontSize: 14.sp),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    ref.watch(companyRoutesProvider).when(data: (data){
                                      // return SingleChildScrollView(
                                      //   child: TypeAheadFormField<Subregion>(
                                      //     textFieldConfiguration: TextFieldConfiguration(
                                      //       controller: subRegionController,
                                      //       decoration: InputDecoration(
                                      //         labelText: 'Search sub - Region',
                                      //         hintText: 'Search',
                                      //         prefixIcon: Icon(Icons.search),
                                      //         border: OutlineInputBorder(
                                      //           borderRadius: BorderRadius.circular(10),
                                      //           borderSide: BorderSide(
                                      //             color: Colors.grey.shade300,
                                      //             width: 1.0,
                                      //           ),
                                      //         ),
                                      //         focusedBorder: OutlineInputBorder(
                                      //           borderRadius: BorderRadius.circular(10),
                                      //           borderSide: BorderSide(
                                      //             color: Colors.blue,
                                      //             width: 1.0,
                                      //           ),
                                      //         ),
                                      //         filled: true,
                                      //         fillColor: Colors.grey.shade100,
                                      //       ),
                                      //     ),
                                      //     suggestionsCallback: (pattern) async {
                                      //       return data.where((element) => element.name!.toLowerCase().contains(pattern.toLowerCase())).toList();
                                      //     },
                                      //     itemBuilder: (context, Subregion suggestion) {
                                      //       // Replace this with your own logic to build the suggestion widget
                                      //       return ListTile(
                                      //         title: Text(suggestion.name?? "No name"),
                                      //         // subtitle:  ,
                                      //       );
                                      //     },
                                      //     onSuggestionSelected: (Subregion suggestion) {
                                      //       print("id: ${suggestion.id}");
                                      //       setState(() {
                                      //         selectedSubegion = suggestion;
                                      //         subRegionController.text = suggestion.name!;
                                      //         if(selectedSubegion!.area!.isNotEmpty || selectedSubegion!.area !=null){
                                      //           routes.addAll(selectedSubegion!.area!);
                                      //         }
                                      //       });
                                      //       // Replace this with your own logic to handle suggestion selection
                                      //       print('Selected: $suggestion');
                                      //     },
                                      //     noItemsFoundBuilder: (context) {
                                      //       // Replace this with your own logic to build the no items found widget
                                      //       return ListTile(
                                      //         title: Text('No results found'),
                                      //       );
                                      //     },
                                      //   ),
                                      // );
                                      return DropDownTextField(
                                        clearOption: false,
                                        // textFieldFocusNode: textFieldRouteFocusNode,
                                        // searchFocusNode: searchRouteFocusNode,
                                        // searchAutofocus: true,
                                        dropDownItemCount: data.length,
                                        searchShowCursor: false,
                                        enableSearch: true,
                                        searchKeyboardType: TextInputType.text,
                                        textFieldDecoration:  InputDecoration(
                                            labelText: 'Search sub - Region',
                                            hintText: 'Search',
                                            prefixIcon: Icon(Icons.search),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 1.0,
                                              ),
                                            )),
                                        dropDownList:[
                                          for(Subregion subRegion in data)
                                            DropDownValueModel(name: subRegion.name!, value: subRegion.id),
                                        ],
                                        onChanged: (val) {
                                          try{
                                            setState(() {
                                              print(val.value);
                                              data.forEach((element) {print(element.id);});
                                              print("subs:${data.length}");
                                              selectedSubegion = data.where((element) => element.id == val.value).first;
                                              // subRegionController.text = selectedSubegion!.name!;
                                              print("the on changed:${selectedSubegion}");
                                              if(selectedSubegion!.area!.isNotEmpty || selectedSubegion!.area !=null){
                                                print("areas is not empty");
                                                routes.clear();
                                                routes.addAll(selectedSubegion!.area!);
                                                selectedRoute = routes[0];
                                                print("routes length: ${routes.length}");
                                              }
                                            });
                                          }catch(e,s){
                                            print("error:$s");
                                          }
                                        },
                                      );
                                    }, error: (e,s){
                                      return Text(
                                        "An error occurred getting routes ${e.toString()}",
                                        style: Styles.heading3(context)
                                            .copyWith(color: Colors.red),
                                      );
                                    }, loading: (){
                                      return Text(
                                        "Getting routes ...",
                                        style: Styles.heading3(context)
                                            .copyWith(color: Colors.black38),
                                      );
                                    }),


                                    // ref.watch(companyRoutesProvider).when(
                                    //     data: (data) {
                                    //   if (data.isEmpty) {
                                    //     return Text(
                                    //       "No routes added",
                                    //       style: Styles.heading3(context)
                                    //           .copyWith(color: Colors.black38),
                                    //     );
                                    //   } else {
                                    //     return Column(
                                    //       children: [
                                    //         SizedBox(
                                    //           height:
                                    //               Responsive.isMobile(context)
                                    //                   ? 45.h
                                    //                   : 55.h,
                                    //           child: DecoratedBox(
                                    //             decoration: BoxDecoration(
                                    //               color: Colors
                                    //                   .white, //background color of dropdown button
                                    //               border: Border.all(
                                    //                   color: Styles.darkGrey
                                    //                       .withOpacity(
                                    //                           .3)), //border of dropdown button
                                    //               borderRadius:
                                    //                   BorderRadius.circular(
                                    //                       10.r),
                                    //             ),
                                    //             child: DropdownButtonFormField<
                                    //                 Subregion>(
                                    //               isExpanded: true,
                                    //               decoration:
                                    //                   const InputDecoration(
                                    //                 disabledBorder:
                                    //                     InputBorder.none,
                                    //                 enabledBorder:
                                    //                     InputBorder.none,
                                    //                 focusedBorder:
                                    //                     InputBorder.none,
                                    //               ),
                                    //               hint: Row(
                                    //                 children: const [
                                    //                   Padding(
                                    //                     padding: EdgeInsets
                                    //                         .symmetric(
                                    //                             horizontal:
                                    //                                 8.0),
                                    //                     child: Icon(Icons
                                    //                         .arrow_drop_down),
                                    //                   ),
                                    //                 ],
                                    //               ), // Not necessary for Option 1
                                    //               style:
                                    //                   Styles.heading1(context)
                                    //                       .copyWith(
                                    //                           color: Colors
                                    //                               .black54),
                                    //               value: selectedSubegion,
                                    //               onChanged: (value) {
                                    //                 setState(() {
                                    //                   selectedSubegion = value;
                                    //                   print(
                                    //                       "region sel: ${selectedSubegion!.name}");
                                    //                   if (selectedSubegion!
                                    //                       .area!.isNotEmpty) {
                                    //                     selectedRoute =
                                    //                         selectedSubegion!
                                    //                             .area![0];
                                    //                   }
                                    //                   routes.clear();
                                    //                   routes.addAll(
                                    //                       selectedSubegion!
                                    //                           .area!);
                                    //                   for (RegionalRoutes routes
                                    //                       in routes) {
                                    //                     print(
                                    //                         "route: ${routes.name}");
                                    //                   }
                                    //                 });
                                    //               },
                                    //               items: data
                                    //                   .map((Subregion? value) {
                                    //                 return DropdownMenuItem(
                                    //                   value: value,
                                    //                   child: Padding(
                                    //                     padding:
                                    //                         const EdgeInsets
                                    //                                 .symmetric(
                                    //                             horizontal:
                                    //                                 15.0),
                                    //                     child: Text(
                                    //                       value!.name!,
                                    //                       style: Styles
                                    //                               .heading3(
                                    //                                   context)
                                    //                           .copyWith(
                                    //                               color: Colors
                                    //                                   .black45),
                                    //                     ),
                                    //                   ),
                                    //                 );
                                    //               }).toList(),
                                    //               icon: const Padding(
                                    //                   //Icon at tail, arrow bottom is default icon
                                    //                   padding:
                                    //                       EdgeInsets.symmetric(
                                    //                           horizontal: 15.0),
                                    //                   child: Icon(
                                    //                     Icons
                                    //                         .keyboard_arrow_down,
                                    //                     color: Colors.black38,
                                    //                   )),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     );
                                    //   }
                                    // }, error: (error, stack) {
                                    //   return Text(
                                    //     "An error occurred getting routes ${error.toString()}",
                                    //     style: Styles.heading3(context)
                                    //         .copyWith(color: Colors.red),
                                    //   );
                                    // }, loading: () {
                                    //   return Text(
                                    //     "Getting routes ...",
                                    //     style: Styles.heading3(context)
                                    //         .copyWith(color: Colors.black38),
                                    //   );
                                    // }),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Select customer route",
                                      style: Styles.heading3(context).copyWith(
                                          color: Colors.black54,),
                                    ),
                                    SizedBox(height: 8,),
                                    DropDownTextField(
                                      clearOption: false,
                                      textFieldFocusNode: textFieldRouteFocusNode,
                                      searchFocusNode: searchRouteFocusNode,
                                      // searchAutofocus: true,
                                      dropDownItemCount: routes.length,
                                      searchShowCursor: true,
                                      enableSearch: true,
                                      searchKeyboardType: TextInputType.text,
                                      textFieldDecoration:  InputDecoration(
                                          labelText: 'Search route',
                                          hintText: 'Search',
                                          prefixIcon: Icon(Icons.search),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1.0,
                                            ),
                                          )),
                                      dropDownList:[
                                        for(RegionalRoutes route in routes)
                                          DropDownValueModel(name: route.name!, value: route.id),
                                      ],
                                      onChanged: (val) {
                                        setState(() {
                                          selectedRoute = routes.where((element) => element.id == val.value).first;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    // SingleChildScrollView(
                                    //   child: TypeAheadFormField<RegionalRoutes>(
                                    //     textFieldConfiguration: TextFieldConfiguration(
                                    //       controller: routeController,
                                    //       decoration: InputDecoration(
                                    //         labelText: 'Search Routes',
                                    //         hintText: 'Search',
                                    //         prefixIcon: Icon(Icons.search),
                                    //         border: OutlineInputBorder(
                                    //           borderRadius: BorderRadius.circular(10),
                                    //           borderSide: BorderSide(
                                    //             color: Colors.grey.shade300,
                                    //             width: 1.0,
                                    //           ),
                                    //         ),
                                    //         focusedBorder: OutlineInputBorder(
                                    //           borderRadius: BorderRadius.circular(10),
                                    //           borderSide: BorderSide(
                                    //             color: Colors.blue,
                                    //             width: 1.0,
                                    //           ),
                                    //         ),
                                    //         filled: true,
                                    //         fillColor: Colors.grey.shade100,
                                    //       ),
                                    //     ),
                                    //     suggestionsCallback: (pattern) async {
                                    //       return  routes
                                    //           .toSet().where((element) => element.name!.toLowerCase().contains(pattern.toLowerCase())).toList();
                                    //     },
                                    //     itemBuilder: (context, RegionalRoutes suggestion) {
                                    //       // Replace this with your own logic to build the suggestion widget
                                    //       return ListTile(
                                    //         title: Text(suggestion.name?? "No name"),
                                    //         // subtitle: Text("") ,
                                    //       );
                                    //     },
                                    //     onSuggestionSelected: (RegionalRoutes suggestion) {
                                    //       print("id: ${suggestion.id}");
                                    //       setState(() {
                                    //         selectedRoute = suggestion;
                                    //         routeController.text = suggestion.name!;
                                    //       });
                                    //       // Replace this with your own logic to handle suggestion selection
                                    //       print('Selected: $suggestion');
                                    //     },
                                    //     noItemsFoundBuilder: (context) {
                                    //       // Replace this with your own logic to build the no items found widget
                                    //       return ListTile(
                                    //         title: Text('No results found'),
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: Responsive.isMobile(context)
                                    //       ? 45.h
                                    //       : 55.h,
                                    //   child: DecoratedBox(
                                    //     decoration: BoxDecoration(
                                    //       color: Colors
                                    //           .white, //background color of dropdown button
                                    //       border: Border.all(
                                    //           color: Styles.darkGrey.withOpacity(
                                    //               .3)), //border of dropdown button
                                    //       borderRadius:
                                    //           BorderRadius.circular(10.r),
                                    //     ),
                                    //     child: DropdownButtonFormField<
                                    //         RegionalRoutes>(
                                    //       isExpanded: true,
                                    //       decoration: const InputDecoration(
                                    //         disabledBorder: InputBorder.none,
                                    //         enabledBorder: InputBorder.none,
                                    //         focusedBorder: InputBorder.none,
                                    //       ),
                                    //       hint: Row(
                                    //         children: const [
                                    //           Padding(
                                    //             padding: EdgeInsets.symmetric(
                                    //                 horizontal: 8.0),
                                    //             child:
                                    //                 Icon(Icons.arrow_drop_down),
                                    //           ),
                                    //         ],
                                    //       ), // Not necessary for Option 1
                                    //       style: Styles.heading1(context)
                                    //           .copyWith(color: Colors.black54),
                                    //       value: selectedRoute,
                                    //       onChanged: (value) {
                                    //         setState(() {
                                    //           selectedRoute = value!;
                                    //         });
                                    //       },
                                    //       items: routes
                                    //           .toSet()
                                    //           .map((RegionalRoutes? value) {
                                    //         return DropdownMenuItem(
                                    //           value: value,
                                    //           child: Padding(
                                    //             padding:
                                    //                 const EdgeInsets.symmetric(
                                    //                     horizontal: 15.0),
                                    //             child: Text(
                                    //               value!.name!,
                                    //               style:
                                    //                   Styles.heading3(context)
                                    //                       .copyWith(
                                    //                           color: Colors
                                    //                               .black45),
                                    //             ),
                                    //           ),
                                    //         );
                                    //       }).toList(),
                                    //       icon: const Padding(
                                    //           //Icon at tail, arrow bottom is default icon
                                    //           padding: EdgeInsets.symmetric(
                                    //               horizontal: 15.0),
                                    //           child: Icon(
                                    //             Icons.keyboard_arrow_down,
                                    //             color: Colors.black38,
                                    //           )),
                                    //     ),
                                    //   ),
                                    // ),
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

                                          Logger().i("Hi");
                                          if (selectedRoute == null) {
                                            showSnackBar(
                                                text: "Select customer route",
                                                bgColor: Colors.red);
                                          } else if (selectedOutlet == null) {
                                            showSnackBar(
                                                text: "Select outlet type",
                                                bgColor: Colors.red);
                                          }
                                          // else if (_image == null) {
                                          //   showSnackBar(
                                          //       text: "Outlet photo needed",
                                          //       bgColor: Colors.red);
                                          // }
                                          else if (validateSave()) {
                                            print(
                                                "route code: ${selectedRoute!.id}");
                                            Logger().i("Validated");
                                            Logger().i(position.latitude);
                                            ref
                                                .read(
                                                    addCustomerNotifierProvider
                                                        .notifier)
                                                .addCustomer(
                                                  customerNameController.text
                                                      .trim(),
                                                  emailController.text.trim(),
                                                  contactPersonController.text
                                                      .trim(),
                                                  AuthService.instance.authUser!
                                                      .user!.businessCode!,
                                                  AuthService.instance.authUser!
                                                      .user!.name!,
                                                  phoneNumberController.text
                                                      .trim(),
                                                  alternativePhoneNumberController
                                                      .text
                                                      .trim(),
                                                  selectedOutlet!.outletName!,
                                                  position.latitude.toString(),
                                                  position.longitude.toString(),
                                                  selectedRoute!.id!.toString(),
                                                  controller.address.value,
                                                  _image != null
                                                      ? _image
                                                      : null,
                                                );
                                          }
                                        },
                                        child: Text(
                                          "Add Customer",
                                          style: Styles.buttonText2(context)
                                              .copyWith(fontSize: 22),
                                        )),
                                    Material(
                                      child: InkWell(
                                        splashColor:
                                            Theme.of(context).splashColor,
                                        onTap: () {
                                          Get.offNamed(
                                              RouteHelper.getCustomers());
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
