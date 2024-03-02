// import 'package:get/get.dart';
// import 'package:soko_flow/logic/bindings/add_customer_binding.dart';
// import 'package:soko_flow/logic/bindings/auth_binding.dart';
// import 'package:soko_flow/logic/bindings/customer_binding.dart';
// import 'package:soko_flow/logic/bindings/login_binding.dart';
// import 'package:soko_flow/logic/bindings/order_binding.dart';
// import 'package:soko_flow/splash_screen.dart';
// import 'package:soko_flow/views/auth/login_page.dart';
// import 'package:soko_flow/views/customers/customers_screen.dart';
// import 'package:soko_flow/views/customers/new_customer.dart';
// import 'package:soko_flow/views/customers/order_history.dart';
// import 'package:soko_flow/views/customers/order_history_screen.dart';
// import 'package:soko_flow/views/home/home_screen.dart';
// import 'package:soko_flow/logic/bindings/geolocation_binding.dart';

// import '../../views/customers/components/customer_details.dart';

// class AppRoutes {
//   static const home = Routes.home;
//   static const customerDetails = Routes.customerDetails;
//   static const addCustomer = Routes.addCustomer;
//   static const customers = Routes.customers;
//   static const orders = Routes.orders;
//   static const ordersDetails = Routes.ordersDetails;
//   static const login = Routes.login;
//   static const splash = Routes.splash;

//   static final routes = [
//     GetPage(name: Routes.home, page: () => HomeScreen()),
//     GetPage(name: Routes.customerDetails, page: () => CustomerDetailsScreen()),
//     // GetPage(name: Routes.productDetails, page: () => const ProductsDetails()),
//     // GetPage(name: Routes.insertProduct, page: () => InsertProductsView()),
//     GetPage(
//         name: Routes.customers,
//         page: () => CustomersScreen(),
//         binding: CustomerBinding()),
//     GetPage(
//         name: Routes.orders,
//         page: () => OrdersScreen(),
//         binding: OrdersBinding()),

//     GetPage(
//         name: Routes.ordersDetails,

//         page: () => OrderHistory(),
//         binding: OrderDetailsBinding()),
//     GetPage(name: Routes.addCustomer, page: () => AddNewCustomer(), bindings: [
//       AddCustomerBinding(),
//       GeolocationBinding(),
//     ]),
//     GetPage(
//       name: Routes.login,
//       page: () => const LoginPage(),
//       binding: LoginBinding(),
//     ),
//     GetPage(
//         name: Routes.splash,
//         page: () => const SplashScreenPage(),
//         binding: AuthBinding()),
//   ];
// }

// class Routes {
//   static const home = '/home';
//   static const customerDetails = '/customer_details';
//   static const addCustomer = '/add_customer';
//   static const customers = '/customers';
//   static const orders = '/orders';
//   static const ordersDetails = '/orders_details';
//   static const login = '/login';
//   static const splash = '/splash';
// }
