import '../../models/category_model.dart';

class CategoryState {}

class LoadingCategoryState extends CategoryState {}

class FaildCategoryState extends CategoryState {
  String msg;
  int errType;
  FaildCategoryState({required this.errType, required this.msg});
}

class DoneCategoryState extends CategoryState {
  List<CategoryDatum> data;
  String msg;
  DoneCategoryState(this.msg, this.data);
}

class DoneSubCategoryState extends CategoryState {
  List<CategoryDatum> data;
  String msg;
  DoneSubCategoryState(this.msg, this.data);
}
