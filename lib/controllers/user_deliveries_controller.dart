// import 'package:get/get.dart';
// import 'package:logger/logger.dart';
// import 'package:soko_flow/models/derivery_model.dart';
//
// import '../data/repository/product_repo.dart';
// import '../data/repository/user_deriveries_repo.dart';
// import '../models/productsModel/products_model.dart';
//
// class DeriveriesController extends GetxController {
//   static final Logger _log = Logger(
//     printer: PrettyPrinter(),
//   );
//   final DeliveriesRepo productRepo;
//   DeriveriesController({required this.productRepo});
//
//   List<DeriveryModel> _productList = [];
//   List<DeriveryModel> get productList => _productList;
//   bool _isLoaded = false;
//   bool get isLoaded => _isLoaded;
//
//   Future<void> getDeliveries() async {
//     Response response = await productRepo.getDeliveries();
//     if (response.statusCode == 200) {
//       _log.d('...Got product categories...');
//
//       _productList = [];
//       _log.i(response.body);
//       _productList.addAll(Delivery.fromJson(response.body).products);
//
//       _log.i(_productList.length);
//       _isLoaded = true;
//       update();
//     } else {
//       _log.e('Could not Get deliveries');
//       //print('Could not Get Ontrack Customers');
//     }
//   }
// }
