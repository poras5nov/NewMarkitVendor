import 'package:market_vendor_app/apiservice/key_string.dart';
import 'package:market_vendor_app/utils/strings/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? prefs;
  static SharedPreferences? regPrefs;

  SharedPref() {
    loadPrefs();
  }

  //set data into shared preferences like this
  static Future<void> saveBooleanInPrefs(String key, bool value) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setBool(key, value);
  }

//get value from shared preferences
  static getBooleanFromPrefs(String key) {
    return prefs!.getBool(key) ?? false;
  }

  static Future<bool> getBool(String key) async {
    prefs = await SharedPreferences.getInstance();
    return prefs!.getBool(key) ?? false;
  }

  static Future<void> saveStringInPrefs(String key, String value) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString(key, value);
  }

  static Future<void> setOrderID(String value) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString(AppConstants.order_id, value);
  }

  static getOrderId() {
    return prefs!.getString(AppConstants.order_id) ?? "";
  }

  static Future<void> setOrderType(String value) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString(AppConstants.type, value);
  }

  static getOrderType() {
    return prefs!.getString(AppConstants.type) ?? "";
  }

  static Future<void> setRequestOrderId(String value) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString(AppConstants.requestId, value);
  }

  static getRequestOrderId() {
    return prefs!.getString(AppConstants.requestId) ?? "";
  }

  static Future<void> savePlayerId(String value) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString(AppConstants.oneSignal, value);
  }

  static getPlayerID() {
    return prefs!.getString(AppConstants.oneSignal) ?? "";
  }

//get value from shared preferences
  static getStringFromPrefs(String key) {
    return prefs!.getString(key) ?? "";
  }

  static Future<void> saveIntInPrefs(String key, int value) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setInt(key, value);
  }

//get value from shared preferences
  static getIntFromPrefs(String key) {
    return prefs!.getInt(key) ?? 0;
  }

  static loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    regPrefs = await SharedPreferences.getInstance();
  }

  static remove(String key) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.remove(key);
  }

  static Future clear() async {
    prefs = await SharedPreferences.getInstance();
    prefs!.clear();
  }

  static Future<bool> getLoginStatus(String key) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(key) ?? false;
  }

  static Future<bool> setLoginStatus(String key, bool value) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.setBool(key, value);
  }

  //-----------------------------Gernal data end--------------------------
  static Future<void> saveProfileData(String v) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString(KeyConstant.profile, v);
  }

  static Future<String> getProfileData() async {
    prefs = await SharedPreferences.getInstance();

    return prefs!.getString(KeyConstant.profile) ?? "";
  }

  static Future<void> saveLoginToken(String v) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString(KeyConstant.token, v);
  }

  static Future<String> getLoginToken() async {
    prefs = await SharedPreferences.getInstance();

    return prefs!.getString(KeyConstant.token) ?? "";
  }

  static Future logout() async {
    saveLoginToken("");
    saveBooleanInPrefs(KeyConstant.LOGINSTATUS, false);
    saveProfileData("");
  }
}
