import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/data/hive_database/hive_constants.dart';
import 'package:soko_flow/data/hive_database/hive_manager.dart';
import 'package:soko_flow/data/providers/client_provider.dart';
import 'package:soko_flow/helper/dio_exceptions.dart';
import 'package:soko_flow/models/route_schedule_model.dart';
import 'package:soko_flow/utils/app_constants.dart';

final routesRepository =
    Provider<RoutesRepository>((ref) => RoutesRepository(ref));

class RoutesRepository extends StateNotifier {
  final Ref _reader;

  RoutesRepository(this._reader) : super(0);

  Future<List<UserRouteModel>> getUserRoutes(bool isSync) async {
    var prefs = await SharedPreferences.getInstance();
    String USER_ROUTE = '/route/schedule/${prefs.getString(AppConstants.ID)}';
    List<UserRouteModel> userRoutes = [];
    isSync = true;
    try {
      await HiveDataManager(HiveBoxConstants.userRoutesDb).getHiveData().then((box){
        if(box.isNotEmpty){
          userRoutes.addAll(box.get(HiveBoxConstants.userRoutesDb).cast<UserRouteModel>());
        }
      });
      if(userRoutes.isNotEmpty && isSync == false){
        print("getting schedules offline");
        return userRoutes;
      }else{
        print("getting schedules online");
        var prefs = await SharedPreferences.getInstance();
        String token = (await prefs.getString(AppConstants.TOKEN))!;
        final response = await _reader.read(clientProvider).get(USER_ROUTE);
        final routes = routesFromJson(response.data["user routes"]);
        HiveDataManager(HiveBoxConstants.userRoutesDb).addHiveData(routes);
        return routes;
      }
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }catch(e,s){
      print("error on schedules: $s");
      throw e;
    }
  }

  Future addCustomerVisit(String routeName, String customerId, String startDate) async {
    print("customer id at the repository ${customerId}");
    try {
      var prefs = await SharedPreferences.getInstance();
      String token = (await prefs.getString(AppConstants.TOKEN))!;

      await _reader.read(clientProvider).post(AppConstants.ADD_USER_ROUTE, data: {
        "name": routeName,
        "status": "active",
        "customer_id": customerId,
        "end_date": startDate,
        "start_date": startDate,
      });
    }on DioError catch(dioError){
      if(dioError.message.contains("SocketException")){
        print("error no internet connection");
      }else{
        throw DioExceptions.fromDioError(dioError);
      }
    }
    catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    }
  }
}
