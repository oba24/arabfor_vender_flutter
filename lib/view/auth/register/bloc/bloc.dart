import '../../../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is StartRegisterEvent) {
      yield LoadingRegisterState();
      CustomResponse response = await repo(event.body);
      if (response.success) {
        yield DoneRegisterState(response.msg);
      } else {
        yield FaildRegisterState(
          msg: response.msg,
          errType: response.errType!,
        );
      }
    }
  }

  Future<CustomResponse> repo(Map<String, dynamic> body) async {
    CustomResponse response = await serverGate.sendToServer(url: "provider-register", body: body);
    return response;
  }
}
