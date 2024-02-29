import '../../repo/server_gate.dart';
import 'events.dart';
import 'model.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorsBloc extends Bloc<ColorsEvent, ColorsState> {
  ColorsBloc() : super(ColorsState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<ColorsState> mapEventToState(ColorsEvent event) async* {
    if (event is StartColorsEvent) {
      yield LoadingColorsState();
      CustomResponse<ColorsModel> response = await repo();
      if (response.success) {
        // ColorsModel _model = ColorsModel.fromJson(response.response?.data);
        yield DoneColorsState(response.msg, response.data!.data);
      } else {
        yield FaildColorsState(msg: response.msg, errType: response.errType ?? 1);
      }
    }
  }

  Future repo() async {
    CustomResponse<ColorsModel> response = await serverGate.getFromServer(
      url: "colors",
      callback: (x) => ColorsModel.fromJson(x),
    );
    return response;
  }
}
