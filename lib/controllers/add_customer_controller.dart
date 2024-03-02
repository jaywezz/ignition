import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/controllers/customer_checking_controller.dart';
import 'package:soko_flow/controllers/customers_controller.dart';

import '../data/repository/add_customer_repo.dart';
import '../models/response_model.dart';

class AddCustomerController extends GetxController implements GetxService {
  static final Logger _log = Logger(
    printer: PrettyPrinter(),
  );
  final AddCustomerRepo addCustomerRepo;
  AddCustomerController({required this.addCustomerRepo});
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> addCustomer(
      String customer_name,
      String email,
      String contact_person,
      String phone_number,
      String latitude,
      String longitude,
      String address) async {
    _log.d("Adding Customer");

    _isLoading = true;
    update();
    Response response = await addCustomerRepo.addCustomer(customer_name, email,
        contact_person, phone_number, latitude, longitude, address);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
      Get.find<CustomerCheckingController>().geofenceService.stop();
      await Get.find<CustomersController>().getCustomers(45, true);
      Get.find<CustomerCheckingController>().geofenceService.start(Get.find<CustomerCheckingController>()
          .lstCustomerGeofences).catchError(Get.find<CustomerCheckingController>().onError);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
