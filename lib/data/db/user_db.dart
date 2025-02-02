import 'package:hive/hive.dart';
import 'package:pos_app/data/models/user_models.dart';

class UserDb {
  // BOX NAME
  static String userBoxName = "zaad_pos_user";
  static late Box userBox;
  // INIT BOX
  static initUserDb() async => userBox = await Hive.openBox(userBoxName);

  // STORE USER
  static Future<void> storeUserToLocal(UserModel user) async {
    await userBox.clear();
    userBox.put(user.id, user.toMap());
  }

  // GET USER
  static UserModel? getUserFromLocal() {
    if (userBox.isNotEmpty) {
      final userData = userBox.getAt(0);
      final Map<String, dynamic> userMap = Map<String, dynamic>.from(userData as Map);
      return UserModel.fromMap(userMap);
    } else {
      return null;
    }
  }
}
