import '../../repo/server_gate.dart';
import 'events.dart';
import 'model.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SizesBloc extends Bloc<SizesEvent, SizesState> {
  SizesBloc() : super(SizesState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<SizesState> mapEventToState(SizesEvent event) async* {
    if (event is StartSizesEvent) {
      yield LoadingSizesState();
      // await CustomProgressDialog.showProgressDialog();
      CustomResponse<SizesModel> response = await repo();
      if (response.success) {
        // SizesModel _model = SizesModel.fromJson(response.response?.data);
        // await CustomProgressDialog.hidePr();
        yield DoneSizesState(response.msg, response.data!.data);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildSizesState(msg: response.msg, errType: response.errType!);
      }
    }
  }

  Future repo() async {
    CustomResponse<SizesModel> response = await serverGate.getFromServer(
      url: "sizes",
      callback: (x) => SizesModel.fromJson(x),
    );
    return response;
  }
}
