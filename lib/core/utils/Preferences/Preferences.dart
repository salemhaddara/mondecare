// ignore: file_names
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
//----------------------------------------------------------------------------------------------
//User Id Saving
  static Future<bool> saveUserId(String userid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('userid', userid);
  }

  static Future<String> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userid') ?? '';
  }

  // ignore: non_constant_identifier_names
  static Future<bool> UsedIdExist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userid');
  }

//----------------------------------------------------------------------------------------------
//Nmae From the Last Login
  static Future<bool> saveUserName(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('username', name);
  }

  static Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<bool> userNameexist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('username');
  }

  //----------------------------------------------------------------------------------------------
//Email From the Last Login
  static Future<bool> saveEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('email', email);
  }

  static Future<String?> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  static Future<bool> emailexist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('email');
  }

//   //----------------------------------------------------------------------------------------------
// //Delete Saved Data
  static Future<bool> deleteSavedData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
