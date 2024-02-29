class OrderEvent {}

class StartOrderEvent extends OrderEvent {
  String type;
  String? search;

  String get url =>
      {
        "search": "provider/search_orders?id=$search",
        "home": "provider/home",
        "order_current": "provider/provider_order?status=current",
        "order_finished": "provider/provider_order?status=finished"
      }[type] ??
      "";

  StartOrderEvent(this.type, {this.search});
}

class StartSingleOrderEvent extends OrderEvent {
  int id;

  StartSingleOrderEvent(this.id);
}

class StartChangStatusOrderEvent extends OrderEvent {
  String type; //accept_order - finished_order - reject_order
  int id;
  String get url => "provider/$type/$id";
  StartChangStatusOrderEvent(this.type, this.id);
}
