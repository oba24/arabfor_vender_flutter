import '../../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  AddProductBloc() : super(AddProductState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<AddProductState> mapEventToState(AddProductEvent event) async* {
    if (event is StartAddProductEvent) {
      yield LoadingAddProductState();
      CustomResponse response = await addRepo(event);
      if (response.success) {
        yield DoneAddProductState(response.msg);
      } else {
        yield FaildAddProductState(msg: response.msg, errType: response.errType!);
      }
    }
  }

  Future<CustomResponse> addRepo(StartAddProductEvent event) async {
    CustomResponse response = await serverGate.sendToServer(
      url: event.productId == null ? "provider/products" : "provider/products/${event.productId}",
      body: event.body,
    );
    return response;
  }
}
