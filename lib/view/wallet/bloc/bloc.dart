import '../../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<WalletState> mapEventToState(WalletEvent event) async* {
    if (event is StartWalletEvent) {
      yield LoadingWalletState();
      CustomResponse response = await repo();
      if (response.success) {
        double _wallet = ((response.response?.data["data"] ?? 0)["wallet"] ?? 0) + 0.0;
        yield DoneWalletState(response.msg, _wallet);
      } else {
        yield FaildWalletState(msg: response.msg, errType: response.errType!);
      }
    }
    if (event is StartRefundEvent) {
      yield LoadingWalletState();
      CustomResponse response = await refund(event);
      if (response.success) {
        yield DoneRefundState(response.msg);
      } else {
        yield FaildWalletState(msg: response.msg, errType: response.errType!);
      }
    }
  }

  Future<CustomResponse> repo() async {
    CustomResponse response = await serverGate.getFromServer(url: "wallet");
    return response;
  }

  Future<CustomResponse> refund(StartRefundEvent event) async {
    CustomResponse response = await serverGate.sendToServer(url: "wallet/refund", body: event.body);
    return response;
  }
}
