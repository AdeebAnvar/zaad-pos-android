// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "dashboard_bloc.dart";

abstract class DashBoardEvent {}

class DashbBoardChangeIndexDrawer extends DashBoardEvent {
  int index;
  DashbBoardChangeIndexDrawer({
    required this.index,
  });
}

class SyncDataEvent extends DashBoardEvent {
  CurrentScreen screen;
  SyncDataEvent({
    required this.screen,
  });
}
