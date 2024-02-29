import 'package:flutter/material.dart';

class ForgetPasswordEvent {}

class StartForgetPasswordEvent extends ForgetPasswordEvent {
  Map<String, dynamic> get body => {"phone": mobile.text};

  late TextEditingController mobile;
  StartForgetPasswordEvent() {
    mobile = TextEditingController();
  }
}
