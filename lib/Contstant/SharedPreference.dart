import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static final sharedPreference = SharedPreference._();
  SharedPreference._();

  getIntMethod(reviewKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(reviewKey);
  }

  setIntMethod(reviewKey, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(reviewKey, value);
  }

  getBoolMethod(reviewCompleteKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(reviewCompleteKey);
  }

  setBoolMethod(reviewCompleteKey, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(reviewCompleteKey, value);
  }
}
