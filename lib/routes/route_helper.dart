import 'package:get/get.dart';
import 'package:soko_flow/data/binding/customer_binding.dart';
import 'package:soko_flow/data/binding/geolocation_binding.dart';
import 'package:soko_flow/splash_screen.dart';
import 'package:soko_flow/views/customers/components/customer_details.dart';
import 'package:soko_flow/views/customers/geofencing_example.dart';
import 'package:soko_flow/views/customers/sales/confirm_sales_cart.dart';
import 'package:soko_flow/views/customers/sales/create_order_screen.dart';
import 'package:soko_flow/views/deliveries/deliveries_screen.dart.bak';
import 'package:soko_flow/views/deliveries/deliveries_screen2.dart';
import 'package:soko_flow/views/home/home_screen.dart';
import 'package:soko_flow/views/home/home_screen2.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/components/confirm_stocklift.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/reconcile/confirm_reconcile_items.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/reconcile/reconcile.dart';
import 'package:soko_flow/views/inventory/inventory_detailed_screens/reconcile/reconcile_products.dart';
import 'package:soko_flow/views/product_catalogue/product_catalogue.dart';
import 'package:soko_flow/views/profile/notification_screen.dart';
import 'package:soko_flow/views/profile/user_profile_screen.dart';
import 'package:soko_flow/views/reports/reports_screen.dart';

import '../views/auth/login_page.dart';
import '../views/customers/order_details/order_details.dart';
import '../views/customers/sales/confirm_sales_cart.dart';
import '../views/customers/customers_screen.dart';
import '../views/customers/new_customer.dart';
import '../views/customers/sales/success_screen.dart';

class RouteHelper {
  static const String _splashPage = "/splash-page";
  static const String _initial = "/home";
  static const String _initial2 = "/home2";
  static const String _login = '/login';
  static const String _customers = '/customers';
  static const String _addcustomers = '/addcustomers';
  static const String _customerdetails = '/customerdetails';
  static const String _confirmCart = '/confirmSalesCart';
  static const String _confirmStockLift = '/confirmStockLift';
  static const String _createOrder = '/createOrder';
  static const String _createOrderSuccess = '/createOrderSuccess';
  static const String _orderHistoryScreen = '/orderHistory';
  static const String _orderDetailsScreen = '/orderDetailsScreen';
  static const String _profileScreen = '/profileScreen';
  static const String _notificationScreen = '/notificationScreen';
  static const String _reconcile = '/reconcile';
  static const String _confirmReconcileProducts = '/confirmReconcileProducts';
  static const String _reports = '/reports';
  static const String _userDeLiveries = '/userDeliveries';
  static const String _productCatalogue = '/productCatalogue';

  static String getSplashPage() => _splashPage;
  static String getInitial() => _initial;
  static String getInitial2() => _initial2;
  static String getLogin() => _login;
  static String getCustomers() => _customers;
  static String addCustomers() => _addcustomers;
  static String getCustomerDetails() => _customerdetails;
  static String confirmSalesCart() => _confirmCart;
  static String createOrder() => _createOrder;
  static String createOrderSuccess() => _createOrderSuccess;
  static String orderHistoryScreen() => _orderHistoryScreen;
  static String orderDetailsScreen() => _orderDetailsScreen;
  static String ProfileScreen() => _profileScreen;
  static String Notifications() => _notificationScreen;
  static String reconcile() => _reconcile;
  static String ConfirmReconcileProducts() => _confirmReconcileProducts;
  static String reports() => _reports;
  static String UserDeliveries() => _userDeLiveries;
  static String ProductCatalogue() => _productCatalogue;


  static String confirmStcokLit() => _confirmStockLift;

  static List<GetPage> routes = [
    GetPage(
      name: _splashPage,
      page: () => const SplashScreenPage(),
      transitionDuration: const Duration(milliseconds: 100),
      transition: Transition.fadeIn,
    ),
    // GetPage(
    //   name: _initial2,
    //   // page: () => ExampleApp(),
    //   page: () => HomeScreen(),
    // ),
    GetPage(
      name: _initial,
      // page: () => ExampleApp(),
      page: () => HomeScreen2(),
    ),
    GetPage(
      name: _login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: _customers,
      page: () => CustomersScreen(),
      // binding: CustomerBinding(),
    ),
    GetPage(
      name: _addcustomers,
      page: () => AddNewCustomer(),
      //binding: GeolocationBinding(),
    ),
    // GetPage(
    //   name: _customerdetails,
    //   page: () => CustomerDetailsScreen(),
    // ),
    // GetPage(
    //   name: _confirmCart,
    //   page: () => ConfirmSalesCart(),
    //   transitionDuration: const Duration(milliseconds: 100),
    //   transition: Transition.fadeIn,
    // ),

    // GetPage(
    //   name: _confirmStockLift,
    //   page: () => ConfirmStockLift(),
    //   transitionDuration: const Duration(milliseconds: 100),
    //   transition: Transition.fadeIn,
    // ),
    GetPage(
      name: _createOrder,
      page: () => CreateOrderScreen(),
      transitionDuration: const Duration(milliseconds: 100),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _createOrderSuccess,
      page: () => SuccessScreen(),
      transitionDuration: const Duration(milliseconds: 100),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _orderDetailsScreen,
      page: () => OrderDetailsScreen(),
      transitionDuration: const Duration(milliseconds: 100),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: _profileScreen,
      page: () => UserProfileScreen(),
      transitionDuration: const Duration(milliseconds: 100),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _notificationScreen,
      page: () => NotificationsScreen(),
      transitionDuration: const Duration(milliseconds: 100),
      transition: Transition.fadeIn,
    ),

    // GetPage(
    //   name: _reconcile,
    //   page: () => Reconcile(),
    //   transitionDuration: const Duration(milliseconds: 100),
    //   transition: Transition.fadeIn,
    // ),

    // GetPage(
    //   name: _confirmReconcileProducts,
    //   page: () => ConfirmReconcileCart(),
    //   transitionDuration: const Duration(milliseconds: 100),
    //   transition: Transition.fadeIn,
    // ),
    GetPage(
      name: _reports,
      page: () => ReportsScreen(),
      transitionDuration: const Duration(milliseconds: 100),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: _userDeLiveries,
      page: () => DeliveryScreen(),
      transitionDuration: const Duration(milliseconds: 100),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _productCatalogue,
      page: () => ProductCatalogueScreen(),
      transitionDuration: const Duration(milliseconds: 100),
      transition: Transition.fadeIn,
    ),


  ];
}
