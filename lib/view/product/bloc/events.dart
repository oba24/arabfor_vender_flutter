class ProductEvent {}

class StartProductsEvent extends ProductEvent {
  Map<String, dynamic> get body => {};

  StartProductsEvent();
}

class StartPaginationEvent extends ProductEvent {
  String nextUrl;
  StartPaginationEvent(this.nextUrl);
}

class StartSingleProductsEvent extends ProductEvent {
  int id;
  Map<String, dynamic> get body => {};

  StartSingleProductsEvent(this.id);
}
