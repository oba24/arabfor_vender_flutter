import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimerchantsiller/gen/assets.gen.dart';
import 'package:saudimerchantsiller/gen_bloc/order/bloc.dart';
import 'package:saudimerchantsiller/helper/asset_image.dart';
import 'package:saudimerchantsiller/helper/extintions.dart';
import 'package:saudimerchantsiller/helper/rout.dart';
import 'package:saudimerchantsiller/view/common_cards/order.dart';
import 'package:saudimerchantsiller/view/order_details/view.dart';

import '../../common/failed_widget.dart';
import '../../common/loading_app.dart';
import '../../gen_bloc/order/events.dart';
import '../../gen_bloc/order/states.dart';
import '../../generated/locale_keys.g.dart';
import '../../models/order_model.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int _curruntIndex = 0;
  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(() {
      if (_curruntIndex != _controller.index) {
        _curruntIndex = _controller.index;
        _bloc.add(StartOrderEvent(
            ["order_current", "order_finished"][_curruntIndex]));
      }
    });
    _bloc.add(StartOrderEvent("order_current"));
    super.initState();
  }

  final _bloc = KiwiContainer().resolve<OrderBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.secondaryContainer,
      appBar: AppBar(
        title: Text(LocaleKeys.My_requests.tr(),
            style: context.textTheme.headline2!
                .copyWith(color: context.color.secondary)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: context.color.primaryContainer,
        bottom: TabBar(
          controller: _controller,
          labelColor: context.color.secondary,
          labelStyle: const TextStyle(
              fontFamily: 'Somar', fontSize: 20.0, fontWeight: FontWeight.w700),
          unselectedLabelColor: context.color.secondary.withOpacity(0.5),
          indicatorColor: context.color.secondary,
          tabs: [
            Tab(child: Text(LocaleKeys.current_requests.tr())),
            Tab(child: Text(LocaleKeys.expired_requests.tr()))
          ],
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: List.generate(
          2,
          (index) {
            return BlocBuilder(
              bloc: _bloc,
              builder: (context, state) {
                if (state is LoadingOrderState) {
                  return LoadingApp(height: 60.h);
                } else if (state is FaildOrderState) {
                  return FailedWidget(
                    errType: state.errType,
                    title: state.msg,
                    onTap: () => _bloc.add(StartOrderEvent(
                        ["order_current", "order_finished"][index])),
                  );
                } else if (state is DoneOrderState) {
                  if (state.data.isEmpty) {
                    return Column(
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
                    );
                  }
                  return ListView.separated(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 35.h),
                    itemCount: state.data.length,
                    separatorBuilder: (context, i) {
                      return SizedBox(height: 10.h);
                    },
                    itemBuilder: (context, i) {
                      return OrderCard(
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
                        id: state.data[i].id,
                        date: state.data[i].date,
                        price: state.data[i].totalPrice,
                        status: state.data[i].statusTr,
                        statusColor: state.data[i].hexColor.toColor,
                        images: state.data[i].orderProducts
                            .map((e) => e.product.imageUrl)
                            .toList(),
                      );
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
