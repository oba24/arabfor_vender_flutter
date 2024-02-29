class LoginState {}

class LoadingLoginState extends LoginState {}

class FaildLoginState extends LoginState {
  String msg;
  bool isActive;
  int errType;
  FaildLoginState({required this.errType, required this.msg, required this.isActive});
}

class DoneLoginState extends LoginState {
  String msg;
  DoneLoginState(this.msg);
}
