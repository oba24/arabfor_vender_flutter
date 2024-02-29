import '../../../repo/server_gate.dart';
import 'events.dart';
import 'model.dart';
import 'states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationState());
  ServerGate serverGate = ServerGate();
  late NotificationsData _data;

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is StartGetNotificationEvent) {
      yield LoadingNotificationState();
      CustomResponse<NotificationModel> response = await repo("notifications");
      if (response.success) {
        _data = response.data!.data;
        yield DoneNotificationState(response.msg, _data, false, response.data!.links.next);
      } else {
        // await CustomProgressDialog.hidePr();
        yield FaildNotificationState(msg: response.msg, errType: response.errType!);
      }
    }
    if (event is StartPaginationEvent) {
      yield DoneNotificationState("", _data, true, null);
      CustomResponse<NotificationModel> response = await repo(event.nextUrl);
      if (response.success) {
        _data.notifications.addAll(response.data!.data.notifications);
        _data.unreadnotificationsCount = response.data!.data.unreadnotificationsCount;
        // await CustomProgressDialog.hidePr();
        yield DoneNotificationState("", _data, false, response.data!.links.next);
      } else {
        yield DoneNotificationState(response.msg, _data, false, null);
      }
    }
  }

  Future repo(String url) async {
    CustomResponse<NotificationModel> response = await serverGate.getFromServer(url: url, callback: (c) => NotificationModel.fromJson(c));
    return response;
  }
}
