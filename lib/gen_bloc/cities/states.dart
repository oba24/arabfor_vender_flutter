import '../../models/citys_model.dart';

class CitiesState {}

class LoadingCitiesState extends CitiesState {}

class FaildCitiesState extends CitiesState {
  String msg;
  int errType;
  FaildCitiesState({required this.errType, required this.msg});
}

class DoneCitiesState extends CitiesState {
  String msg;
  List<CitiesDatum> cities;
  DoneCitiesState(this.msg, this.cities);
}
