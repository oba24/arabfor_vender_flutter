import '../../../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  ForgetPasswordBloc() : super(ForgetPasswordState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<ForgetPasswordState> mapEventToState(ForgetPasswordEvent event) async* {
    if (event is StartForgetPasswordEvent) {
      yield LoadingForgetPasswordState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await repo(event.body);
      if (response.success) {
        // ForgetPasswordModel _model = ForgetPasswordModel.fromJson(response.response.data);
        // await CustomProgressDialog.hidePr();
        yield DoneForgetPasswordState(response.msg);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildForgetPasswordState(msg: response.msg, errType: response.errType!);
      }
    }
  }

  Future<CustomResponse> repo(Map<String, dynamic> body) async {
    CustomResponse response = await serverGate.sendToServer(url: "forgot_password", body: body);
    return response;
  }
}
