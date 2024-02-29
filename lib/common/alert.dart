import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'btn.dart';
import '../gen/assets.gen.dart';
import '../helper/asset_image.dart';
import '../helper/extintions.dart';

import '../generated/locale_keys.g.dart';
import '../helper/rout.dart';

class CustomAlert {
  static Future succAlert(String title, Widget btnWidget) async {
    // bool _finish = false;
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.h))),
      isScrollControlled: false,
      isDismissible: false,
      context: navigator.currentContext!,
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(70))),
                // padding: EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 54.h),
                    CustomImage(Assets.svg.sucss,
                        height: 124.h, width: 124.h), // SuccessflyLottie(
                    //   // height: 64.w,
                    //   // width: 64.h,
                    //   onFinished: () {
                    //     setState(() {
                    //       _finish = true;
                    //     });
                    //     if (onFnish != null) Timer(Duration(seconds: 1), () => onFnish());
                    //   },
                    // ),
                    SizedBox(height: 43.h),
                    AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      opacity: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 50.w),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              style: context.textTheme.headline4,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 42.h),
                            btnWidget,
                            SizedBox(height: 42.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  static selectOptionalSeetButton({
    required String title,
    required List items,
    dynamic item,
    required Function(dynamic item) onSubmit,
    bool multi = false,
    List<Widget>? trailing,
  }) {
    dynamic _item = item;
    return showModalBottomSheet(
      isDismissible: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.h), topRight: Radius.circular(50.h))),
      isScrollControlled: true,
      context: navigator.currentContext!,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 40),
                  Container(
                    height: 30,
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))),
                    alignment: Alignment.center,
                    child: Text(title,
                        style:
                            context.textTheme.headline1!.copyWith(fontSize: 25),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: BoxConstraints(maxHeight: context.h / 1.3),
                    // flex: items.length < 5 ? 0 : 1,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: ListTile(
                            title: Row(
                              children: [
                                Radio(
                                  value: true,
                                  groupValue: multi
                                      ? _item
                                          .any((e) => e.id == items[index].id)
                                      : _item.id == items[index].id,
                                  activeColor: context.color.primary,
                                  onChanged: (v) {
                                    if (multi) {
                                      if (_item.any(
                                          (e) => e.id == items[index].id)) {
                                        _item.removeWhere(
                                            (e) => e.id == items[index].id);
                                      } else {
                                        _item.add(items[index]);
                                      }
                                    } else {
                                      _item = items[index];
                                    }
                                    setState(() {});
                                  },
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  items[index].name ?? "",
                                  style: context.textTheme.bodyText1!.copyWith(
                                    fontSize: 16,
                                    color: (multi
                                            ? _item.any(
                                                (e) => e.id == items[index].id)
                                            : _item.id == items[index].id)
                                        ? context.color.primary
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            trailing: trailing == null ? null : trailing[index],
                            onTap: () {
                              if (multi) {
                                if (_item.any((e) => e.id == items[index].id)) {
                                  _item.removeWhere(
                                      (e) => e.id == items[index].id);
                                } else {
                                  _item.add(items[index]);
                                }
                              } else {
                                _item = items[index];
                              }
                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.h,
                      vertical: 5.h,
                    ),
                    child: Btn(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      text: LocaleKeys.Selecte.tr(),
                      color: context.color.primary,
                      textColor: context.color.secondary,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) => value == true ? onSubmit(_item) : onSubmit(item));
  }

  static Future optionalDialog(
      {String? msg,
      required String btnMsg,
      void Function()? onClick,
      required String cancelText,
      String? title,
      void Function()? onCancel}) async {
    return showDialog(
      context: navigator.currentContext!,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(16.h),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.white,
          elevation: 5,
          child: Container(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.width / 3),
            padding: EdgeInsets.all(10.h),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (title != null)
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: context.textTheme.headline1,
                  ),
                if (msg != null)
                  Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: context.textTheme.subtitle1?.copyWith(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey,
                    ),
                  ).paddingOnly(top: 16.h, bottom: 28.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Btn(
                      height: 40.h,
                      color: context.color.secondary,
                      onTap: onClick,
                      text: btnMsg,
                      textColor: Colors.white,
                      width: 80.w,
                    ),
                    SizedBox(width: 5.w),
                    Btn(
                      height: 40.h,
                      color: context.color.primary,
                      onTap: onCancel,
                      text: cancelText,
                      textColor: context.color.secondary,
                      width: 80.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
