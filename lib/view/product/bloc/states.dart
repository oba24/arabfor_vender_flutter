import '../../../models/product_model.dart';

class ProductState {}

class LoadingProductState extends ProductState {}

class FaildProductState extends ProductState {
  String msg;
  int errType;
  FaildProductState({required this.errType, required this.msg});
}

class DoneProductsState extends ProductState {
  String msg;
  List<ProductDatum> data;
  String? url;
  bool paginationLoading;
  DoneProductsState({required this.msg, required this.paginationLoading, required this.data, this.url});
}

class DoneSingleProductsState extends ProductState {
  String msg;
  ProductDatum data;
  DoneSingleProductsState(this.msg, this.data);
}
