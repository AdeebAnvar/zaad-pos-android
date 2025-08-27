part of 'branch_bloc.dart';

abstract class BranchEvent {}

class CreateBranchEvent extends BranchEvent {
  final BranchModel branchModel;

  CreateBranchEvent({required this.branchModel});
}
