import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimerchantsiller/gen/assets.gen.dart';
import 'package:saudimerchantsiller/helper/asset_image.dart';
import 'package:saudimerchantsiller/helper/extintions.dart';
import 'package:saudimerchantsiller/view/setting/bloc/events.dart';
import '../../common/failed_widget.dart';
import '../../common/loading_app.dart';
import 'bloc/bloc.dart';
import 'bloc/states.dart';

class PagesView extends StatefulWidget {
  final String type;
  final String title;
  const PagesView({Key? key, required this.type, required this.title})
      : super(key: key);

  @override
  State<PagesView> createState() => _PagesViewState();
}

class _PagesViewState extends State<PagesView> {
  final _bloc = KiwiContainer().resolve<SettingBloc>();
  @override
  void initState() {
    _bloc.add(StartPagesEvent(widget.type));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.secondaryContainer,
      appBar: AppBar(
        title: Text(widget.title,
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
          } else if (state is DonePagesState) {
            return ListView(
              children: [
                if (widget.type == "about")
                  CustomImage(Assets.svg.logo, height: 68.15.h)
                      .paddingSymmetric(vertical: 34.h),
                Html(data: state.data),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
