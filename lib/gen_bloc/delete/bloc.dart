import '../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteBloc extends Bloc<DeleteEvent, DeleteState> {
  DeleteBloc() : super(DeleteState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<DeleteState> mapEventToState(DeleteEvent event) async* {
    if (event is StartDeleteEvent) {
      yield LoadingDeleteState();
      CustomResponse response = await repo(event);
      if (response.success) {
        yield DoneDeleteState(response.msg);
      } else {
        yield FaildDeleteState(msg: response.msg, errType: response.errType!);
      }
    }
  }

  Future<CustomResponse> repo(StartDeleteEvent event) async {
    CustomResponse response = await serverGate.sendToServer(url: event.url, body: event.body);
    return response;
  }
}
