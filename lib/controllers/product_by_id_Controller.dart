// import 'dart:io';
//
// import 'package:flutter/widgets.dart';
//
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
// import 'package:soko_flow/models/products_model.dart';
//
// class ProductModel extends ChangeNotifier {
//   List<Product> _products = [];
//   List<Product> get menus => _products;
//
//   Future<List<Product>> fetchProductById(String id) async {
//     final baseUrl =
//         'http://172.104.245.14/sokoflowadmin/api/productsModel/$id/category';
//     final response = await http
//         .get(Uri.parse(baseUrl))
//         .timeout(const Duration(seconds: 10), onTimeout: () {
//       throw TimeoutException('The connection has timed out, Please try again!');
//     });
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body)['productsModel'] as List;
//       List<Product> apimenus = data.map((a) => Product.fromJson(a)).toList();
//       _products = apimenus;
//
//       return _products;
//     } else {
//       throw Exception('Failed Loading menus');
//     }
//   }
//
//   List<Product> findByCategory(String category) {
//     List<Product> _categoryList = _products
//         .where((element) =>
//             element.category!.toLowerCase().contains(category.toLowerCase()))
//         .toList();
//     return _categoryList;
//   }
//
//   // Product findById(String menuId) {
//   //   return _products.firstWhere((element) => element.id.toString() == menuId);
//   // }
// }
