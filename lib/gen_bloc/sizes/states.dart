import '../../models/sizes_model.dart';

class SizesState {}

class LoadingSizesState extends SizesState {}

class FaildSizesState extends SizesState {
  String msg;
  int errType;
  FaildSizesState({required this.errType, required this.msg});
}

class DoneSizesState extends SizesState {
  List<SizesDatum> data;
  String msg;
  DoneSizesState(this.msg, this.data);
}
