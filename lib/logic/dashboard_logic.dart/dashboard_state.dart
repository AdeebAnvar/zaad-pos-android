// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "dashboard_bloc.dart";

abstract class DashBoardState {}

class DashBoardInitialState extends DashBoardState {}

class DashBoardLoadingState extends DashBoardState {}

class DashbBoardChangeIndexSuccessDrawer extends DashBoardState {
  int index;
  DashbBoardChangeIndexSuccessDrawer({
    required this.index,
  });
}
