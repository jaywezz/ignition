import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/controllers/add_cart.dart';
import 'package:soko_flow/controllers/add_customer_controller.dart';
import 'package:soko_flow/controllers/customer_checking_controller.dart';
import 'package:soko_flow/controllers/customers_controller.dart';
import 'package:soko_flow/controllers/data_sync_controller.dart';
import 'package:soko_flow/controllers/geolocation_controller.dart';
import 'package:soko_flow/controllers/order_details_controller.dart';
import 'package:soko_flow/controllers/orders_controller.dart';
import 'package:soko_flow/controllers/payment_controller.dart';
import 'package:soko_flow/controllers/product_category_controller.dart';
import 'package:soko_flow/controllers/product_controller.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/controllers/receive_stock_controller.dart';
import 'package:soko_flow/controllers/reconcile_controller.dart';
import 'package:soko_flow/controllers/routes_controller.dart';
import 'package:soko_flow/controllers/stocklift_controller.dart';
import 'package:soko_flow/controllers/survey_controller.dart';
import 'package:soko_flow/controllers/user_deliveries_controller.dart';
import 'package:soko_flow/data/api_service/api-service.dart';
import 'package:soko_flow/data/repository/add_customer_repo.dart';
import 'package:soko_flow/data/repository/stocklift_repo.dart';
import 'package:soko_flow/data/repository/add_to_cart_repo.dart';
import 'package:soko_flow/data/repository/customers_repo.dart';
import 'package:soko_flow/data/repository/order_repository.dart';
import 'package:soko_flow/data/repository/payment_repo.dart';
import 'package:soko_flow/data/repository/product_category_repo.dart';
import 'package:soko_flow/data/repository/product_repo.dart';
import 'package:soko_flow/data/repository/allocations_repo.dart';
import 'package:soko_flow/data/repository/receive_stock_repo.dart';
import 'package:soko_flow/data/repository/reconcile_repo.dart';
import 'package:soko_flow/data/repository/routes_repo.dart';
import 'package:soko_flow/data/repository/survey_repo.dart';
import 'package:soko_flow/data/repository/user_deriveries_repo.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/app_constants.dart';
import '../data/api_service/api_client.dart';
import '../data/repository/auth_repo.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  //api_clients
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  //repos
  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => AddCustomerRepo(apiClient: Get.find()));
  Get.lazyPut(() => ProductCategoryRepo(apiClient: Get.find()));
  Get.lazyPut(() => ProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => AddToCartRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => AddStockLiftRepo(apiClient: Get.find()), fenix: true);
  // Get.lazyPut(() => DeliveriesRepo(apiClient: Get.find()));
  Get.lazyPut(() => StockHistoryRepository(apiClient: Get.find()), fenix: true);
  // Get.lazyPut(() => RouteRepository(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => OrderRepository(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => PaymentRepository(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => ReconcileRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => CustomerRepository(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => SurveyRepository(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => ReceiveStockRepo(apiClient: Get.find()), fenix: true);

  //controllers
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => GeolocationController());
  Get.lazyPut(() => AddCustomerController(addCustomerRepo: Get.find()));
  Get.lazyPut(() => ProductCategoryController(productCategoryRepo: Get.find()), fenix: true);
  // Get.lazyPut(() => ProductController(productRepo: Get.find()), fenix:  true);
  Get.lazyPut(() => AddToCartController(cartRepo: Get.find()), fenix: true);
  // Get.lazyPut(() => DeriveriesController(productRepo: Get.find()));
  Get.lazyPut(() => StockHistoryController(stockHistoryRepository: Get.find()), fenix: true);
  // Get.lazyPut(() => RoutesController(routeRepository: Get.find()), fenix: true);
  Get.lazyPut(() => OrdersController(orderRepository: Get.find()), fenix: true);
  Get.lazyPut(() => OrderDetailsController(orderRepository: Get.find()), fenix: true);
  Get.lazyPut(() => PaymentController(paymentRepository: Get.find()), fenix: true);
  Get.lazyPut(() => StockLiftController(stockLiftRepo: Get.find()), fenix: true);
  Get.lazyPut(() => CustomerCheckingController(), fenix: true);
  Get.lazyPut(() => ReconcileController(reconcileRepo: Get.find()), fenix: true);
  // Get.lazyPut(() => DataSyncController(), fenix: true);
  Get.lazyPut(() => CustomersController(customerRepository: Get.find()), fenix: true);
  Get.lazyPut(() => SurveyController(surveyRepository: Get.find()), fenix: true);
  Get.lazyPut(() => ReceiveStockController(receiveStockRepo: Get.find()), fenix: true);
}
// Get.lazyPut(
  //     () => NotOntrackCustomerController(ontrackCustomerRepo: Get.find()));