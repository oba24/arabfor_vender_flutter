import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimerchantsiller/helper/extintions.dart';
import 'package:saudimerchantsiller/view/setting/bloc/events.dart';

import '../../common/failed_widget.dart';
import '../../common/loading_app.dart';
import '../../generated/locale_keys.g.dart';
import 'bloc/bloc.dart';
import 'bloc/states.dart';

class CommonQuestionsView extends StatefulWidget {
  const CommonQuestionsView({Key? key}) : super(key: key);

  @override
  State<CommonQuestionsView> createState() => _CommonQuestionsViewState();
}

class _CommonQuestionsViewState extends State<CommonQuestionsView> {
  final _bloc = KiwiContainer().resolve<SettingBloc>();
  @override
  void initState() {
    _bloc.add(StartCommonQuestionsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.secondaryContainer,
      appBar: AppBar(
        title: Text(LocaleKeys.common_questions.tr(),
            style: context.textTheme.headline2!
                .copyWith(color: context.color.secondary)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: context.color.primaryContainer,
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          if (state is LoadingSettingState) {
            return const LoadingApp();
          } else if (state is FaildSettingState) {
            return FailedWidget(
              errType: state.errType,
              title: state.msg,
              onTap: () => _bloc.add(StartCommonQuestionsEvent()),
            );
          } else if (state is DoneCommonQuestionsState) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    state.data[index].question,
                    style: context.textTheme.bodyText2,
                  ),
                  subtitle: Text(
                    state.data[index].answer,
                    style: context.textTheme.bodyText1?.copyWith(
                      fontSize: 16.0,
                      color: context.color.tertiary.withOpacity(.8),
                    ),
                  ),
                );
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
