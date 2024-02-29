import 'package:saudimerchantsiller/gen_bloc/order/model.dart';

import '../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if (event is StartOrderEvent) {
      yield LoadingOrderState();
      CustomResponse<OrderModel> response = await allRepo(event.url);
      if (response.success) {
        yield DoneOrderState(response.msg, response.data!.data, event.type);
      } else {
        yield FaildOrderState(msg: response.msg, errType: response.errType!);
      }
    }
    if (event is StartSingleOrderEvent) {
      yield LoadingOrderState();
      CustomResponse response = await singleRepo(event.id);
      if (response.success) {
        OrderModel _model = OrderModel.fromJson(response.response?.data, single: true);
        yield DoneSingleOrderState(response.msg, _model.single);
      } else {
        yield FaildOrderState(msg: response.msg, errType: response.errType!);
      }
    }
    if (event is StartChangStatusOrderEvent) {
      yield LoadingOrderState();
      CustomResponse response = await changeStatusRepo(event.url);
      if (response.success) {
        OrderModel _model = OrderModel.fromJson(response.response?.data, single: true);
        yield DoneChangStatusOrderState(response.msg, _model.single);
      } else {
        yield FaildOrderState(msg: response.msg, errType: response.errType!);
      }
    }
  }

  Future<CustomResponse<OrderModel>> allRepo(String url) async {
    CustomResponse<OrderModel> response = await serverGate.getFromServer(
      url: url,
      callback: (x) => OrderModel.fromJson(x),
    );
    return response;
  }

  Future<CustomResponse> singleRepo(int id) async {
    CustomResponse response = await serverGate.getFromServer(url: "provider/provider_order/$id");
    return response;
  }

  Future<CustomResponse> changeStatusRepo(String url) async {
    CustomResponse response = await serverGate.sendToServer(url: url);
    return response;
  }
}
