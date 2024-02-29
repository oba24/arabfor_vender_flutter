class CategoryEvent {}

class StartCategoryEvent extends CategoryEvent {
  Map<String, dynamic> get body => {};

  StartCategoryEvent();
}

class StartSubCategoryEvent extends CategoryEvent {
  int id;
  StartSubCategoryEvent(this.id);
}
