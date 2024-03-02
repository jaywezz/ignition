import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/configs/constants.dart';
import 'package:soko_flow/configs/styles.dart';
import 'package:soko_flow/controllers/survey_controller.dart';
import 'package:soko_flow/models/surveys/questions_cart_model.dart';
import 'package:soko_flow/routes/route_helper.dart';
import 'package:soko_flow/views/customers/surveys/widget/custom_radio_button.dart';

import '../../../models/surveys/survey_questions_model.dart';
import '../components/validator.dart';

class Forms extends StatefulWidget {
  @override
  _FormsState createState() => _FormsState();
}

class _FormsState extends State<Forms> with Validator {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final double minValue = 8.0;

  int experienceIndex = 0;
  final _feedbackTypeList = <String>[
    "Select",
    "Yes",
    "No",
  ];

  String _feedbackType = "";

  final TextStyle _errorStyle = TextStyle(
    color: Colors.red,
    fontSize: 16.6,
  );

  String survey_code = "";
  String survey_id = "";
  String survey_name = "";
  String survey_description = "";
  int customerId = 0;

  getCustomerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      customerId = prefs.getInt('customerId')!;
    });
  }

  @override
  void initState() {
    if (Get.arguments["survey_code"] != null) {
      setState(() {
        survey_code = Get.arguments["survey_code"];
        survey_id = Get.arguments["survey_id"].toString();
        survey_name = Get.arguments["survey_name"];
        survey_description = Get.arguments["survey_description"];
      });
    }
    getCustomerData();
    _feedbackType = _feedbackTypeList[0];

    _onCreated();
    Get.find<SurveyController>().getSurveysQuestions(survey_code.toString());
    super.initState();
  }

  void _onCreated() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: []);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  File? _image;
  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      //final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);
      setState(() {
        this._image = imagePermanent;
      });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
        textColor: Colors.white,
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

  void _onTapEmoji(int index) {
    setState(() {
      experienceIndex = index;
    });
  }

  final Color activeColor = Color(0xFF15807a);
  final Color inActiveColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SurveyController>(builder: (surveyController) {
      return WillPopScope(
        onWillPop: () async {
          bool exit_app = false;
          Get.dialog(AlertDialog(
            content: Container(
                width: double.maxFinite,
                child: Text(
                  "Are you sure you want to Discard Responses?",
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
                  "Discard",
                  style: Styles.heading3(context)
                      .copyWith(color: Styles.appYellowColor),
                ),
                onPressed: () {
                  setState(() {
                    exit_app = true;
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ));
          return exit_app;
        },
        child: Scaffold(
          body: SafeArea(
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Container(
                // width: double.maxFinite,
                padding: EdgeInsets.only(
                    left: defaultPadding(context),
                    right: defaultPadding(context),
                    bottom: defaultPadding(context),
                    top: defaultPadding(context)),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/bg.png',
                      ),
                      fit: BoxFit.cover),
                ),
                // decoration: BoxDecoration(
                //     gradient: LinearGradient(begin: Alignment.bottomCenter, colors: [
                //       Colors.black.withOpacity(0.8),
                //       Colors.black.withOpacity(0.7)
                //     ])),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: [
                        Material(
                          child: InkWell(
                            splashColor: Theme.of(context).splashColor,
                            onTap: () {
                              Get.dialog(AlertDialog(
                                content: Container(
                                    width: double.maxFinite,
                                    child: Text(
                                      "Are you sure you want to Discard Responses?",
                                      style: Styles.normalText(context),
                                    )),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      "Cancel",
                                      style: Styles.heading3(context)
                                          .copyWith(color: Colors.grey),
                                    ),
                                    onPressed: () => Get.back(),
                                  ),
                                  TextButton(
                                    child: Text(
                                      "Discard",
                                      style: Styles.heading3(context).copyWith(
                                          color: Styles.appYellowColor),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);

                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ));
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Styles.darkGrey,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Questions",
                            style: Styles.heading2(context),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Material(
                            child: InkWell(
                              splashColor: Theme.of(context).splashColor,
                              onTap: () =>
                                  Get.toNamed(RouteHelper.getInitial()),
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
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () {
                          return surveyController
                              .getSurveysQuestions(survey_code.toString());
                        },
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: surveyController.isLoading
                              ? CircularProgressIndicator()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(survey_name,
                                        style: Styles.heading1(context)
                                            .copyWith(fontSize: 40)),
                                    SizedBox(
                                      width: 110.0,
                                      child: Container(
                                        height: 4,
                                        color: Color(0xFF15807a),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      survey_description,
                                      style: GoogleFonts.abhayaLibre().copyWith(
                                          fontSize: 22.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    surveyController.lstSurveysQuestions.isEmpty
                                        ? Text(
                                            "No questions in this survey",
                                            style: Styles.heading2(context)
                                                .copyWith(color: Colors.grey),
                                          )
                                        : ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: surveyController
                                                .lstSurveysQuestions.length,
                                            itemBuilder: (context, index) {
                                              print(
                                                  "question type is: ${surveyController.lstSurveysQuestions[index].type}");
                                              return surveyController
                                                          .lstSurveysQuestions[
                                                              index]
                                                          .type ==
                                                      "Multichoice"
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8.0),
                                                      child: _buildMultipleChoiceQuestion(
                                                          context,
                                                          surveyController
                                                                  .lstSurveysQuestions[
                                                              index]),
                                                    )
                                                  : surveyController
                                                              .lstSurveysQuestions[
                                                                  index]
                                                              .type ==
                                                          "True/False"
                                                      ? Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: _buildTrueFalseQuestion(
                                                                  surveyController
                                                                          .lstSurveysQuestions[
                                                                      index]),
                                                            ),
                                                            _feedbackType ==
                                                                    "No"
                                                                ? _buildDescription2(
                                                                    surveyController
                                                                            .lstSurveysQuestions[
                                                                        index])
                                                                : Container()
                                                          ],
                                                        )
                                                      : surveyController
                                                                  .lstSurveysQuestions[
                                                                      index]
                                                                  .type ==
                                                              "Open-Ended"
                                                          ? _buildTextBackground(
                                                              Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: _buildOpenEndedQuestion(
                                                                  surveyController
                                                                          .lstSurveysQuestions[
                                                                      index],
                                                                  context),
                                                            ))
                                                          : Container();
                                            }),

                                    SizedBox(
                                      height: minValue * 2,
                                    ),

                                    SizedBox(
                                      height: minValue * 6,
                                    ),
                                    // DottedBorder(
                                    //   color: Styles.appYellowColor,
                                    //   borderType: BorderType.RRect,
                                    //   radius: const Radius.circular(10),
                                    //   dashPattern: const [10, 4],
                                    //   strokeCap: StrokeCap.round,
                                    //   child: Row(
                                    //     children: [
                                    //       _image != null
                                    //           ? Image.file(
                                    //         _image!,
                                    //         height: 150,
                                    //         width: 200,
                                    //         fit: BoxFit.fill,
                                    //       )
                                    //           : Image.asset(
                                    //         "assets/images/select_image.png",
                                    //         height: 150,
                                    //         //color: Styles.backgroundColor,
                                    //         width: 200,
                                    //         fit: BoxFit.fill,
                                    //       ),
                                    //       SizedBox(
                                    //         width: 10,
                                    //       ),
                                    //       Column(
                                    //         mainAxisAlignment: MainAxisAlignment.start,
                                    //         crossAxisAlignment: CrossAxisAlignment.center,
                                    //         children: [
                                    //           AutoSizeText("Pick Image From",
                                    //               maxLines: 1, style: TextStyle(fontSize: 12,color: Colors.white),),
                                    //           SizedBox(
                                    //             height: 5,
                                    //           ),
                                    //           IconButton(
                                    //               onPressed: () {
                                    //                 getImage(ImageSource.camera);
                                    //               },
                                    //               icon:const Icon(
                                    //                 CupertinoIcons.camera,
                                    //                 color: Color(0xFF15807a),
                                    //               )),
                                    //           const Text("Camera", style: TextStyle(fontSize: 10,color: Colors.white)),
                                    //           const SizedBox(
                                    //             height: 5,
                                    //           ),
                                    //           IconButton(
                                    //               onPressed: () {
                                    //                 getImage(ImageSource.gallery);
                                    //               },
                                    //               icon:const Icon(
                                    //                 CupertinoIcons.photo,
                                    //                 color: Color(0xFF15807a),
                                    //               )),
                                    //           const Text(
                                    //             "Gallery",
                                    //             style: TextStyle(fontSize: 10),
                                    //           )
                                    //         ],
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _buildSubmitBtn(context),
                                    SizedBox(
                                      height: minValue * 6,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildEmoji() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () => _onTapEmoji(1),
            icon: Icon(
              Icons.sentiment_very_dissatisfied,
              color: experienceIndex == 1 ? activeColor : inActiveColor,
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () => _onTapEmoji(2),
            icon: Icon(
              Icons.sentiment_dissatisfied,
              color: experienceIndex == 2 ? activeColor : inActiveColor,
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () => _onTapEmoji(3),
            icon: Icon(
              Icons.sentiment_satisfied,
              color: experienceIndex == 3 ? activeColor : inActiveColor,
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () => _onTapEmoji(4),
            icon: Icon(
              Icons.sentiment_very_satisfied,
              color: experienceIndex == 4 ? activeColor : inActiveColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategory() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: minValue * 2, horizontal: minValue * 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Select feedback type",
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          SizedBox(
            height: minValue * 2,
          ),
          Row(
            children: <Widget>[
              Radio<String>(
                  value: 'COMMENT',
                  groupValue: _feedbackType,
                  onChanged: (String? v) {
                    setState(() {
                      _feedbackType = v!;
                    });
                  }),
              Text('Comments'),
              SizedBox(
                width: minValue,
              ),
              Radio<String>(
                  value: 'BUG',
                  groupValue: _feedbackType,
                  onChanged: (String? v) {
                    setState(() {
                      _feedbackType = v!;
                    });
                  }),
              Text('Bug Reports'),
              SizedBox(
                width: minValue,
              ),
              Radio<String>(
                  value: 'QUESTION',
                  groupValue: _feedbackType,
                  onChanged: (String? v) {
                    setState(() {
                      _feedbackType = v!;
                    });
                  }),
              Text('Questiions')
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrueFalseQuestion(SurveyQuestionsModel surveyQuestionsModel) {
    return GetBuilder<SurveyController>(builder: (surveyController) {
      return Container(
        child: Row(
          children: <Widget>[
            Text(
              surveyQuestionsModel.question!,
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              width: minValue * 2,
            ),
            Expanded(
                child: Align(
              alignment: Alignment.centerRight,
              child: DropdownButton<String>(
                onChanged: (String? type) async {
                  setState(() {
                    _feedbackType = type!;
                  });
                  if (_feedbackType == true) {
                    _reasonController.clear();
                  }
                  var questionResponse = QuestionResponses(
                      surveyQuestionsModel: surveyQuestionsModel,
                      answer: type.toString(),
                      customer_id: customerId.toString(),
                      reason: "");
                  await surveyController.addQuestionList(questionResponse);
                },
                hint: Text(
                  "$_feedbackType",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                items: _feedbackTypeList
                    .map((type) => DropdownMenuItem<String>(
                          child: Text(
                            "$type",
                            style: TextStyle(color: Colors.black),
                          ),
                          value: type,
                        ))
                    .toList(),
              ),
            ))
          ],
        ),
      );
    });
  }

  Widget _buildName() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: minValue),
      child: TextFormField(
        controller: _nameController,
        validator: (val) {
          usernameValidator(val!);
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            errorStyle: _errorStyle,
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
                borderRadius: BorderRadius.circular(10)), //label text of field
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Styles.appPrimaryColor),
                borderRadius: BorderRadius.circular(10)),
            contentPadding:
                EdgeInsets.symmetric(vertical: minValue, horizontal: minValue),
            labelText: 'Name of Customer',
            labelStyle: TextStyle(fontSize: 16.0, color: Colors.black26)),
      ),
    );
  }

  Widget _buildMultipleChoiceQuestion(
    BuildContext context,
    SurveyQuestionsModel surveyQuestionsModel,
  ) {
    List<String> options_list = <String>[
      surveyQuestionsModel.options!.optionsA!,
      surveyQuestionsModel.options!.optionsB!,
      surveyQuestionsModel.options!.optionsC!,
      surveyQuestionsModel.options!.optionsD ?? "None"
    ];
    String _value = options_list[0];
    for (String option in options_list) {
      print("the options: $option");
    }
    return GetBuilder<SurveyController>(builder: (surveyController) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                surveyQuestionsModel.question!,
                style: Styles.heading4(context),
              ),
              RadioGroup(
                  radioList: options_list,
                  onChanged: (value) async {
                    print('Value : ${value}');
                    var questionResponse = QuestionResponses(
                        surveyQuestionsModel: surveyQuestionsModel,
                        answer: value,
                        customer_id: customerId.toString(),
                        reason: "");
                    await surveyController.addQuestionList(questionResponse);
                  },
                  selectedItem: -1,
                  disabled: false),
            ],
          ));
    });
  }

  Widget _buildOpenEndedQuestion(
      SurveyQuestionsModel surveyQuestionsModel, BuildContext context) {
    return GetBuilder<SurveyController>(builder: (surveyController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            surveyQuestionsModel.question!,
            style: Styles.heading4(context),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: minValue, vertical: minValue),
            child: TextFormField(
              controller: _messageController,
              keyboardType: TextInputType.text,
              onChanged: (value) async {
                var questionResponse = QuestionResponses(
                    surveyQuestionsModel: surveyQuestionsModel,
                    answer: _messageController.text,
                    customer_id: customerId.toString(),
                    reason: "");
                await surveyController.addQuestionList(questionResponse);
              },
              maxLines: 5,
              decoration: InputDecoration(
                  errorStyle: _errorStyle,
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius:
                          BorderRadius.circular(10)), //label text of field
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Styles.appPrimaryColor),
                      borderRadius: BorderRadius.circular(10)),
                  labelText: 'Suggestions',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: minValue, vertical: 10),
                  labelStyle: TextStyle(fontSize: 16.0, color: Colors.black26)),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildDescription2(
    SurveyQuestionsModel surveyQuestionsModel,
  ) {
    return GetBuilder<SurveyController>(builder: (surveyController) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: minValue, vertical: minValue),
        child: TextFormField(
          controller: _reasonController,
          keyboardType: TextInputType.text,
          onChanged: (value) async {
            var questionResponse = QuestionResponses(
                surveyQuestionsModel: surveyQuestionsModel,
                answer: _feedbackType.toString(),
                customer_id: customerId.toString(),
                reason: _reasonController.text);
            await surveyController.addQuestionList(questionResponse);
          },
          maxLines: 2,
          decoration: InputDecoration(
              errorStyle: _errorStyle,
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                  borderRadius:
                      BorderRadius.circular(10)), //label text of field
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Styles.appPrimaryColor),
                  borderRadius: BorderRadius.circular(10)),
              labelText: 'If No give Reasons',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: minValue, vertical: 10),
              labelStyle: TextStyle(fontSize: 16.0, color: Colors.grey[600])),
        ),
      );
    });
  }

  Widget _buildTextBackground(Widget child) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(2)),
      child: child,
    );
  }

  Widget _buildSubmitBtn(BuildContext context) {
    return GetBuilder<SurveyController>(builder: (surveyController) {
      return Container(
        width: double.maxFinite,
        // color: Color(0xFF15807a),
        padding: EdgeInsets.symmetric(horizontal: minValue * 3),
        decoration: BoxDecoration(
          color: Styles.appPrimaryColor,
          borderRadius: BorderRadius.circular(10),
          // gradient:
          // LinearGradient(colors: [Colors.pink.shade700, Colors.pink.shade400])
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Styles.appPrimaryColor,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              textStyle: Styles.heading3(context)),
          onPressed: () async {
            if (_feedbackType == false && _reasonController.text.isEmpty) {
              showCustomSnackBar("All Questions not answered");
            } else if (surveyController.lstSurveysQuestions.length !=
                surveyController.responseList.length) {
              showCustomSnackBar("All Questions not answered");
            } else {
              await surveyController.surveyResponse(survey_id);
            }
          },
          child: Text('SUBMIT'),
        ),
      );
    });
  }
}
