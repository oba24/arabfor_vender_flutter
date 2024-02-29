import '../../repo/server_gate.dart';
import 'events.dart';
import 'model.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is StartCategoryEvent) {
      yield LoadingCategoryState();
      CustomResponse<CategoryModel> response = await mainCategoryRepo();
      if (response.success) {
        yield DoneCategoryState(response.msg, response.data!.data);
      } else {
        yield FaildCategoryState(msg: response.msg, errType: response.errType!);
      }
    }
    if (event is StartSubCategoryEvent) {
      yield LoadingCategoryState();
      CustomResponse<CategoryModel> response = await subCategoryRepo(event.id);
      if (response.success) {
        yield DoneSubCategoryState(response.msg, response.data!.data);
      } else {
        yield FaildCategoryState(msg: response.msg, errType: response.errType!);
      }
    }
  }

  Future mainCategoryRepo() async {
    CustomResponse<CategoryModel> response = await serverGate.getFromServer(
      url: "categories",
      callback: (c) => CategoryModel.fromJson(c),
    );
    return response;
  }

  Future subCategoryRepo(int id) async {
    CustomResponse<CategoryModel> response = await serverGate.getFromServer(
      url: "subCategories/$id",
      callback: (v) => CategoryModel.fromJson(v),
    );
    return response;
  }
}
