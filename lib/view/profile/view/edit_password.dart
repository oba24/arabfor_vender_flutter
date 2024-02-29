import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import '../../../common/btn.dart';
// ignore: unused_import
import 'package:saudimerchantsiller/common/custom_text_failed.dart';
import 'package:saudimerchantsiller/generated/locale_keys.g.dart';
import 'package:saudimerchantsiller/helper/extintions.dart';
import 'package:saudimerchantsiller/helper/flash_helper.dart';

import '../bloc/bloc.dart';
import '../bloc/events.dart';
import '../bloc/states.dart';

class EditPasswordView extends StatefulWidget {
  const EditPasswordView({Key? key}) : super(key: key);

  @override
  State<EditPasswordView> createState() => _EditPasswordViewState();
}

class _EditPasswordViewState extends State<EditPasswordView> {
  final StartEditPasswordEvent _event = StartEditPasswordEvent();
  final UpdateProfileBloc _bloc = KiwiContainer().resolve<UpdateProfileBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.secondary,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: context.color.primary,
        title: Text(
          LocaleKeys.Edit_Password.tr(),
          style: context.textTheme.headline2!
              .copyWith(color: context.color.secondary),
          textAlign: TextAlign.center,
        ),
        // leading: IconButton(
        //   onPressed: () => Navigator.pop(context),
        //   icon: Icon(
        //     Icons.arrow_forward_ios_sharp,
        //     color: context.color.secondary,
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 29.h, horizontal: 24.w),
        child: Form(
          key: _event.formKey,
          child: Column(
            children: [
              CustomTextFailed(
                controller: _event.currntPassword,
                keyboardType: TextInputType.visiblePassword,
                hint: LocaleKeys.Current_Password.tr(),
              ),
              SizedBox(height: 16.h),
              CustomTextFailed(
                controller: _event.newPassword,
                keyboardType: TextInputType.visiblePassword,
                hint: LocaleKeys.new_password.tr(),
              ),
              SizedBox(height: 16.h),
              CustomTextFailed(
                controller: _event.confairmNewPawword,
                validator: (v) {
                  if (v!.isEmpty) {
                    return "${LocaleKeys.confirm_password.tr()} ${LocaleKeys.requerd.tr()}";
                  } else if (v != _event.newPassword.text) {
                    return LocaleKeys.The_passwords_are_not_identical.tr();
                  }
                  return null;
                },
                keyboardType: TextInputType.visiblePassword,
                hint: LocaleKeys.confirm_password.tr(),
              ),
              SizedBox(height: 45.h),
              BlocConsumer(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is DoneEditPasswordState) {
                    Navigator.pop(context);
                    FlashHelper.successBar(message: state.msg);
                  } else if (state is FaildUpdateProfileState) {
                    FlashHelper.errorBar(message: state.msg);
                  }
                },
                builder: (context, snapshot) {
                  return Btn(
                    loading: snapshot is LoadingUpdateProfileState,
                    text: LocaleKeys.Save.tr(),
                    color: context.color.primary,
                    textColor: context.color.secondary,
                    onTap: () {
                      if (_event.formKey.currentState!.validate()) {
                        _bloc.add(_event);
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
