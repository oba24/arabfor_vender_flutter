import 'dart:io';

import '../../repo/firebase_notifications.dart';

class ProfileEvent {}

class StartProfileEvent extends ProfileEvent {
  Map<String, dynamic> toJson() => {};

  StartProfileEvent();
}

class StartLogoutEvent extends ProfileEvent {
  final String url;

  StartLogoutEvent(this.url);
  Future<Map<String, dynamic>> get body async => {
        "device_token": await GlobalNotification.getFcmToken(),
        "type": Platform.isAndroid ? "android" : "ios",
      };
}
