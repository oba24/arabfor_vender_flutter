class ForgetPasswordState {}

class LoadingForgetPasswordState extends ForgetPasswordState {}

class FaildForgetPasswordState extends ForgetPasswordState {
  String msg;
  int errType;
  FaildForgetPasswordState({required this.errType, required this.msg});
}

class DoneForgetPasswordState extends ForgetPasswordState {
  String msg;
  DoneForgetPasswordState(this.msg);
}
