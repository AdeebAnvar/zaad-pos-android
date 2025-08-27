part of 'branch_bloc.dart';

abstract class BranchState {}

class BranchInitialState extends BranchState {}

class CreatingBranchState extends BranchState {}

class CreatedBranchState extends BranchState {}
