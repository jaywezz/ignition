import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/data/hive_database/hive_manager.dart';
import 'package:soko_flow/data/repository/product_category_repo.dart';
import 'package:soko_flow/models/products_category/product_category_model.dart';

import '../data/hive_database/hive_constants.dart';

class ProductCategoryController extends GetxController {
  static final Logger _log = Logger(
    printer: PrettyPrinter(),
  );
  final ProductCategoryRepo productCategoryRepo;
  ProductCategoryController({required this.productCategoryRepo});

  List<ProductCategoryModel> _productCategoryList = [];
  List<ProductCategoryModel> get productCategoryList => _productCategoryList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  @override
  void onInit() {
    getProductCategories();
    super.onInit();
  }



  Future<void> getProductCategories() async {
    print("getting products");
    if(!Hive.isAdapterRegistered(2)){
      Hive.registerAdapter(ProductCategoryModelAdapter());
    }
    _isLoading = true;
    Response response = await productCategoryRepo.getProductCategories();
    if (response.statusCode == 200) {
      //_log.d('...Got product categories...');
      _productCategoryList = [];
      _productCategoryList
          .addAll(ProductCategory.fromJson(response.body).productCategories);
      // _log.i(response.body);
      //Add data to hive manager
      HiveDataManager(HiveBoxConstants.productsCategoriesDb).addHiveData(_productCategoryList);
      _isLoading = false;
      _isLoaded = true;
      update();
    }else if(response.statusCode == null){
      _productCategoryList = [];
      await HiveDataManager(HiveBoxConstants.productsCategoriesDb).getHiveData().then((box){
        _productCategoryList.addAll(box.get(HiveBoxConstants.productsCategoriesDb).cast<ProductCategoryModel>());

      });
      update();
      print("offline product category list: ${_productCategoryList}");
    }
    else {
      _log.e('Could not Get Ontrack Customers');
      //print('Could not Get Ontrack Customers');
    }
  }
}
