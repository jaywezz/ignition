import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soko_flow/configs/urls.dart';
import 'package:soko_flow/utils/app_constants.dart';

import '../../services/auth_service.dart';

final clientProvider = Provider.autoDispose((ref) {
  Dio _dio;
  _dio = Dio(
    BaseOptions(
      headers: {
        "Authorization": AuthService.instance.authUser == null
            ? ''
            : 'Bearer ${AuthService.instance.authUser!.accessToken}',
      },
      // baseUrl: "http://172.104.245.14/sokoflowadmin/api/",
      baseUrl: AppConstants.BASE_URL,

      connectTimeout: 150000,
      receiveTimeout: 150000,
      responseType: ResponseType.json,
    ),
  );
  _dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseHeader: true,
      responseBody: true,
    ),
  );

  return _dio;
});
