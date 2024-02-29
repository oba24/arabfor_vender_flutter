import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:saudimerchantsiller/helper/extintions.dart';

import '../gen/assets.gen.dart';

class FailedWidget extends StatelessWidget {
  final int errType;
  final String title;
  final double? height;
  final double? width;
  final double fontSize;
  final void Function()? onTap;
  const FailedWidget({
    Key? key,
    required this.errType,
    required this.title,
    required this.onTap,
    this.height,
    this.width,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width ?? 150.w,
              height: height,
              child: Lottie.asset(
                [Assets.loattie.networkError, Assets.loattie.worn, Assets.loattie.error][errType],
                width: 150.w,
                fit: BoxFit.contain,
                repeat: false,
              ),
            ).paddingSymmetric(vertical: 16.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.headline1?.copyWith(fontSize: fontSize, color: context.color.secondary),
            ).onCenter,
          ],
        ),
      ),
    );
  }
}
