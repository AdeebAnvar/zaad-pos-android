import 'package:pos_app/data/db/user_db.dart';
import 'package:pos_app/data/models/user_models.dart';

class UserUtils {
  static UserModel? userModel = UserDb.getUserFromLocal() ?? null;
}
