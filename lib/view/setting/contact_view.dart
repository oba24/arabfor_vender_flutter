import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimerchantsiller/common/btn.dart';
import 'package:saudimerchantsiller/common/custom_text_failed.dart';
import 'package:saudimerchantsiller/helper/extintions.dart';
import 'package:saudimerchantsiller/helper/flash_helper.dart';

import '../../generated/locale_keys.g.dart';
import 'bloc/bloc.dart';
import 'bloc/events.dart';
import 'bloc/states.dart';

class ContactView extends StatefulWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  final _bloc = KiwiContainer().resolve<SettingBloc>();
  final _event = StartContactEvent();

  final _fKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.secondaryContainer,
      appBar: AppBar(
        title: Text(LocaleKeys.call_us.tr(),
            style: context.textTheme.headline2!
                .copyWith(color: context.color.secondary)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: context.color.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Form(
          key: _fKey,
          child: Column(
            children: [
              CustomTextFailed(
                controller: _event.title,
                hint: LocaleKeys.complaint_title.tr(),
              ),
              CustomTextFailed(
                controller: _event.content,
                hint: LocaleKeys.complaint_text.tr(),
              ).paddingSymmetric(vertical: 16.h),
              BlocConsumer(
                  bloc: _bloc,
                  listener: (context, state) {
                    if (state is DoneContactState) {
                      _fKey.currentState?.reset();
                      FlashHelper.successBar(message: state.msg);
                    } else if (state is FaildSettingState) {
                      FlashHelper.errorBar(message: state.msg);
                    }
                  },
                  builder: (context, snapshot) {
                    return Btn(
                      loading: snapshot is LoadingSettingState,
                      text: LocaleKeys.send.tr(),
                      color: context.color.primary,
                      textColor: context.color.secondary,
                      onTap: () {
                        if (_fKey.currentState!.validate()) {
                          _bloc.add(_event);
                        }
                      },
                    ).paddingSymmetric(vertical: 40.h);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
