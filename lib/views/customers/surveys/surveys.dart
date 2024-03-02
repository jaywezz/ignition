import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/survey_controller.dart';
import 'package:soko_flow/controllers/user_deliveries_controller.dart';

import 'package:soko_flow/logic/routes/routes.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/utils/size_utils2.dart';
import 'package:soko_flow/views/customers/surveys/survey_questions.dart';
import 'package:soko_flow/widgets/inputs/search_field.dart';

class SurveysScreen extends StatefulWidget {
  SurveysScreen({Key? key}) : super(key: key);

  @override
  State<SurveysScreen> createState() => _SurveysScreenState();
}

class _SurveysScreenState extends State<SurveysScreen> {
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
          height: double.infinity,
          width: double.infinity,

          //color: Styles.appBackgroundColor,
          child: Container(
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
                        "${customer_name} Surveys",
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
                SizedBox(
                  height: defaultPadding(context) * 1,
                ),
                Text(
                  'Surveys',
                  style: Styles.heading2(context),
                ),
                SizedBox(
                  height: defaultPadding(context),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(
                //       horizontal: defaultPadding(context) * 1.8),
                //   child: const LargeSearchField(
                //     hintText: 'Search By Name',
                //     outline: true,
                //   ),
                // ),
                GetBuilder<SurveyController>(builder: (surveyController) {
                  return Expanded(
                      child: Stack(children: [
                        RefreshIndicator(
                          onRefresh: () {
                            return surveyController.getSurveys();
                          },
                          child: surveyController.isLoading? Center(child: CircularProgressIndicator())
                              :surveyController.lstSurveys.isEmpty
                              ?Text("No surveys", style: Styles.heading3(context).copyWith(color: Colors.grey),):ListView.builder(
                              itemCount: surveyController.lstSurveys.length,
                              itemBuilder: ((context, index) {
                                return GestureDetector(
                                  onTap: (){

                                    Get.to(Forms(),
                                        arguments: {
                                            "survey_code": surveyController.lstSurveys[index].code,
                                            "survey_id": surveyController.lstSurveys[index].id,
                                            "survey_name": surveyController.lstSurveys[index].title,
                                            "survey_description": surveyController.lstSurveys[index].description,
                                    }
                                            );
                                  },
                                  child: Card(
                                    elevation: 3,
                                    child: Container(
                                      child: Row(
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Flexible(
                                            flex: 5,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        surveyController.lstSurveys[index].title!,
                                                        style: Styles.heading2(context),
                                                      ),
                                                      // Text(
                                                      //     surveyController.lstSurveys[index].status!.toString(),
                                                      //     style: Styles.heading4(context)
                                                      // ),
                                                      Icon(Icons.info_outline, color: Colors.red,)
                                                    ],

                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    surveyController.lstSurveys[index].description!,
                                                    style: Styles.smallGreyText(context),
                                                    maxLines: 3,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      padding: EdgeInsets.all(defaultPadding(context) * 0.2),
                                      width: double.infinity,
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(defaultPadding(context))),
                                  ),
                                );
                              })),
                        )
                        // Positioned(
                        //   bottom: 0,
                        //   left: 0,
                        //   right: 0,
                        //   child: Column(
                        //     children: [
                        //       FullWidthButton(
                        //         action: () {},
                        //         text: 'Add',
                        //         color: Styles.appPrimaryColor,
                        //       ),
                        //       Material(
                        //         child: InkWell(
                        //           splashColor: Theme.of(context).splashColor,
                        //           onTap: () {
                        //             Navigate.instance.toRemove('/customers');
                        //           },
                        //           child: Padding(
                        //             padding: EdgeInsets.symmetric(
                        //                 vertical: defaultPadding(context)),
                        //             child: Center(
                        //                 child: Text(
                        //               'Cancel',
                        //               textAlign: TextAlign.center,
                        //               style: Styles.normalText(context),
                        //             )),
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                      ]));
                })
              ],
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
