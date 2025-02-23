import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/data/db/user_db.dart';
import 'package:pos_app/data/local/providers/auth_providers.dart';
import 'package:pos_app/data/models/user_models.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
//
    on<CheckUserOnServer>((event, emit) async {
      emit(FetchingUserFromServerState());
      (bool, String) result = await AuthProviders.login(password: event.password, userName: event.userName);
      emit(FetchedUserFromServerState(status: result.$1, message: result.$2));
    });

    //
    on<CheckUserLocal>((event, emit) async {
      emit(CheckingUserOnLocalState());
      UserModel? userModel = UserDb.getUserFromLocal();
      if (userModel != null && event.userName == userModel.name && event.password == userModel.password) {
        emit(CheckedUserOnLocalState(userModel: userModel));
      } else {
        emit(CheckedUserOnLocalState(userModel: null));
      }
    });
//
  }
}
