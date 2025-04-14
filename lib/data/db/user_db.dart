import 'package:hive/hive.dart';
import 'package:pos_app/data/models/user_models.dart';

class UserDb {
  // Box name constant
  static const String userBoxName = "zaad_pos_user";
  static const String authToken = 'authToken';

  static late Box _userBox;

  // Initialize Hive box
  static Future<void> initUserDb() async {
    _userBox = await Hive.openBox(userBoxName);
  }

  // Store Auth Token
  static Future<void> setAuthToken(String token) async {
    await _userBox.put(authToken, token);
  }

  // Retrieve Auth Token
  static String getAuthToken() {
    return _userBox.get(authToken, defaultValue: "");
  }

  // Store User
  static Future<void> storeUserToLocal(UserModel user) async {
    await _userBox.put('user', user.toMap());
  }

  // Retrieve User
  static UserModel? getUserFromLocal() {
    final userData = _userBox.get('user');
    if (userData != null && userData is Map) {
      return UserModel.fromMap(Map<String, dynamic>.from(userData));
    }
    return null;
  }

  static Future<void> clearUserDb() async => await _userBox.clear();
}
