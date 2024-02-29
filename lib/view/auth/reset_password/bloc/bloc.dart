import '../../../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc() : super(ResetPasswordState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<ResetPasswordState> mapEventToState(ResetPasswordEvent event) async* {
    if (event is StartResetPasswordEvent) {
      yield LoadingResetPasswordState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse response = await repo(event.body);
      if (response.success) {
        // ResetPasswordModel _model = ResetPasswordModel.fromJson(response.response.data);
        // await CustomProgressDialog.hidePr();
        yield DoneResetPasswordState(response.msg);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildResetPasswordState(msg: response.msg, errType: response.errType!);
      }
    }
  }

  Future<CustomResponse> repo(Map<String, dynamic> body) async {
    CustomResponse response = await serverGate.sendToServer(url: "reset_password", body: body);
    return response;
  }
}
