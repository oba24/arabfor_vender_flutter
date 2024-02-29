import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import '../../common/failed_widget.dart';
import '../../common/loading_app.dart';
import '../../gen/assets.gen.dart';
import '../../gen_bloc/order/bloc.dart';
import '../../gen_bloc/order/events.dart';
import '../../gen_bloc/order/states.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/asset_image.dart';
import '../../helper/extintions.dart';
import '../../helper/rout.dart';
import '../../models/order_model.dart';
import '../common_cards/order.dart';
import '../order_details/view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _search = TextEditingController();
  final StreamController<bool> _searchListen = StreamController.broadcast();
  String oldSearch = "";
  @override
  void initState() {
    _bloc.add(StartOrderEvent("home"));
    _search.addListener(() {
      _searchListen.add(_search.text.isNotEmpty);
    });

    super.initState();
  }

  Timer? _timer;
  _onSearch(String v) {
    if (_timer != null && _timer!.isActive) _timer!.cancel();
    _timer = Timer(500.milliseconds, () {
      if (v.isEmpty) {
        _bloc.add(StartOrderEvent("home"));
      } else if (oldSearch != v) {
        _bloc.add(StartOrderEvent("search", search: v));
        oldSearch = v;
      }
    });
  }

  final _bloc = KiwiContainer().resolve<OrderBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.secondary,
      appBar: AppBar(
        backgroundColor: context.color.primary,
        elevation: 0,
        centerTitle: true,
        title: CustomImage(
          Assets.svg.artboardAr,
          width: 150.h,
        ),
        bottom: PreferredSize(
          child: SizedBox(
              height: 40.h,
              child: Padding(
                padding: EdgeInsets.all(3.h),
                child: TextFormField(
                  controller: _search,
                  onChanged: _onSearch,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: context.color.primary),
                  decoration: InputDecoration.collapsed(
                    hintText: LocaleKeys.Write_a_request_number.tr(),
                  ).copyWith(
                    hintStyle: context.textTheme.headline5!.copyWith(
                        color: context.color.tertiary,
                        fontWeight: FontWeight.w500),
                    fillColor: context.color.secondary,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 5),
                    suffixIcon: StreamBuilder<bool>(
                      stream: _searchListen.stream,
                      initialData: false,
                      builder: (context, snapshot) {
                        if (snapshot.data == true) {
                          return InkWell(
                            onTap: () {
                              _search.clear();
                              _bloc.add(StartOrderEvent("home"));
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: SizedBox(
                                width: 18.w,
                                child: Icon(Icons.highlight_off,
                                    color: context.color.secondary)),
                          );
                        }
                        return SizedBox(
                            width: 18.w,
                            child: CustomImage(
                              Assets.images.iconSearch.path,
                              color: context.color.primary,
                              width: 20.h,
                            ).onCenter);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: "#43290A".toColor, width: 2.h),
                      borderRadius: BorderRadius.circular(10.h),
                    ),
                  ),
                ),
              )).paddingSymmetric(horizontal: 14.w),
          preferredSize: const Size.fromHeight(0),
        ),
        toolbarHeight: 100.h,
      ),
      body: BlocBuilder(
          bloc: _bloc,
          builder: (context, state) {
            if (state is LoadingOrderState) {
              return const LoadingApp();
            } else if (state is FaildOrderState) {
              return FailedWidget(
                errType: state.errType,
                title: state.msg,
                onTap: () => _bloc.add(StartOrderEvent("home")),
              );
            } else if (state is DoneOrderState) {
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                children: [
                  if (state.type == "home")
                    Text(
                      LocaleKeys.New_Orders.tr(),
                      style: context.textTheme.headline2,
                    ).onCenter,
                  SizedBox(height: 20.w),
                  if (state.data.isEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomImage(Assets.svg.orders,
                            color: context.color.primary.withOpacity(0.3),
                            height: 120.h),
                        Text(
                                LocaleKeys
                                        .There_are_no_requests_at_the_present_time
                                    .tr(),
                                style: context.textTheme.headline4)
                            .paddingOnly(top: 24.h),
                      ],
                    ).paddingSymmetric(vertical: 100.h),
                  ...List.generate(
                    state.data.length,
                    (index) => OrderCard(
                      onTap: () {
                        push(OrderDetailsView(id: state.data[index].id))
                            .then((value) {
                          if (value is OrderDatum) {
                            setState(() {
                              state.data[index] = value;
                            });
                          } else if (value == "remove") {
                            setState(() {
                              state.data.removeAt(index);
                            });
                          }
                        });
                      },
                      date: state.data[index].date,
                      status: state.data[index].statusTr,
                      statusColor: state.data[index].hexColor.toColor,
                      id: state.data[index].id,
                      price: state.data[index].totalPrice,
                      images: state.data[index].orderProducts
                          .map((e) => e.product.imageUrl)
                          .toList(),
                    ).paddingOnly(bottom: 16.h),
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}
