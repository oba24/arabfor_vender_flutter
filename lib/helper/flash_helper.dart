import 'dart:async';
import 'dart:collection';
import 'package:easy_localization/easy_localization.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'extintions.dart';
import 'rout.dart';

import '../generated/locale_keys.g.dart';

class _MessageItem<T> {
  final String message;
  final String? type;
  Completer<Future<T>> completer;

  _MessageItem(this.message, {this.type}) : completer = Completer<Future<T>>();
}

class FlashHelper {
  static Completer<BuildContext> _buildCompleter = Completer<BuildContext>();
  static final Queue<_MessageItem> _messageQueue = Queue<_MessageItem>();
  static late Completer _previousCompleter;
  static bool isInit = false;
  static void init() {
    if (_buildCompleter.isCompleted == false) {
      _buildCompleter.complete(navigator.currentContext);
    }
  }

  static void dispose() {
    _messageQueue.clear();

    if (_buildCompleter.isCompleted == false) {
      _buildCompleter.completeError('NotInitalize');
    }
    _buildCompleter = Completer<BuildContext>();
  }

  static Future<Future<T?>> toast<T>({required String message, required String type}) async {
    _previousCompleter = Completer();
    Map<String, dynamic> _bodyType = {
      "background_color_err": const Color(0xffF8D6D6),
      "background_color_succ": const Color(0xffE1F5E0),
      "background_color_info": const Color(0xffF7E2D4),
      "icon_data_err": Icons.error_outline,
      "icon_data_succ": Icons.check_circle_outline_outlined,
      "icon_data_info": Icons.warning_rounded,
      "content_color_err": const Color(0xffE30202),
      "content_color_succ": const Color(0xff089003),
      "content_color_info": const Color(0xffECA77B),
    };
    Future<T?> showToast(String message, String type) {
      return showFlash<T>(
        context: navigator.currentContext!,
        builder: (context, controller) {
          return Flash.dialog(
            barrierDismissible: false,
            controller: controller,
            alignment: const Alignment(0, -1),
            margin: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            backgroundColor: _bodyType["background_color_$type"],
            // horizontalDismissDirection: HorizontalDismissDirection.horizontal,
            child: DefaultTextStyle(
              style: context.textTheme.headline1!.copyWith(fontSize: 16.0, color: _bodyType["content_color_$type"]),
              child: Container(
                  padding: EdgeInsets.all(16.w),
                  constraints: BoxConstraints(minHeight: 80.h, minWidth: MediaQuery.of(context).size.width - 32.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _bodyType["icon_data_$type"],
                        color: _bodyType["content_color_$type"],
                        size: 40.h,
                      ),
                      SizedBox(width: 20.w),
                      SizedBox(width: MediaQuery.of(context).size.width - (52.w + 50.h + 48.w), child: Text(message)),
                    ],
                  )),
            ),
          );
        },
        duration: const Duration(milliseconds: 1500),
      ).whenComplete(() {
        if (_messageQueue.isNotEmpty) {
          var item = _messageQueue.removeFirst();
          item.completer.complete(showToast(item.message, item.type ?? ""));
        } else {
          _previousCompleter.complete();
        }
      });
    }

    return showToast(message, type);
  }

  static Future<Future> infoBar<T>({
    String? title,
    @required String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    return toast(message: message ?? "", type: "info");
  }

  static Future<Future> successBar<T>({
    String? title,
    @required String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (message == null || message == "") {
      message = LocaleKeys.successfully_done.tr();
    }
    return toast(message: message, type: "succ");
  }

  static Future<Future> errorBar<T>({
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    return toast(message: message, type: "err");
  }
}
