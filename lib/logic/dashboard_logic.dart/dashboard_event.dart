part of "dashboard_bloc.dart";

abstract class DashBoardEvent {}

class DashbBoardChangeIndexDrawer extends DashBoardEvent {
  int index;
  DashbBoardChangeIndexDrawer({
    required this.index,
  });
}

class SyncProductsEvent extends DashBoardEvent {}
