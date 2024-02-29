class NotificationModel {
  NotificationModel({
    required this.data,
    required this.links,
    required this.message,
  });

  NotificationsData data;
  _Links links;
  String message;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        data: NotificationsData.fromJson(json["data"] ?? {}),
        links: _Links.fromJson(json["links"]),
        message: json["message"] ?? "",
      );
}

class NotificationsData {
  NotificationsData({
    required this.unreadnotificationsCount,
    required this.notifications,
  });

  int unreadnotificationsCount;
  List<NotificationDatum> notifications;

  factory NotificationsData.fromJson(Map<String, dynamic> json) => NotificationsData(
        unreadnotificationsCount: json["unreadnotifications_count"] ?? 0,
        notifications: List<NotificationDatum>.from((json["notifications"] ?? []).map((x) => NotificationDatum.fromJson(x))),
      );
}

class _Links {
  _Links({
    this.next,
  });

  String? next;

  factory _Links.fromJson(Map<String, dynamic> json) => _Links(
        next: json["next"],
      );
}

class NotificationDatum {
  NotificationDatum({
    required this.id,
    required this.title,
    required this.body,
    required this.notifyType,
    required this.orderId,
    required this.sender,
    required this.createdAt,
    required this.readAt,
  });

  String id;
  String title;
  String body;
  String notifyType;
  int orderId;
  _User sender;
  String createdAt;
  String? readAt;

  factory NotificationDatum.fromJson(Map<String, dynamic> json) => NotificationDatum(
        id: json["id"] ?? 0,
        title: json["title"] ?? "",
        body: json["body"] ?? "",
        notifyType: json["notify_type"] ?? "",
        orderId: json["order_id"] ?? 0,
        sender: _User.fromJson(json["sender"] ?? {}),
        createdAt: json["created_at"] ?? "",
        readAt: json["read_at"],
      );
}

class _User {
  _User({
    required this.id,
    required this.name,
    required this.phone,
    required this.image,
  });

  int id;
  String name;
  String phone;
  String image;

  factory _User.fromJson(Map<String, dynamic> json) => _User(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        phone: json["phone"] ?? "",
        image: json["image"] ?? "",
      );
}
