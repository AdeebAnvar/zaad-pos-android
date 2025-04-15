part of 'sync_bloc.dart';

abstract class SyncDataState {}

class SyncingDataState extends SyncDataState {}

class SyncingSaleDataState extends SyncDataState {}

class SyncingCrmDataState extends SyncDataState {}

class SyncSuccessDataState extends SyncDataState {}

class SyncFailDataState extends SyncDataState {}
