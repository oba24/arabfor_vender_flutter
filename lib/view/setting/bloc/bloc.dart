import '../../../repo/server_gate.dart';
import 'events.dart';
import 'model.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<SettingState> mapEventToState(SettingEvent event) async* {
    if (event is StartCommonQuestionsEvent) {
      yield LoadingSettingState();
      CustomResponse response = await repo("common-questions");
      if (response.success) {
        SettingModel _model = SettingModel.questionFromjson(response.response?.data);
        yield DoneCommonQuestionsState(response.msg, _model.question);
      } else {
        yield FaildSettingState(msg: response.msg, errType: response.errType!);
      }
    }
    if (event is StartPagesEvent) {
      yield LoadingSettingState();
      CustomResponse response = await repo(event.type);
      if (response.success) {
        String data = response.response?.data["data"][event.type] ?? "";
        yield DonePagesState(data);
      } else {
        yield FaildSettingState(msg: response.msg, errType: response.errType!);
      }
    }
    if (event is StartContactEvent) {
      yield LoadingSettingState();
      CustomResponse response = await _contactRepo(event.body);
      if (response.success) {
        yield DoneContactState(response.msg);
      } else {
        yield FaildSettingState(msg: response.msg, errType: response.errType!);
      }
    }
    if (event is StartSupportEvent) {
      yield LoadingSettingState();
      CustomResponse response = await _supportRepo();
      if (response.success) {
        SettingModel _model = SettingModel.supportFromJson(response.response?.data);
        yield DoneSupportState(_model.support);
      } else {
        yield FaildSettingState(msg: response.msg, errType: response.errType!);
      }
    }
  }

  Future<CustomResponse> repo(String url) async {
    CustomResponse response = await serverGate.getFromServer(url: url);
    return response;
  }

  Future<CustomResponse> _contactRepo(Map<String, dynamic> body) async {
    CustomResponse response = await serverGate.sendToServer(url: "contact", body: body);
    return response;
  }

  Future<CustomResponse> _supportRepo() async {
    CustomResponse response = await serverGate.getFromServer(url: "contact");
    return response;
  }
}
