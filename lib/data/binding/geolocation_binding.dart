import 'package:get/get.dart';

import '../../controllers/geolocation_controller.dart';

class GeolocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GeolocationController>(GeolocationController());
  }
}
