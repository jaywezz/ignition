// import 'package:flutter/material.dart';
// import 'package:soko_flow/configs/styles.dart';
// final bool isSelected = false;
//
// Widget _buildEmoji() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: <Widget>[
//       Material(
//         color: Colors.transparent,
//         child: IconButton(
//           onPressed: () => _onTapEmoji(1),
//           icon: Icon(
//             Icons.sentiment_very_dissatisfied,
//             color: experienceIndex == 1 ? activeColor : inActiveColor,
//           ),
//         ),
//       ),
//       Material(
//         color: Colors.transparent,
//         child: IconButton(
//           onPressed: () => _onTapEmoji(2),
//           icon: Icon(
//             Icons.sentiment_dissatisfied,
//             color: experienceIndex == 2 ? activeColor : inActiveColor,
//           ),
//         ),
//       ),
//       Material(
//         color: Colors.transparent,
//         child: IconButton(
//           onPressed: () => _onTapEmoji(3),
//           icon: Icon(
//             Icons.sentiment_satisfied,
//             color: experienceIndex == 3 ? activeColor : inActiveColor,
//           ),
//         ),
//       ),
//       Material(
//         color: Colors.transparent,
//         child: IconButton(
//           onPressed: () => _onTapEmoji(4),
//           icon: Icon(
//             Icons.sentiment_very_satisfied,
//             color: experienceIndex == 4 ? activeColor : inActiveColor,
//           ),
//         ),
//       ),
//     ],
//   );
// }
// Widget _buildCategory() {
//   return Container(
//     padding: EdgeInsets.symmetric(
//         vertical: minValue * 2, horizontal: minValue * 3),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           "Select feedback type",
//           style: TextStyle(
//               fontSize: 18.0,
//               fontWeight: FontWeight.bold,
//               color: Colors.black),
//         ),
//         SizedBox(
//           height: minValue * 2,
//         ),
//         Row(
//           children: <Widget>[
//             Radio<String>(
//                 value: 'COMMENT',
//                 groupValue: _feedbackType,
//                 onChanged: (String? v) {
//                   setState(() {
//                     _feedbackType = v!;
//                   });
//                 }),
//             Text('Comments'),
//             SizedBox(
//               width: minValue,
//             ),
//             Radio<String>(
//                 value: 'BUG',
//                 groupValue: _feedbackType,
//                 onChanged: (String? v) {
//                   setState(() {
//                     _feedbackType = v!;
//                   });
//                 }),
//             Text('Bug Reports'),
//             SizedBox(
//               width: minValue,
//             ),
//             Radio<String>(
//                 value: 'QUESTION',
//                 groupValue: _feedbackType,
//                 onChanged: (String? v) {
//                   setState(() {
//                     _feedbackType = v!;
//                   });
//                 }),
//             Text('Questiions')
//           ],
//         ),
//       ],
//     ),
//   );
// }
// Widget _buildTrueFalseQuestion(String question) {
//   return Container(
//
//     child: Row(
//       children: <Widget>[
//         Text(
//           question,
//           style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold,color:Colors.black),
//         ),
//         SizedBox(
//           width: minValue * 2,
//         ),
//         Expanded(
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: DropdownButton<String>(
//                 onChanged: (String? type) {
//                   setState(() {
//                     _feedbackType = type!;
//                   });
//                 },
//                 hint: Text(
//                   "$_feedbackType",
//                   style: TextStyle(fontSize: 16.0,color:Colors.black),
//                 ),
//                 items: _feedbackTypeList
//                     .map((type) => DropdownMenuItem<String>(
//                   child: Text("$type",style: TextStyle(color:Colors.black),),
//                   value: type,
//                 ))
//                     .toList(),
//               ),
//             ))
//       ],
//     ),
//   );
// }
// Widget _buildName() {
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: minValue),
//     child: TextFormField(
//       controller: _nameController,
//       validator: (val){usernameValidator(val!);},
//       keyboardType: TextInputType.text,
//       decoration: InputDecoration(
//           errorStyle: _errorStyle,
//           border: InputBorder.none,
//           enabledBorder: OutlineInputBorder(
//
//               borderSide: BorderSide(color: Colors.orange),
//               borderRadius: BorderRadius.circular(10)
//           ),//label text of field
//           focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Styles.appPrimaryColor),
//               borderRadius: BorderRadius.circular(10)
//           ),
//           contentPadding:
//           EdgeInsets.symmetric(vertical: minValue, horizontal: minValue),
//           labelText: 'Name of Customer',
//           labelStyle: TextStyle(fontSize: 16.0, color: Colors.black26)),
//     ),
//   );
// }
//
//
// Widget _buildMultipleChoiceQuestion(BuildContext context, Options options, String question) {
//   List options_list = [options.optionsA, options.optionsB, options.optionsC, options.optionsD];
//   String _value = options_list[0];
//   for (String option in options_list){
//     print("the options: $option");
//   }
//   return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 0),
//       child:  Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(question, style: Styles.heading4(context),),
//           for (String option in options_list)
//             ListTile(
//               title: Text(
//                 option,
//                 style: Styles.heading3(context),
//               ),
//               leading: Radio(
//                 value: option,
//                 groupValue: _value,
//                 activeColor: Styles.appYellowColor,
//                 onChanged:(String? value) {
//                   print("on change value: ${value}");
//                   setState(() {
//                     // _value = value!;
//                     _value = value!;
//                     print("the group value ${_value}");
//
//                   });
//                 },
//               ),
//             ),
//         ],
//       )
//   );
// }
//
//
//
// Widget _buildOpenEndedQuestion(String question, BuildContext context) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       SizedBox(height: 20,),
//       Text(question, style: Styles.heading4(context),),
//       Padding(
//         padding: EdgeInsets.symmetric(horizontal: minValue, vertical: minValue),
//         child: TextFormField(
//           controller: _messageController,
//           keyboardType: TextInputType.text,
//           maxLines: 5,
//           decoration: InputDecoration(
//               errorStyle: _errorStyle,
//               border: InputBorder.none,
//               enabledBorder: OutlineInputBorder(
//
//                   borderSide: BorderSide(color: Colors.orange),
//                   borderRadius: BorderRadius.circular(10)
//               ),//label text of field
//               focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Styles.appPrimaryColor),
//                   borderRadius: BorderRadius.circular(10)
//               ),
//               labelText: 'Suggestions',
//               contentPadding: EdgeInsets.symmetric(horizontal: minValue),
//               labelStyle: TextStyle(fontSize: 16.0, color: Colors.black26)),
//         ),
//       ),
//     ],
//   );
// }
// Widget _buildDescription2() {
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: minValue, vertical: minValue),
//     child: TextFormField(
//       controller: _messageController,
//       keyboardType: TextInputType.text,
//       maxLines: 2,
//       decoration: InputDecoration(
//           errorStyle: _errorStyle,
//           border: InputBorder.none,
//           enabledBorder: OutlineInputBorder(
//
//               borderSide: BorderSide(color: Colors.orange),
//               borderRadius: BorderRadius.circular(10)
//           ),//label text of field
//           focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Styles.appPrimaryColor),
//               borderRadius: BorderRadius.circular(10)
//           ),
//           labelText: 'If No give Reasons',
//           contentPadding: EdgeInsets.symmetric(horizontal: minValue),
//           labelStyle: TextStyle(fontSize: 16.0, color: Colors.black)),
//     ),
//   );
// }
//
// Widget _buildTextBackground(Widget child) {
//   return Container(
//     decoration: BoxDecoration(
//         color: Colors.white, borderRadius: BorderRadius.circular(2)),
//     child: child,
//   );
// }
//
// Widget _buildSubmitBtn() {
//   return Container(
//     width: double.maxFinite,
//     // color: Color(0xFF15807a),
//     padding: EdgeInsets.symmetric(horizontal: minValue * 3),
//     decoration: BoxDecoration(
//       color: Styles.appPrimaryColor,
//       borderRadius: BorderRadius.circular(10),
//       // gradient:
//       // LinearGradient(colors: [Colors.pink.shade700, Colors.pink.shade400])
//     ),
//     child: RaisedButton(
//       onPressed: () => null,
//       padding: EdgeInsets.symmetric(vertical: minValue * 2.4),
//       elevation: 0.0,
//       color: Colors.transparent,
//       textColor: Colors.white,
//       child: Text('SUBMIT'),
//     ),
//   );
// }