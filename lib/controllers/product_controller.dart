// import 'package:get/get.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:logger/logger.dart';
// import 'package:soko_flow/data/hive_database/hive_constants.dart';
// import 'package:soko_flow/data/hive_database/hive_manager.dart';
//
// import '../data/repository/product_repo.dart';
// import '../models/productsModel/products_model.dart';
//
// class ProductController extends GetxController {
//   static final Logger _log = Logger(
//     printer: PrettyPrinter(),
//   );
//   final ProductRepo productRepo;
//   ProductController({required this.productRepo});
//
//   List<ProductsModel> _productList = [];
//   List<ProductModel> get productList => _productList;
//   bool _isLoaded = false;
//   bool get isLoaded => _isLoaded;
//   String currentCategory= "";
//
//   Future<void> getProducts() async {
//     print("getting products");
//     if(!Hive.isAdapterRegistered(1)){
//       Hive.registerAdapter(ProductMoAdapter());
//     }
//     Response response = await productRepo.getProducts();
//     if (response.statusCode == 200) {
//       _log.d('...Got product categories...');
//
//       _productList = [];
//       _productList.addAll(Product.fromJson(response.body).products);
//       //Add data to hive any time there is internet connection
//       HiveDataManager(HiveBoxConstants.productsDb).addHiveData(_productList);
//       // _log.i(response.body);
//       // _log.i(_productList.length);
//       _isLoaded = true;
//       update();
//     } else if(response.statusCode == null){
//       _productList = [];
//       await HiveDataManager(HiveBoxConstants.productsDb).getHiveData().then((box){
//         // print("products db : ${box.get(HiveBoxConstants.productsDb)}");
//         _productList.addAll(box.get(HiveBoxConstants.productsDb).cast<ProductMo>());
//       });
//       _isLoaded = true;
//       update();
//
//     }
//     else {
//       _log.e('Could not Get Products');
//       //print('Could not Get Ontrack Customers');
//     }
//   }
// }
