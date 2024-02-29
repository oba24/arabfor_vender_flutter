import 'model.dart';

class SettingState {}

class LoadingSettingState extends SettingState {}

class FaildSettingState extends SettingState {
  String msg;
  int errType;
  FaildSettingState({required this.errType, required this.msg});
}

class DoneCommonQuestionsState extends SettingState {
  List<QuestionDatum> data;
  String msg;
  DoneCommonQuestionsState(this.msg, this.data);
}

class DonePagesState extends SettingState {
  String data;
  DonePagesState(this.data);
}

class DoneContactState extends SettingState {
  String msg;
  DoneContactState(this.msg);
}

class DoneSupportState extends SettingState {
  SupportDatum support;
  DoneSupportState(this.support);
}
