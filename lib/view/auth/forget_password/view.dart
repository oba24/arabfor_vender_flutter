import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimerchantsiller/helper/flash_helper.dart';
import 'package:saudimerchantsiller/view/auth/forget_password/bloc/states.dart';
import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../helper/asset_image.dart';
import '../../../helper/extintions.dart';
import '../../../helper/rout.dart';
import '../active_code/bloc/events.dart';
import '../active_code/view.dart';
import '../../../common/btn.dart';
import '../../../common/custom_text_failed.dart';
import '../register/view.dart';
import 'package:flutter/material.dart';

import 'bloc/bloc.dart';
import 'bloc/events.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final _bloc = KiwiContainer().resolve<ForgetPasswordBloc>();
  final StartForgetPasswordEvent _event = StartForgetPasswordEvent();
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
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 38.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.h),
                  color: context.theme.primaryColor),
              child: Column(
                children: [
                  Text(LocaleKeys.Account_Confirmation.tr(),
                      style: context.textTheme.headline1),
                  SizedBox(height: 20.h),
                  Text(
                    LocaleKeys.Please_enter_your_mobile_number.tr(),
                    style: context.textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50.h),
                  CustomTextFailed(
                    controller: _event.mobile,
                    keyboardType: TextInputType.phone,
                    hint: LocaleKeys.Mobile_number.tr(),
                  ),
                  SizedBox(height: 54.h),
                  BlocConsumer(
                      bloc: _bloc,
                      listener: (context, state) {
                        if (state is DoneForgetPasswordState) {
                          push(ActiveCodeView(
                              event: StartActiveCodeEvent(
                                  mobile: _event.mobile,
                                  type: TYPE.resetPassword)));
                          FlashHelper.successBar(message: state.msg);
                        } else if (state is FaildForgetPasswordState) {
                          FlashHelper.errorBar(message: state.msg);
                        }
                      },
                      builder: (context, snapshot) {
                        return Btn(
                          loading: snapshot is LoadingForgetPasswordState,
                          text: LocaleKeys.send.tr(),
                          onTap: () {
                            _bloc.add(_event);
                          },
                          color: context.color.primary,
                          textColor: context.color.secondary,
                        );
                      })
                ],
              ),
            ).paddingSymmetric(horizontal: 11.w),
            SizedBox(height: 24.h),
            //.paddingSymmetric(horizontal: 24.w),
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
