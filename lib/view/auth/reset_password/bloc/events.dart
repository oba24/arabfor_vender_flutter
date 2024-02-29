import 'package:flutter/material.dart';

class ResetPasswordEvent {}

class StartResetPasswordEvent extends ResetPasswordEvent {
  late TextEditingController newPassword, confairmNewPawword;
  String phone, code;

  Map<String, dynamic> get body => {"phone": phone, "code": code, "password": newPassword.text};

  StartResetPasswordEvent(this.phone, this.code) {
    newPassword = TextEditingController();
    confairmNewPawword = TextEditingController();
  }
}
