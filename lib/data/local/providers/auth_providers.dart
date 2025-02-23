import '../../api/service.dart';
import '../../api/urls.dart';
import '../../db/user_db.dart';
import '../../models/response_model.dart';
import '../../models/user_models.dart';

class AuthProviders {
  static Future<(bool isSuccess, String message)> login({required String userName, required String password}) async {
    try {
      ResponseModel response = await ApiService.postApiData(Urls.login, {"username": userName, "password": password});

      if (response.isSuccess) {
        await UserDb.setAuthToken(response.responseObject['token']);
        UserModel userModel = UserModel.fromMap(response.responseObject['user']);
        UserDb.storeUserToLocal(userModel);
        return (true, response.responseObject['message'].toString());
      } else {
        return (false, response.responseObject['message'].toString());
      }
    } catch (e) {
      print(e);
      return (false, e.toString());
    }
  }
}
