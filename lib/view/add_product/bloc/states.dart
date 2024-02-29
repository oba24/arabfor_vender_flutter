class AddProductState {}

class LoadingAddProductState extends AddProductState {}

class FaildAddProductState extends AddProductState {
  String msg;
  int errType;
  FaildAddProductState({required this.errType, required this.msg});
}

class DoneAddProductState extends AddProductState {
  String msg;
  DoneAddProductState(this.msg);
}
