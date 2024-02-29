import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:saudimerchantsiller/repo/firebase_notifications.dart';

import '../../generated/locale_keys.g.dart';
import '../../helper/user_data.dart';
import '../../models/user_model.dart';
import '../../repo/server_gate.dart';
import 'events.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState());
  ServerGate serverGate = ServerGate();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is StartProfileEvent) {
      yield LoadingProfileState();
      CustomResponse response = await repo();
      if (response.success) {
        var _model = UserModel.fromJson(response.response?.data["data"] ?? {});
        UserHelper.setUserData(_model);
        yield DoneProfileState(response.msg, _model);
      } else {
        yield FaildProfileState(
          msg: response.msg,
          errType: response.errType ?? 0,
        );
      }
    }
    if (event is StartLogoutEvent) {
      yield LoadingProfileState();
      CustomResponse response = await logoutRepo(await event.body, event.url);
      if (response.success) {
        UserHelper.logout();
        yield DoneLogoutState(response.msg);
      } else {
        if (response.statusCode == 401) {
          UserHelper.logout();
          yield DoneLogoutState(LocaleKeys.the_exit_was_successfully_released.tr());
        } else {
          yield FaildProfileState(msg: response.msg, errType: response.errType ?? 0);
        }
      }
    }
  }

  Future<CustomResponse> repo() async {
    CustomResponse response = await serverGate.getFromServer(url: "provider/profile");
    return response;
  }

  Future<CustomResponse> logoutRepo(Map<String, dynamic> body, String url) async {
    CustomResponse response = await serverGate.sendToServer(
      url: url,
      body: {"device_token": await GlobalNotification.getFcmToken(), "type": Platform.isIOS ? "ios" : "android"},
    );
    return response;
  }
}
