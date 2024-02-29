class ResetPasswordState {}

class LoadingResetPasswordState extends ResetPasswordState {}

class FaildResetPasswordState extends ResetPasswordState {
  String msg;
  int errType;
  FaildResetPasswordState({required this.errType, required this.msg});
}

class DoneResetPasswordState extends ResetPasswordState {
  String msg;
  DoneResetPasswordState(this.msg);
}
