import 'package:saudimerchantsiller/view/product/bloc/model.dart';
import '../../../models/product_model.dart';
import '../../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductState());
  ServerGate serverGate = ServerGate();
  late List<ProductDatum> _data;

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is StartProductsEvent) {
      yield LoadingProductState();
      CustomResponse<ProductModel> response = await repo("provider/products", false);
      if (response.success) {
        _data = response.data!.data;
        yield DoneProductsState(msg: "", paginationLoading: false, data: _data, url: response.data!.links.next);
      } else {
        yield FaildProductState(msg: response.msg, errType: response.errType!);
      }
    }
    if (event is StartPaginationEvent) {
      yield DoneProductsState(msg: "", paginationLoading: true, data: _data, url: null);
      CustomResponse<ProductModel> response = await repo(event.nextUrl, false);
      if (response.success) {
        _data.addAll(response.data!.data);
        yield DoneProductsState(msg: "", paginationLoading: false, data: _data, url: response.data!.links.next);
      } else {
        yield DoneProductsState(msg: response.msg, paginationLoading: false, data: _data, url: null);
      }
    }
    if (event is StartSingleProductsEvent) {
      yield LoadingProductState();
      CustomResponse<ProductModel> response = await repo("provider/products/${event.id}", true);
      if (response.success) {
        yield DoneSingleProductsState(response.msg, response.data!.single);
      } else {
        yield FaildProductState(msg: response.msg, errType: response.errType!);
      }
    }
  }

  Future repo(String url, bool isSingle) async {
    CustomResponse<ProductModel> response = await serverGate.getFromServer(
      url: url,
      callback: (x) => ProductModel.fromJson(x, isSingle),
    );
    return response;
  }
}
