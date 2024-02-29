class NotificationEvent {}

class StartGetNotificationEvent extends NotificationEvent {
  Map<String, dynamic> get body => {};

  StartGetNotificationEvent();
}

class StartPaginationEvent extends NotificationEvent {
  String nextUrl;
  StartPaginationEvent(this.nextUrl);
}
