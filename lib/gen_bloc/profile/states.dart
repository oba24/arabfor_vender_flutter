import '../../models/user_model.dart';

class ProfileState {}

class LoadingProfileState extends ProfileState {}

class FaildProfileState extends ProfileState {
  String msg;
  int errType;
  FaildProfileState({required this.errType, required this.msg});
}

class DoneProfileState extends ProfileState {
  String msg;
  UserModel data;
  DoneProfileState(this.msg, this.data);
}

class DoneLogoutState extends ProfileState {
  String msg;
  DoneLogoutState(this.msg);
}
