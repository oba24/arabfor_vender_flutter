import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../helper/asset_image.dart';
import '../../../helper/extintions.dart';
import '../../../helper/flash_helper.dart';
import '../../../helper/rout.dart';
import '../active_code/view.dart';
import 'bloc/events.dart';
import 'bloc/states.dart';
import '../../../common/btn.dart';
import '../../../common/custom_text_failed.dart';
import '../../nav_bar/view.dart';
import '../active_code/bloc/events.dart';
import '../forget_password/view.dart';
import '../register/view.dart';
import 'package:flutter/material.dart';

import 'bloc/bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final StartLoginEvent _event = StartLoginEvent();

  final LoginBloc _bloc = KiwiContainer().resolve<LoginBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomImage(
              Assets.svg.artboardAr,
              height: 85.h,
              fit: BoxFit.fill,
            ).paddingOnly(top: 95.h, bottom: 46.h).onCenter,
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.h),
                  color: context.theme.primaryColor),
              child: Column(
                children: [
                  Text(LocaleKeys.welcome_back.tr(),
                          style: context.textTheme.headline1)
                      .paddingOnly(top: 38.h, bottom: 14.h),
                  Text(
                    LocaleKeys.Please_register_your_login_data.tr(),
                    style: context.textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ).paddingOnly(bottom: 34.h),
                  Form(
                    key: _event.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFailed(
                          controller: _event.mobile,
                          keyboardType: TextInputType.phone,
                          hint: LocaleKeys.Mobile_number.tr(),
                        ),
                        SizedBox(height: 42.h),
                        CustomTextFailed(
                          controller: _event.password,
                          keyboardType: TextInputType.visiblePassword,
                          hint: LocaleKeys.password.tr(),
                        ),
                        SizedBox(height: 14.h),
                        InkWell(
                          onTap: () => push(const ForgetPasswordView()),
                          child: Padding(
                            padding: EdgeInsets.all(14.h),
                            child: Text(
                              LocaleKeys.Forgot_your_password.tr(),
                              style: context.textTheme.subtitle1
                                  ?.copyWith(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ).onCenter,
                        ),
                        SizedBox(height: 23.h),
                      ],
                    ).paddingSymmetric(horizontal: 25.w),
                  ),
                ],
              ),
            ).paddingSymmetric(horizontal: 11.w),
            SizedBox(height: 24.h),
            BlocConsumer(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is DoneLoginState) {
                    pushAndRemoveUntil(const NavBarView());
                  } else if (state is FaildLoginState) {
                    FlashHelper.errorBar(message: state.msg);
                    if (state.isActive == false) {
                      push(ActiveCodeView(
                          event: StartActiveCodeEvent(
                              mobile: _event.mobile, type: TYPE.register)));
                    }
                  }
                },
                builder: (context, snapshot) {
                  return Btn(
                    loading: snapshot is LoadingLoginState,
                    text: LocaleKeys.Login.tr(),
                    onTap: () {
                      if (_event.formKey.currentState!.validate()) {
                        _bloc.add(_event);
                      }
                    },
                    color: context.color.secondary,
                    textColor: context.color.primary,
                  ).paddingSymmetric(horizontal: 24.w);
                }),
            SizedBox(height: 30.h),
            InkWell(
              onTap: () => push(const RegisterView()),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: LocaleKeys.You_do_not_have_an_account.tr(),
                        style: context.textTheme.subtitle1),
                    const TextSpan(text: " "),
                    TextSpan(
                      text: LocaleKeys.Create_a_new_account.tr(),
                      style: context.textTheme.headline5
                          ?.copyWith(color: context.color.secondary),
                    ),
                  ],
                ),
              ).paddingSymmetric(vertical: 8.h),
            ),
            SizedBox(height: 56.h),
          ],
        ),
      ),
    );
  }
}
