import 'package:flutter/material.dart';

class SettingEvent {}

class StartCommonQuestionsEvent extends SettingEvent {
  StartCommonQuestionsEvent();
}

class StartPagesEvent extends SettingEvent {
  String type;
  StartPagesEvent(this.type);
}

class StartSupportEvent extends SettingEvent {}

class StartContactEvent extends SettingEvent {
  late TextEditingController title, content;
  Map<String, dynamic> get body => {"title": title.text, "content": content.text};
  StartContactEvent() {
    title = TextEditingController();
    content = TextEditingController();
  }
}
