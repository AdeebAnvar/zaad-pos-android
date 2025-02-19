import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/data/api/service.dart';
import 'package:pos_app/data/api/urls.dart';
import 'package:pos_app/data/db/hive_db.dart';
import 'package:pos_app/data/db/user_db.dart';
import 'package:pos_app/data/models/response_model.dart';
import 'package:pos_app/data/models/user_models.dart';
import 'package:pos_app/widgets/custom_snackbar.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<CheckUserOnServer>((event, emit) async {
      emit(FetchingUserFromServerState());
      try {
        ResponseModel response = await ApiService.postApiData(Urls.login, {"username": event.userName, "password": event.password});
        print(response.responseObject['status']);

        if (response.isSuccess) {
          print(response.responseObject['status']);
          await UserDb.setAuthToken(response.responseObject['token']);
          var p = UserDb.getAuthToken();
          print(p);
          UserModel userModel = UserModel.fromMap(response.responseObject['user']);
          UserDb.storeUserToLocal(userModel);
          emit(FetchedUserFromServerState(status: response.responseObject['status'], message: response.responseObject['message']));
        } else {
          emit(FetchedUserFromServerState(status: false, message: response.errorMessage ?? ""));
        }
      } catch (e) {
        print(e);
        emit(FetchedUserFromServerState(status: false, message: e.toString()));
      }
    });
    on<CheckUserLocal>((event, emit) async {
      emit(CheckingUserOnLocalState());
      UserModel? userModel = UserDb.getUserFromLocal();
      if (userModel != null && event.userName == userModel.name && event.password == userModel.password) {
        emit(CheckedUserOnLocalState(userModel: userModel));
      } else {
        emit(CheckedUserOnLocalState(userModel: null));
      }
    });
  }
}
