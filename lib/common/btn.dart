import 'dart:async';

import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../gen/assets.gen.dart';
import '../helper/extintions.dart';

class Btn extends StatelessWidget {
  final Color? color;
  final String text;
  final bool loading;
  final double? height;
  final double? width;
  final Widget? widget;
  final StreamController<double>? onReceiveProgress;
  final void Function()? onTap;
  final Color? textColor;
  const Btn(
      {Key? key,
      this.color,
      required this.text,
      this.textColor,
      this.onTap,
      this.loading = false,
      this.widget,
      this.onReceiveProgress,
      this.height,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading == false ? onTap : null,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 48.0.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          color: color ?? context.color.secondary.withOpacity(loading ? 0.5 : 1),
        ),
        child: Row(
          children: [
            if (loading)
              Expanded(
                flex: 1,
                child: onReceiveProgress != null
                    ? StreamBuilder<double>(
                        stream: onReceiveProgress!.stream,
                        initialData: 0,
                        builder: (context, pecent) {
                          return SizedBox(
                            height: 55.h,
                            width: 55.h,
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 25.h,
                                  width: 25.h,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(context.color.primary),
                                    backgroundColor: context.color.primary.withOpacity(0.5),
                                    value: pecent.data,
                                  ).onCenter,
                                ),
                                Text(
                                  (pecent.data! * 100).toStringAsFixed(0) + " %",
                                  style: context.textTheme.headline4!.copyWith(
                                    fontSize: 13.0,
                                    color: const Color(0xFFB8B8D2),
                                    height: 1,
                                  ),
                                ).onCenter,
                              ],
                            ),
                          );
                        },
                      )
                    : Container(
                        alignment: AlignmentDirectional.centerStart,
                        child: Lottie.asset(Assets.loattie.loadingBtn),
                      ),
              ),
            Expanded(
              flex: 4,
              child: widget ??
                  Text(
                    text,
                    style: context.textTheme.headline4!.copyWith(color: textColor ?? context.theme.primaryColor),
                    textAlign: TextAlign.center,
                  ).onCenter,
            ),
            if (loading) const Expanded(flex: 1, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
