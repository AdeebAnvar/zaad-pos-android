import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/data/db/hive_db.dart';
import 'package:pos_app/data/db/user_db.dart';
import 'package:pos_app/data/models/user_models.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<CheckUserOnServer>((event, emit) async {
      emit(FetchingUserFromServerState());
      // call api
      await Future.delayed(Duration(seconds: 3));
      UserModel userModel = UserModel(id: 1, name: "adibz", password: "1");
      if (event.userName == userModel.name && event.password == userModel.password) {
        await UserDb.storeUserToLocal(userModel);
        emit(FetchedUserFromServerState(haveUser: true));
      } else {
        emit(FetchedUserFromServerState(haveUser: false));
      }
    });
    on<CheckUserLocal>((event, emit) async {
      emit(CheckingUserOnLocalState());
      UserModel userModel = UserDb.getUserFromLocal();
      if (event.userName == userModel.name && event.password == userModel.password) {
        emit(CheckedUserOnLocalState(userModel: userModel));
      } else {
        emit(CheckedUserOnLocalState(userModel: null));
      }
    });
  }
}
