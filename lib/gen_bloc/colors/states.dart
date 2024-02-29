import '../../models/colors_model.dart';

class ColorsState {}

class LoadingColorsState extends ColorsState {}

class FaildColorsState extends ColorsState {
  String msg;
  int errType;
  FaildColorsState({required this.errType, required this.msg});
}

class DoneColorsState extends ColorsState {
  List<ColorsDatum> data;
  String msg;
  DoneColorsState(this.msg, this.data);
}
