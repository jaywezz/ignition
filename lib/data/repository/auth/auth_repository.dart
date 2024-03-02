// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../configs/urls.dart';
// import '../../../helper/dio_exceptions.dart';
// import '../../providers/client_provider.dart';

// final authRepositoryProvider =
//     Provider<AuthRepositoryAPI>((ref) => AuthRepositoryAPI(ref));

// abstract class AuthRepository {
//   Future login(
//     String email,
//     String password,
//     String device_token,
//   );
 
  
 
//   // Future socialLogin(
//   //   String name,
//   //   String email,
//   //   String? phone_number,
//   //   String? token,
//   //   bool? email_verified,
//   //   String device_token,
//   // );
// }

// class AuthRepositoryAPI implements AuthRepository {
//   final Ref ref;
//   AuthRepositoryAPI(this.ref);

//   @override
//   Future login(String email, String password, String device_token) async {
//     try {
//       final response =
//           await ref.read(clientProvider).post(Urls.loginApi, data: {
//         "email": email,
//         "password": password,
//         "device_token": device_token,
//       });

//       return response.data;
//     } on DioError catch (e) {
//       throw DioExceptions.fromDioError(e);
//     }
//   }



 

//   // @override
//   // Future socialLogin(
//   //   String name,
//   //   String email,
//   //   String? phone_number,
//   //   String? token,
//   //   bool? email_verified,
//   //   String device_token,
//   // ) async {
//   //   try {
//   //     final result =
//   //         await read.read(clientProvider).post(Urls.socialLogin, data: {
//   //       "name": name,
//   //       "email": email,
//   //       "phone_number": phone_number,
//   //       "token": token,
//   //       "email_verified": email_verified,
//   //       "device_token": device_token,
//   //     });
//   //     return result.data;
//   //   } on DioError catch (e) {
//   //     final errorMessage = DioExceptions.fromDioError(e).toString();
//   //     throw errorMessage;
//   //   }
//   // }
// }
