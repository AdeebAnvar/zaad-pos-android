// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "auth_bloc.dart";

abstract class AuthEvent {}

class CheckUserOnServer extends AuthEvent {
  String userName;
  String password;
  BuildContext context;
  CheckUserOnServer({
    required this.userName,
    required this.password,
    required this.context,
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
