import 'package:easy_localization/easy_localization.dart' as lang;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import '../../../common/custom_pin_code.dart';
import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../helper/asset_image.dart';
import '../../../helper/extintions.dart';
import '../../../helper/flash_helper.dart';
import '../../../helper/rout.dart';
import 'bloc/states.dart';
import '../login/view.dart';
import '../../../common/btn.dart';
import '../../nav_bar/view.dart';
import '../reset_password/view.dart';
import 'bloc/bloc.dart';
import 'bloc/events.dart';

class ActiveCodeView extends StatefulWidget {
  final StartActiveCodeEvent event;
  const ActiveCodeView({Key? key, required this.event}) : super(key: key);

  @override
  State<ActiveCodeView> createState() => _ActiveCodeViewState();
}

class _ActiveCodeViewState extends State<ActiveCodeView> {
  late StartActiveCodeEvent _event;
  @override
  void initState() {
    _event = widget.event;
    super.initState();
  }

  final ActiveCodeBloc _bloc = KiwiContainer().resolve<ActiveCodeBloc>();

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
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 38.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.h),
                  color: context.theme.primaryColor),
              child: Column(
                children: [
                  Text(
                    _event.type == TYPE.register
                        ? LocaleKeys.activate_the_account.tr()
                        : LocaleKeys.Validation_code.tr(),
                    style: context.textTheme.headline1,
                  ),
                  Text(
                    _event.type == TYPE.register
                        ? LocaleKeys
                                .A_message_was_sent_on_your_mobile_number_to_activate_the_account
                            .tr()
                        : LocaleKeys
                                .A_message_was_sent_to_your_mobile_number_to_check_the_account
                            .tr(),
                    style: context.textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 9.h),
                  Text(
                    '+966 ${_event.mobile.text} ',
                    style: context.textTheme.subtitle1!
                        .copyWith(color: context.color.primary),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                  ),
                  SizedBox(height: 34.h),

                  CustomPinCode(controller: _event.activeCode)
                      .paddingSymmetric(horizontal: 20.w),
                  SizedBox(height: 50.h),
                  BlocConsumer(
                      bloc: _bloc,
                      listener: (context, state) {
                        if (state is DoneActiveCodeState) {
                          if (_event.type == TYPE.resetPassword) {
                            push(ResetPasswordView(
                                phone: _event.mobile.text,
                                code: _event.activeCode.text));
                          } else if (_event.type == TYPE.register) {
                            pushAndRemoveUntil(const NavBarView());
                          }
                        } else if (state is FaildActiveCodeState) {
                          FlashHelper.errorBar(message: state.msg);
                        }
                      },
                      builder: (context, snapshot) {
                        return Btn(
                          text: LocaleKeys.Login.tr(),
                          loading: snapshot is LoadingActiveCodeState,
                          onTap: () {
                            _bloc.add(_event);
                          },
                          color: context.color.primary,
                          textColor: context.color.secondary,
                        );
                      }),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     // CustomTextFailed(
                  //     //   controller: _event.mobile,
                  //     //   keyboardType: TextInputType.phone,
                  //     //   hint: LocaleKeys.Mobile_number.tr(),
                  //     // ),
                  //     // SizedBox(height: 42.h),
                  //     // CustomTextFailed(
                  //     //   controller: _event.password,
                  //     //   keyboardType: TextInputType.visiblePassword,
                  //     //   hint: LocaleKeys.password.tr(),
                  //     // ),
                  //     SizedBox(height: 14.h),

                  //     SizedBox(height: 23.h),
                  //   ],
                  // ).paddingSymmetric(horizontal: 25.w),
                ],
              ),
            ).paddingSymmetric(horizontal: 11.w),
            SizedBox(height: 24.h),
            //.paddingSymmetric(horizontal: 24.w),
            SizedBox(height: 30.h),
            InkWell(
              onTap: () => push(const LoginView()),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: LocaleKeys.You_have_already_account.tr(),
                        style: context.textTheme.subtitle1),
                    const TextSpan(text: " "),
                    TextSpan(
                      text: LocaleKeys.Login.tr(),
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
