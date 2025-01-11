part of "auth_bloc.dart";

abstract class AuthEvent {}

class CheckUserOnServer extends AuthEvent {
  String userName;
  String password;
  CheckUserOnServer({
    required this.userName,
    required this.password,
  });
}

class CheckUserLocal extends AuthEvent {
  String userName;
  String password;
  CheckUserLocal({
    required this.userName,
    required this.password,
  });
}
