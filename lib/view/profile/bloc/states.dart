class UpdateProfileState {}

class LoadingUpdateProfileState extends UpdateProfileState {}

class FaildUpdateProfileState extends UpdateProfileState {
  String msg;
  int errType;
  FaildUpdateProfileState({required this.errType, required this.msg});
}

class DoneUpdateProfileState extends UpdateProfileState {
  String msg;
  DoneUpdateProfileState(this.msg);
}

class DoneEditPasswordState extends UpdateProfileState {
  String msg;
  DoneEditPasswordState(this.msg);
}
