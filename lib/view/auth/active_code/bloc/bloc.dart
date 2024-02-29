import 'package:saudimerchantsiller/models/user_model.dart';

import '../../../../helper/user_data.dart';
import '../../../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveCodeBloc extends Bloc<ActiveCodeEvent, ActiveCodeState> {
  ActiveCodeBloc() : super(ActiveCodeState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<ActiveCodeState> mapEventToState(ActiveCodeEvent event) async* {
    if (event is StartActiveCodeEvent) {
      yield LoadingActiveCodeState();
      CustomResponse response = await repo(await event.toJson(), event.type);
      if (response.success) {
        if (event.type == TYPE.register) {
          UserHelper.setUserData(UserModel.fromJson(response.response?.data["data"]));
        }
        yield DoneActiveCodeState(response.msg);
      } else {
        yield FaildActiveCodeState(
          msg: response.msg,
          errType: response.errType ?? 0,
        );
      }
    }
  }

  Future<CustomResponse> repo(Map<String, dynamic> body, TYPE type) async {
    CustomResponse response = await serverGate.sendToServer(url: type == TYPE.register ? "verify" : "check_code", body: body);
    return response;
  }
}
