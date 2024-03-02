import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/data/repository/payment_repo.dart';
import 'package:soko_flow/models/response_model.dart';

import '../base/show_custom_snackbar.dart';
import 'package:dio/dio.dart' as d;
class PaymentController extends GetxController{
  PaymentRepository paymentRepository;
  PaymentController({required this.paymentRepository});


  static final Logger _log = Logger(
    printer: PrettyPrinter(),
  );
  PaymentMethods paymentMethod = PaymentMethods.Mpesa;

  String orderCode = "";
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> addOrderPayment(String orderID, String amount, String transactionID, String paymentMethod) async{
    refresh();
    _isLoading = true;
    update();

    try{
      d.Response response = await paymentRepository.addOrderPayment(orderID, amount, transactionID, paymentMethod);
      _isLoading = false;
      update();
      showCustomSnackBar("Successfully added order Payment", isError: false);
      return ResponseModel(true, response.statusMessage!);
    }catch (e){
      _isLoading = false;
      update();
      showCustomSnackBar("An error occurred, try again later", isError: true);
      return ResponseModel(false, e.toString());
    }
  }

}

enum PaymentMethods { Mpesa, Cheque, Cash, BankTransfer }