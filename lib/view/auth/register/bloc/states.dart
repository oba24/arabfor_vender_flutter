class RegisterState {}

class LoadingRegisterState extends RegisterState {}

class FaildRegisterState extends RegisterState {
  String msg;
  int errType;
  FaildRegisterState({required this.errType, required this.msg});
}

class DoneRegisterState extends RegisterState {
  String msg;
  DoneRegisterState(this.msg);
}
