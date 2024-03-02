//shared preferences
import 'package:shared_preferences/shared_preferences.dart';

setPreference(String key, String value) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  } catch (e) {
    print(e);
  }
}

//shared preferences
Future<String?> getPreference(String key) async {
  String? response;
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    response = pref.getString(key);
  } catch (e) {
    print(e);
  }
  return response;
}

Future<bool> removePreference(String key) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool done = await pref.remove(key);
    return done;
  } catch (e) {
    print(e);
  }
  return false;
}
