import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/data/models/branch_model.dart';

part 'branch_event.dart';
part 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  BranchBloc() : super(BranchInitialState()) {
    on<CreateBranchEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
