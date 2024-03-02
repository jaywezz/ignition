// import 'package:flutter/cupertino.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:soko_flow/database/api_service/api-service.dart';
// import 'package:soko_flow/database/models/deliveries_details_model.dart';
// // import 'package:soko_flow/database/models/deliveries_details_model.dart';
// // import 'package:soko_flow/views/customers/shop_deliveries.dart';
// import 'package:soko_flow/database/models/user_deliveries_model.dart';

// class UserDeliveriesProvider extends ChangeNotifier {
//   var storage = const FlutterSecureStorage();
//   ApiProvider apiProvider = ApiProvider();
//   List<Delivery> _deliverieslst = [];
//   List<Delivery> get deliverieslst => _deliverieslst;
//   Future fetchUserDeliveries() async {
//     var businessCode = (await storage.read(key: 'businessCode')) ?? '';
//     var userCode = (await storage.read(key: 'userCode')) ?? '';
//     print("Called user deliveries,${businessCode}--> ${userCode}");
//     await ApiProvider.userDeliveries(businessCode, userCode).then((value) {
//       print("----------////${value.data}");
//       _deliverieslst.clear();
//       _deliverieslst.addAll(value.data!);
//     });
//     notifyListeners();

//     print("User Deli------->: ${_deliverieslst}");
//     return _deliverieslst;
//   }

//   List<Order> _deliveryDetailsLst = [];
//   List<Order> get deliveryDetailsLst => _deliveryDetailsLst;
//   // List<Order> get deliveryDetailsLst => _deliveryDetailsLst;
//   Future fetchDeliveriesDetails(String deliveryCode) async {
//     var businessCode = (await storage.read(key: 'businessCode')) ?? '';
//     print("Called Delivery Details ${businessCode} with ${deliveryCode}");

//     await ApiProvider.deliveriesDetails(businessCode, deliveryCode);

//     notifyListeners();
//     print("Delivery Details: ${_deliveryDetailsLst}");
//   }
// }
