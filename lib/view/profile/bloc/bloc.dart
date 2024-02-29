import 'package:saudimerchantsiller/helper/user_data.dart';
import 'package:saudimerchantsiller/models/user_model.dart';
import '../../../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  UpdateProfileBloc() : super(UpdateProfileState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<UpdateProfileState> mapEventToState(UpdateProfileEvent event) async* {
    if (event is StartUpdateProfileEvent) {
      yield LoadingUpdateProfileState();
      CustomResponse response = await updateProfileRepo(event.body);
      if (response.success) {
        UserModel _model = UserModel.fromJson(response.response?.data["data"]);
        _model.token = UserHelper.userDatum.token;
        UserHelper.setUserData(_model);
        yield DoneUpdateProfileState(response.msg);
      } else {
        yield FaildUpdateProfileState(msg: response.msg, errType: response.errType ?? 0);
      }
    }
    if (event is StartEditPasswordEvent) {
      yield LoadingUpdateProfileState();
      CustomResponse response = await updatePasswordRepo(event.body);
      if (response.success) {
        yield DoneEditPasswordState(response.msg);
      } else {
        yield FaildUpdateProfileState(msg: response.msg, errType: response.errType ?? 0);
      }
    }
  }

  Future<CustomResponse> updateProfileRepo(Map<String, dynamic> body) async {
    CustomResponse response = await serverGate.sendToServer(url: "provider/profile", body: body);
    return response;
  }

  Future<CustomResponse> updatePasswordRepo(Map<String, dynamic> body) async {
    CustomResponse response = await serverGate.sendToServer(url: "edit_password", body: body);
    return response;
  }
}
