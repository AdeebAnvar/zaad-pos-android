// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "auth_bloc.dart";

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class FetchingUserFromServerState extends AuthState {}

class FetchedUserFromServerState extends AuthState {
  bool haveUser;
  FetchedUserFromServerState({
    required this.haveUser,
  });
}

class CheckingUserOnLocalState extends AuthState {}

class CheckedUserOnLocalState extends AuthState {
  UserModel? userModel;
  CheckedUserOnLocalState({
    required this.userModel,
  });
}
