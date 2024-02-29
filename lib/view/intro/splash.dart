import 'dart:async';

import '../../gen/assets.gen.dart';
import '../../helper/asset_image.dart';
import '../../helper/extintions.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import '../../helper/rout.dart';
import 'package:flutter/material.dart';
import '../../helper/user_data.dart';
import '../nav_bar/view.dart';

import '../auth/login/view.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  double logo = 0;
  double? splashDown;
  double? splashUp;
  @override
  void initState() {
    Timer(5.seconds, () {
      splashDown = context.h - 400.h;
      splashUp = context.h - 270.h;
      logo = 1;
      setState(() {});
    });
    Timer(4.seconds, () => _checkUser());
    super.initState();
  }

  _checkUser() async {
    await UserHelper.getUserData();
    if (UserHelper.isAuth) {
      pushAndRemoveUntil(const NavBarView());
    } else {
      pushAndRemoveUntil(const LoginView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.h,
        width: context.w,
        child: Stack(
          children: [
            AnimatedPositioned(
              top: splashDown ?? 0,
              duration: 500.milliseconds,
              child: CustomImage(
                Assets.images.splashDown.path,
                height: context.h,
                width: context.w,
                fit: BoxFit.fill,
              ),
            ),
            AnimatedPositioned(
              // bottom: 0,
              bottom: splashUp ?? 0,
              duration: 500.milliseconds,
              child: CustomImage(
                Assets.images.splashUp.path,
                height: context.h,
                width: context.w,
                fit: BoxFit.fill,
              ),
            ),
            Center(
              child: Column(
                children: [
                  const Spacer(),
                  AnimatedOpacity(
                    opacity: logo,
                    duration: 700.milliseconds,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomImage(
                          Assets.svg.logo,
                          height: 105.h,
                        ),
                        SizedBox(height: 50.h),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "مجمع تجاري الكتروني للسلع والمنتجات لكافه",
                                style: context.textTheme.headline2?.copyWith(color: Colors.black, fontSize: 21),
                              ),
                              const TextSpan(text: "\n"),
                              // const TextSpan(text: "\n"),
                              TextSpan(
                                  text: 'الشركات والمؤسسات بالمملكة العربية السعودية',
                                  style: context.textTheme.headline2?.copyWith(color: Colors.black, fontSize: 21, height: 2)),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
