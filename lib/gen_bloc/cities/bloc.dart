import '../../models/citys_model.dart';
import '../../repo/server_gate.dart';
import 'events.dart';
import 'model.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CitiesBloc extends Bloc<CitiesEvent, CitiesState> {
  CitiesBloc() : super(CitiesState());
  ServerGate serverGate = ServerGate();
  List<CitiesDatum>? cities;

  @override
  Stream<CitiesState> mapEventToState(CitiesEvent event) async* {
    if (event is StartCitiesEvent) {
      if (cities != null) {
        yield DoneCitiesState("", cities!);
      } else {
        yield LoadingCitiesState();
        CustomResponse<CitiesModel> response = await repo();
        if (response.success) {
          cities = response.data?.data;
          yield DoneCitiesState(response.msg, cities!);
        } else {
          yield FaildCitiesState(
            msg: response.msg,
            errType: response.errType ?? 0,
          );
        }
      }
    }
  }

  Future<CustomResponse<CitiesModel>> repo() async {
    final response = await serverGate.getFromServer<CitiesModel>(
      url: "cities",
      callback: (x) => CitiesModel.fromJson(x),
    );
    return response;
  }
}
