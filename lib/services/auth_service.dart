import 'dart:convert';

import '../models/user_model.dart';
import 'shared_service.dart';

class AuthService {
  UserModel? authUser;
  Map? loginDate;

  static AuthService instance = AuthService();

  login(Map<String, dynamic> userMap) async {
    authUser = UserModel.fromJson(userMap);

    await setPreference('authUser', jsonEncode(authUser));
  }

  Future load() async {
    String? userString = await getPreference('authUser');
    if (userString == null) {
      return false;
    }
    authUser = UserModel.fromJson(jsonDecode(userString));

    return true;
  }

  Future logout() async {
    return await removePreference('authUser');
  }
}
