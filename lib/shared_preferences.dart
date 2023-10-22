import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreference? _instance;
  late SharedPreferences _sharedPreferences;
  late bool isLogin;

  factory SharedPreference() {
    if (_instance == null) {
      throw Exception("You must initialize SharedPreference before accessing it.");
    }
    return _instance!;
  }

  SharedPreference._(this._sharedPreferences);

  static Future<void> init() async {
    if (_instance == null) {
      final sharedPreferences = await SharedPreferences.getInstance();
      _instance = SharedPreference._(sharedPreferences);
    }
  }

  bool getLogin() {
    return _sharedPreferences.getBool("ISLOGIN") ?? false;
  }

  void setLogin(bool isLogin) {
    _sharedPreferences.setBool("ISLOGIN", isLogin);
  }

  void saveData(String key, String value) {
    _sharedPreferences.setString(key, value);
  }

  String getData(String key) {
    return _sharedPreferences.getString(key) ?? "";
  }

  void saveInt(String key, int value) {
    _sharedPreferences.setInt(key, value);
  }

  int getInt(String key) {
    return _sharedPreferences.getInt(key) ?? 0;
  }

  void saveBoolean(String key, bool value) {
    _sharedPreferences.setBool(key, value);
  }

  bool getBoolean(String key) {
    return _sharedPreferences.getBool(key) ?? false;
  }

  void clearData() {
    _sharedPreferences.clear();
  }

  bool isSaveActivity() {
    return _sharedPreferences.getBool("flag") ?? false;
  }

  void saveModeValues(String key, bool mode) {
    _sharedPreferences.setBool(key, mode);
  }

  bool getSaveMode(String key) {
    return _sharedPreferences.getBool(key) ?? false;
  }
}