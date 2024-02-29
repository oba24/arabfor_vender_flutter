class DeleteState {}

class LoadingDeleteState extends DeleteState {}

class FaildDeleteState extends DeleteState {
  String msg;
  int errType;
  FaildDeleteState({required this.errType, required this.msg});
}

class DoneDeleteState extends DeleteState {
  String msg;
  DoneDeleteState(this.msg);
}
