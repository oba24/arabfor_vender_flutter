import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../helper/user_data.dart';
import '../../../../models/user_model.dart';
import '../../../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is StartLoginEvent) {
      yield LoadingLoginState();
      CustomResponse response = await repo(await event.toJson());
      if (response.success) {
        UserHelper.setUserData(UserModel.fromJson(response.response?.data["data"]));
        yield DoneLoginState(response.msg);
      } else {
        yield FaildLoginState(
          msg: response.msg,
          errType: response.errType ?? 0,
          isActive: response.response?.data["is_active"] ?? true,
        );
      }
    }
  }

  Future<CustomResponse> repo(Map<String, dynamic> json) async {
    CustomResponse response = await serverGate.sendToServer(url: "login", body: json);
    return response;
  }
}
