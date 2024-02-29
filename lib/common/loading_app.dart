import 'package:flutter/material.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:lottie/lottie.dart';
import 'package:saudimerchantsiller/helper/extintions.dart';

import '../gen/assets.gen.dart';

class LoadingBtn extends StatelessWidget {
  const LoadingBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(Assets.loattie.loadingBtn);
  }
}

class LoadingApp extends StatelessWidget {
  final double? height;
  const LoadingApp({Key? key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height ?? 40.h, child: Lottie.asset(Assets.loattie.loadingBtn).onCenter).onCenter;
  }
}

class CustomProgress extends StatelessWidget {
  final double size;
  final double? strokeWidth;
  final Color? color;
  const CustomProgress({Key? key, required this.size, this.strokeWidth, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth ?? 2,
              valueColor: AlwaysStoppedAnimation<Color>(color ?? context.color.primary),
            ),
          ),
        ],
      ),
    );
  }
}
