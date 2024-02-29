import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimerchantsiller/helper/flash_helper.dart';
import 'package:saudimerchantsiller/helper/rout.dart';
import 'package:saudimerchantsiller/view/auth/login/view.dart';
import 'package:saudimerchantsiller/view/auth/reset_password/bloc/bloc.dart';
import 'package:saudimerchantsiller/view/auth/reset_password/bloc/states.dart';
import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../helper/asset_image.dart';
import '../../../helper/extintions.dart';
import '../../../common/btn.dart';
import '../../../common/custom_text_failed.dart';
import 'package:flutter/material.dart';

import 'bloc/events.dart';

class ResetPasswordView extends StatefulWidget {
  final String phone, code;
  const ResetPasswordView({Key? key, required this.phone, required this.code})
      : super(key: key);

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  late final StartResetPasswordEvent _event;

  final _bloc = KiwiContainer().resolve<ResetPasswordBloc>();

  final _fKey = GlobalKey<FormState>();
  @override
  void initState() {
    _event = StartResetPasswordEvent(widget.phone, widget.code);
    super.initState();
  }

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
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 38.h),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.h),
                  color: context.theme.primaryColor),
              child: Form(
                key: _fKey,
                child: Column(
                  children: [
                    Text(LocaleKeys.new_password.tr(),
                        style: context.textTheme.headline1),
                    SizedBox(height: 11.h),
                    Text(
                      LocaleKeys.please_inter_your_New_Password.tr(),
                      style: context.textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 35.h),
                    CustomTextFailed(
                      controller: _event.newPassword,
                      keyboardType: TextInputType.visiblePassword,
                      hint: LocaleKeys.password.tr(),
                    ),
                    SizedBox(height: 14.h),
                    CustomTextFailed(
                      controller: _event.confairmNewPawword,
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "${LocaleKeys.confirm_password.tr()} ${LocaleKeys.requerd.tr()}";
                        } else if (v != _event.newPassword.text) {
                          return LocaleKeys.The_passwords_are_not_identical
                              .tr();
                        }
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      hint: LocaleKeys.confirm_password.tr(),
                    ),
                    SizedBox(height: 16.h),
                    BlocConsumer(
                      bloc: _bloc,
                      listener: (context, state) {
                        if (state is FaildResetPasswordState) {
                          FlashHelper.errorBar(message: state.msg);
                        } else if (state is DoneResetPasswordState) {
                          FlashHelper.successBar(message: state.msg);
                          pushAndRemoveUntil(const LoginView());
                        }
                      },
                      builder: (context, snapshot) {
                        return Btn(
                          loading: snapshot is LoadingResetPasswordState,
                          text: LocaleKeys.Login.tr(),
                          onTap: () {
                            if (_fKey.currentState!.validate()) {
                              _bloc.add(_event);
                            }
                          },
                          color: context.color.primary,
                          textColor: context.color.secondary,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ).paddingSymmetric(horizontal: 11.w),
            SizedBox(height: 56.h),
          ],
        ),
      ),
    );
  }
}
