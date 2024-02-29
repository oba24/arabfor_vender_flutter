
import '../../models/order_model.dart';

class OrderState {}

class LoadingOrderState extends OrderState {}

class FaildOrderState extends OrderState {
  String msg;
  int errType;
  FaildOrderState({required this.errType, required this.msg});
}

class DoneOrderState extends OrderState {
  List<OrderDatum> data;
  String type;
  String msg;
  DoneOrderState(this.msg, this.data, this.type);
}

class DoneSingleOrderState extends OrderState {
  OrderDatum data;
  String msg;
  DoneSingleOrderState(this.msg, this.data);
}

class DoneChangStatusOrderState extends OrderState {
  OrderDatum data;
  String msg;
  DoneChangStatusOrderState(this.msg, this.data);
}
