import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:soko_flow/utils/app_constants.dart';
import '../../models/customer_model/customer_model.dart';

class ApiProvider extends GetConnect {
  // final String appBaseUrl = "http://172.104.245.14/sokoflowadmin/api";
  // static String baseApi = 'http://172.104.245.14/sokoflowadmin/api';
  final String appBaseUrl = AppConstants.BASE_URL;
  static String baseApi = AppConstants.BASE_URL;

  ApiProvider() {
    httpClient.baseUrl = appBaseUrl;
    httpClient.defaultContentType = 'application/json';
  }

  Future<CustomerModel> getCustomerList(
      String businessCode, var pageSize) async {
    try {
      print("businesscode: ${businessCode}");
      final response =
          await get('/customers/$businessCode?page_size=$pageSize');
      print(response.body);
      Logger().e(customerModelFromJson(response.bodyString!));
      if (response.status.hasError) {
        return Future.error(response.statusText!);
      } else {
        Logger().e(customerModelFromJson(response.bodyString!));
        return customerModelFromJson(response.body);
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

//   Future<Orders> getOrders(String customer_id) async {
//     print("getting orders");
//     try {
//       final response =
//           // await get('/customers/${customer_id}/orders');
//           await get('/customers/4149/orders');
//       if (response.status.hasError) {
//         print("error has occured");
//         print(response.body);
//         return Future.error(response.statusText!);
//       } else {
//         return ordersFromJson(response.bodyString!);
//       }
//     } catch (exception) {
//       return Future.error(exception.toString());
//     }
//   }

//   Future<OrdersDetails> getOrderDetails(String orderCode) async {
//     try {
//       print("at the api");
//       print(orderCode);
//       final response = await get('/customers/order/$orderCode/details');
//       print(response.body);
//       if (response.status.hasError) {
//         return Future.error(response.statusText!);
//       } else {
//         print("data retrieved");
//         return ordersDetailsFromJson(response.bodyString!);
//       }
//     } catch (exception) {
//       return Future.error(exception.toString());
//     }
//   }

//   Future<UserModel> register(
//       {required name, required phoneNumber, required password}) async {
//     try {
//       final response = await post(
//           '/signup',
//           jsonEncode(<String, String>{
//             'name': name,
//             'phone_number': phoneNumber,
//             'password': password
//           }));
//       if (response.status.hasError) {
//         return Future.error(response.statusText!);
//       } else {
//         // return userFromJson(response.bodyString!);
//         var data = json.decode(response.body);
//         return UserModel.fromJson(data);
//       }
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   Future<UserModel> login({required email, required password}) async {
//     try {
//       final response = await post(
//           '/login',
//           jsonEncode(
//               <String, String>{'phone_number': email, 'password': password}));
//       if (response.status.hasError) {
//         return Future.error(response.statusText!);
//       } else {
//         var data = json.decode(response.body);
//         // return userFromJson(response.bodyString!);
//         return UserModel.fromJson(data);
//       }
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   Future<AddCustomerModel> addCustomer(
//       {required customerName,
//       required contactPerson,
//       required businessCode,
//       required createdBy,
//       required phone}) async {
//     try {
//       final response = await post(
//           '/customers/add-customer',
//           jsonEncode(<String, String>{
//             'customer_name': customerName,
//             'contact_person': contactPerson,
//             'business_code': businessCode,
//             'created_by': createdBy,
//             'phone_number': phone,
//           }));
//       if (response.status.hasError) {
//         return Future.error(response.statusText!);
//       } else {
//         return addCustomerModelFromJson(response.bodyString!);
//       }
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

// // http://172.104.245.14/sokoflowadmin/api/customer/Qx4FstqLJfHwf3WA/checkin
//   Future<CustomerOrdersModels> customerOrders(int customerID) async {
//     final response = await http
//         .get(Uri.parse("${appBaseUrl}/customers/${customerID}/orders/"));
//     if (response.statusCode == 200) {
//       var data = json.decode(response.body);
//       return CustomerOrdersModels.fromJson(data);
//     } else {
//       throw Exception("Failed to load customer orders");
//     }
//   }

//   // http://172.104.245.14/sokoflowadmin/api/customers/2/Qx4FstqLJfHwf3WA/deliveries
//   Future<CustomerDeliveriesModels> customerDeriveries(
//       String businessCode, int customerID) async {
//     final response = await http.get(Uri.parse(
//         "${appBaseUrl}/customers/${customerID}/${businessCode}/deliveries/"));
//     if (response.statusCode == 200) {
//       var data = json.decode(response.body);
//       return CustomerDeliveriesModels.fromJson(data);
//     } else {
//       throw Exception("Failed to load customer deliveries");
//     }
//   }

//   // http://172.104.245.14/sokoflowadmin/api/checkin/hjQU9UX9qYEFLyRPzAFP/orders
//   Future<OrderHistoryModels> orderHistory(String checkinCode) async {
//     final response = await http
//         .get(Uri.parse("${appBaseUrl}/checkin/${checkinCode}/orders/"));
//     if (response.statusCode == 200) {
//       var data = json.decode(response.body);
//       return OrderHistoryModels.fromJson(data);
//     } else {
//       throw Exception("Failed to load customer order history.");
//     }
//   }

//   static Future<ProductCategoryModel> productCategory(
//       String businessCode) async {
//     try {
//       var response = await http
//           .get(Uri.parse("${baseApi}/productsModel/categories/${businessCode}"));
//       // print("My Response::: ${response.body}");
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);
//         return ProductCategoryModel.fromJson(data);
//       } else {
//         throw Exception("Failed to get Product Categories.");
//       }
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   static Future<CustomerCheckinModel> customerCheckin(String latitude,
//       String longitude, String customerId, String user_code) async {
//     try {
//       var response = await http.post(
//         Uri.parse("${baseApi}/customer/checkin/session/"),
//         headers: {
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode(
//           {
//             "customerID": customerId,
//             "latitude": latitude,
//             "longitude": longitude,
//             "user_code": user_code,
//           },
//         ),
//       );
//       if (response.statusCode == 200) {
//         print(response.body);
//         var data = json.decode(response.body);
//         return CustomerCheckinModel.fromJson(data);
//       } else {
//         throw Exception("Failed to checkin Customer.");
//       }
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   static Future CustomerCheckout(String checkinCode) async {
//     try {
//       final response = await http.get(Uri.parse(
//         "${baseApi}/checkin/${checkinCode}/out/",
//       ));
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);
//         return data;
//       } else {
//         throw Exception("Failed to checkout Customer.");
//       }
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   static Future<ProductsModel> productsModel(String businessCode) async {
//     try {
//       var response =
//           await http.get(Uri.parse("${baseApi}/productsModel/${businessCode}"));

//       if (response.statusCode == 200) {
//         // print("My Response+++::: ${response.body}");
//         var data = json.decode(response.body);
//         return ProductsModel.fromJson(data);
//       } else {
//         throw Exception("Failed to get Products.");
//       }
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   static Future<ProductsByCategoryModel> productsByCategory(
//       String categoryID) async {
//     try {
//       var response = await http
//           .get(Uri.parse("${baseApi}/productsModel/${categoryID}/category"));
//       if (response.statusCode == 200) {
//         // print("Products by Category: ${response.body}");
//         var data = json.decode(response.body);
//         return ProductsByCategoryModel.fromJson(data);
//       } else {
//         throw Exception("Failed to get productsModel.");
//       }
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   static Future<UserDeliveriesModel> userDeliveries(
//       String businessCode, String userCode) async {
//     try {
//       var response = await http
//           .get(Uri.parse("${baseApi}/deliveries/${businessCode}/${userCode}"));
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);
//         // print("Delivery Response:::: ${data}");
//         return UserDeliveriesModel.fromJson(data);
//       } else {
//         throw Exception("Failed to get user deliveries.");
//       }
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   static Future<DeliveriesDetailsModel> deliveriesDetails(
//       String deliveryCode, String businessCode) async {
//     try {
//       var response = await http.get(
//           Uri.parse("${baseApi}/deliveries/${deliveryCode}/${businessCode}"));
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);
//         print("Delivery Details Response:::: ${data}");
//         return DeliveriesDetailsModel.fromJson(data);
//       } else {
//         throw Exception("Failed to get user deliveries.");
//       }
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   static Future<AddToCart> addToCart(
//       String productID, String qty, String CheckinCode) async {
//     try {
//       var response = await http.post(
//         Uri.parse("${baseApi}/api/checkin/${CheckinCode}/add-to-cart"),
//         headers: {
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode(
//           {
//             "productID": productID,
//             "qty": qty,
//           },
//         ),
//       );
//       if (response.statusCode == 200) {
//         var data = json.decode(response.body);
//         return AddToCart.fromJson(data);
//       } else {
//         throw Exception("Failed to add to cart.");
//       }
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }
}

// class AuthServices {
//   static String baseApi = 'http://172.104.245.14/sokoflowadmin/api';

//   static var client = http.Client();

//   static login({required email, required password}) async {
//     var response = await client.post(
//       Uri.parse('$baseApi/login'),
//       headers: {
//         "Content-type": 'application/json',
//       },
//       body: jsonEncode(<String, String>{'email': email, 'password': password}),
//     );
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       // var stringObject = response.body;
//       // var user = userFromJson(stringObject);
//       var data = json.decode(response.body);
//       var user = UserModel.fromJson(data);
//       return user;
//     } else {
//       return null;
//     }
//   }

//   static Future<AddCustomerModel?> addCustomer(
//       {required customerName,
//       required contactPerson,
//       required businessCode,
//       required createdBy,
//       required phone}) async {
//     var response = await http.post(
//       Uri.parse('$baseApi/customers/add-customer'),
//       headers: {
//         "Content-type": 'application/json',
//       },
//       body: jsonEncode(<String, String>{
//         'customer_name': customerName,
//         'contact_person': contactPerson,
//         'business_code': businessCode,
//         'created_by': createdBy,
//         'phone_number': phone,
//       }),
//     );
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       var stringObject = response.body;
//       var customer = addCustomerModelFromJson(stringObject);
//       return customer;
//     } else {
//       return null;
//     }
//   }
// }

// class CallApi {
//   final String _url = 'http://172.104.245.14/sokoflowadmin/api';
//   postData(data, apiUrl) async {
//     var fullUrl = _url + apiUrl;
//     return await http.post(
//       Uri.parse(fullUrl),
//       body: jsonEncode(data),
//       headers: _setHeaders(),
//     );
//   }

//   _setHeaders() => {
//         'Content-type': 'application/json',
//         'Accept': 'application/json',
//       };
// }
