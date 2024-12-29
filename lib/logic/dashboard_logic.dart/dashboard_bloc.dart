import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  DashBoardBloc() : super(DashBoardInitialState()) {
    on<DashbBoardChangeIndexDrawer>((event, emit) {
      print(event.index);
      emit(DashBoardSuccessState(index: event.index));
    });
    on<SyncProductsEvent>((event, emit) async {
      emit(SyncProductsLoadingState(isAnimating: true));
      await Future.delayed(Duration(seconds: 10), () {
        emit(SyncProductsSuccessState(isAnimating: false));
      });
    });
  }
}
