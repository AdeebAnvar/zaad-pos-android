// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "dashboard_bloc.dart";

abstract class DashBoardState {}

class DashBoardInitialState extends DashBoardState {}

class DashBoardLoadingState extends DashBoardState {}

class DashBoardSuccessState extends DashBoardState {
  int index;
  DashBoardSuccessState({
    required this.index,
  });
}

class SyncProductsLoadingState extends DashBoardState {
  bool isAnimating;
  SyncProductsLoadingState({
    required this.isAnimating,
  });
}

class SyncProductsSuccessState extends DashBoardState {
  bool isAnimating;
  SyncProductsSuccessState({
    required this.isAnimating,
  });
}
