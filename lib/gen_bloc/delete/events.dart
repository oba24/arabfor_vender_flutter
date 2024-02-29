class DeleteEvent {}

class StartDeleteEvent extends DeleteEvent {
  String url;

  Map<String, dynamic> body;

  StartDeleteEvent(this.url, this.body);
}
