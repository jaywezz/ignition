import 'package:flutter/material.dart';

class SurveyQuestions extends StatefulWidget {
  const SurveyQuestions({Key? key}) : super(key: key);

  @override
  State<SurveyQuestions> createState() => _SurveyQuestionsState();
}

class _SurveyQuestionsState extends State<SurveyQuestions> {
  List<String> _checkboxOptions = ['Option 1', 'Option 2', 'Option 3'];
  bool _checkboxOption1 = false;
  bool _checkboxOption2 = false;
  bool _checkboxOption3 = false;
  int _radioValue = -1;
  String _openEndedAnswer = '';
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
