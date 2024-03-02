import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/data/repository/allocations_repo.dart';

class AppConstants {
  var user_code = "";
 getUserCode()async {
    var prefs = await SharedPreferences.getInstance();
    user_code =  prefs.getString(AppConstants.USER_CODE)!;
  }

  static const String APP_NAME = "SOKOFLOW";
  static const int APP_VERSION = 1;
  // static const String BASE_URL = "http://172.104.245.14/sokoflowadmin/api";
  // static const String BASE_URL = "https://apps.sokoflow.com/api";
  static const String BASE_URL = "https://ignitionmarketing.sokoflow.com/api";
  // static const String BASE_URL = "http://20.115.72.101/sidai_staging/api";
  // static const String BASE_URL = "https://sidai.sokoflow.com/sidai_staging/api";

  //user and auth end points
  static const String LOGIN_URI = '/login';
  static const String USER_INFO_URI = "/api/v1/users/mobile-user";
  static const String OTP_SEND = "/send/otp/";
  static const String CHANGE_PASSWORD = "/reset-password";

  //customers
  static const String CUSTOMERS_LIST = '/customers/';
  static const String ADD_CUSTOMERS = '/customers/add-customer';
  static const String ADD_CART = '/customers/edit-customer';

  static const ADD_USER_ROUTE = '/AddNewRoute';
  static const ADD_PAYMENT = '/payment';
  static const USER_DELIVERIES = '/get/deliveries';
  static const GET_REPORTS = '/get/reports';

  static const String PRODUCT_CATEGORY =
      '/products/categories/';
  

// static const String CUSTOMER_CHECKIN='/customer/checkin/session/';
// static const String CUSTOMER_CHECKOUT='/checkin/${checkinCode}/out/';

  static const String PRODUCTS = "/products/";

  static const String TOKEN = "token";
  static const String EMAIL = "email";
  static const String PHONE_NUMBER = "phone";
  static const String ID = "id";
  static const String USER_CODE = "user_code";
  static const String BUSINESS_CODE = "business_code";
  static const String USER_NAME = "name";
  static const String USER_REGION = "user_region";


}
