// import 'package:flutter/material.dart';

// class Navigate {
//   late GlobalKey<NavigatorState> navigationKey;
//   late GlobalKey<ScaffoldState> scaffoldKey;

//   static Navigate instance = Navigate();

//   Navigate() {
//     navigationKey = GlobalKey<NavigatorState>();
//   }

//   Future<dynamic> toRemove(String _rn) {
//     return navigationKey.currentState!
//         .pushNamedAndRemoveUntil(_rn, (Route<dynamic> route) => false);
//   }

//   Future<dynamic> to(String _rn) {
//     return navigationKey.currentState!.pushNamed(_rn);
//   }

//   Future<dynamic> toRoute(Widget page) {
//     return navigationKey.currentState!
//         .push(MaterialPageRoute(builder: (context) => page));
//   }

//   goback() {
//     return navigationKey.currentState!.pop();
//   }

//   popUntil(route) {
//     return navigationKey.currentState!.popUntil(ModalRoute.withName(route));
//   }

//   get context => navigationKey.currentContext;

//   void setScaffold(GlobalKey<ScaffoldState> globalKey) {
//     scaffoldKey = globalKey;
//   }

//   openDraw() {
//     scaffoldKey.currentState!.openDrawer();
//   }
// }
