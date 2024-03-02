// import 'package:flutter/cupertino.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:soko_flow/database/api_service/api-service.dart';
// import 'package:soko_flow/database/models/product_category_model.dart';
// import 'package:soko_flow/database/models/products_by_category_model.dart';
// import 'package:soko_flow/database/models/products_model.dart';

// class ProductCategoryProvider extends ChangeNotifier {
//   var storage = const FlutterSecureStorage();
//   ApiProvider apiProvider = ApiProvider();
//   final List<Category> _categorylst = [];
//   final newSalesSearchController = TextEditingController();

//   List<Category> get categorylst => _categorylst;
//   Future fetchProductCategory() async {
//     var businessCode = (await storage.read(key: 'businessCode')) ?? '';

//     print("Called:");
//     await ApiProvider.productCategory(businessCode).then((value) {
//       _categorylst.clear();
//       _categorylst.addAll(value.data!);
//     });
//     notifyListeners();
//   }

//   List<Product> _productlst = [];
//   List<Product> get productlst => _productlst;
//   void filterProducts(String entered_value) {
//     List<Product> products_results = [];
//     if (newSalesSearchController.text == "") {
//       print("The value is empty");
//       products_results = productlst;
//       fetchProducts();
//     } else {
//       products_results = productlst
//           .toList()
//           .where((element) => element.productName
//               .toString()
//               .toLowerCase()
//               .contains(newSalesSearchController.text.toLowerCase()))
//           .toList();
//     }
//   }

//   Future<List<Product>> fetchProducts() async {
//     print("Called Products Provider...");
//     var businessCode = (await storage.read(key: 'businessCode')) ?? '';
//     await ApiProvider.productsModel(businessCode).then((value) {
//       _productlst.clear();
//       _productlst.addAll(value.data!);
//     });
//     notifyListeners();
//     return _productlst;
//     // print("Products Provider ${_productlst}");
//   }

//   List<Products> _categoryProductslst = [];
//   List<Categories> _prodCategoryLst = [];
//   List<Categories> get prodCategoryLst => _prodCategoryLst;
//   List<Products> get categoryProductslst => _categoryProductslst;
//   Future<List<Products>> fetchProductsByCategory(String categoryID) async {
//     print("Called Products By Category Provider....");
//     await ApiProvider.productsByCategory(categoryID).then((value) {
//       _categoryProductslst.clear();
//       _categoryProductslst.addAll(value.productsModel!);
//     });
//     notifyListeners();
//     return _categoryProductslst;
//     print("Products Category Provider... ${_categoryProductslst}");
//   }

//   var addToCartResp;
//   Future addToCart(String productID, String qty, String CheckinCode) async {
//     print("Called Add To Cart Provider....");

//     await ApiProvider.addToCart(productID, qty, CheckinCode).then((value) {
//       print("Add To Cart Provider.... ${value.message}");
//       addToCartResp = value;
//     });

//     notifyListeners();
//     return addToCartResp;
//   }
// }
