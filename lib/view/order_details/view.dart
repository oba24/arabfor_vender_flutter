import 'package:easy_localization/easy_localization.dart' as lang;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimerchantsiller/common/alert.dart';
import 'package:saudimerchantsiller/gen_bloc/order/bloc.dart';
import 'package:saudimerchantsiller/helper/flash_helper.dart';
import 'package:saudimerchantsiller/helper/rout.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/btn.dart';
import '../../common/failed_widget.dart';
import '../../common/loading_app.dart';
import '../../gen/assets.gen.dart';
import '../../gen_bloc/order/events.dart';
import '../../gen_bloc/order/states.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/asset_image.dart';
import '../../helper/extintions.dart';

class OrderDetailsView extends StatefulWidget {
  final int id;
  const OrderDetailsView({Key? key, required this.id}) : super(key: key);

  @override
  State<OrderDetailsView> createState() => _OrderDetailsStateView();
}

class _OrderDetailsStateView extends State<OrderDetailsView> {
  final _bloc = KiwiContainer().resolve<OrderBloc>();
  final _changeStatusBloc = KiwiContainer().resolve<OrderBloc>();
  @override
  void initState() {
    _bloc.add(StartSingleOrderEvent(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, state is DoneSingleOrderState ? state.data : null);
              return true;
            },
            child: Scaffold(
              backgroundColor: "#FBF9F4".toColor,
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: "#FBF9F4".toColor,
                elevation: 0,
                title: Text('#${widget.id}', style: context.textTheme.headline2),
                // leading: IconButton(
                //   onPressed: () => Navigator.pop(context, state is DoneSingleOrderState ? state.data : null),
                //   icon: Icon(
                //     Icons.arrow_back_ios,
                //     color: context.color.secondary,
                //   ),
                // ),
              ),
              body: Builder(builder: (context) {
                if (state is LoadingOrderState) {
                  return const LoadingApp();
                } else if (state is FaildOrderState) {
                  return FailedWidget(
                    errType: state.errType,
                    title: state.msg,
                    onTap: () => _bloc.add(StartSingleOrderEvent(widget.id)),
                  );
                } else if (state is DoneSingleOrderState) {
                  return ListView(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.data.statusTr,
                            style: context.textTheme.subtitle1?.copyWith(
                              fontSize: 20,
                              color: state.data.hexColor.toColor,
                            ),
                          ),
                          Text(
                            state.data.date + "\n" + state.data.time,
                            style: context.textTheme.subtitle1?.copyWith(fontSize: 20, color: "#929292".toColor, height: 0.8),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 32.w),
                      SizedBox(height: 18.h),
                      SizedBox(
                        height: 220.h,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          itemCount: state.data.orderProducts.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsetsDirectional.only(end: 18.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomImage(
                                    state.data.orderProducts[index].product.imageUrl,
                                    width: 133.5.h,
                                    height: 128.73.w,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: state.data.orderProducts[index].product.name,
                                          style: context.textTheme.headline3?.copyWith(color: context.color.secondary, fontSize: 21),
                                        ),
                                        const TextSpan(text: "\n"),
                                        TextSpan(
                                          text: 'X${state.data.orderProducts[index].quantity}',
                                          style: context.textTheme.bodyText1,
                                        ),
                                        const TextSpan(text: "\n"),
                                        TextSpan(
                                          text: state.data.orderProducts[index].product.finalPrice.toString(),
                                          style: context.textTheme.headline3,
                                        ),
                                        TextSpan(
                                          text: "  ${LocaleKeys.SR.tr()}  ",
                                          style: context.textTheme.subtitle2?.copyWith(color: context.color.secondary),
                                        ),
                                        if (state.data.orderProducts[index].product.priceAfterDiscount > 0)
                                          TextSpan(
                                            text: "${state.data.orderProducts[index].product.priceBeforeDiscount}  ${LocaleKeys.SR.tr()}",
                                            style: context.textTheme.subtitle2
                                                ?.copyWith(color: context.color.secondary, decoration: TextDecoration.lineThrough),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 18.h),

                      /// invoic pay
                      ...List.generate(
                        4,
                        (i) => Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              [
                                LocaleKeys.Product_Price,
                                LocaleKeys.Discount,
                                LocaleKeys.Shipping_Rate,
                                LocaleKeys.Total,
                              ][i]
                                  .tr(),
                              style: i == 3 ? context.textTheme.headline2 : context.textTheme.headline5,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(
                                  20,
                                  (index) => Container(
                                    width: 4,
                                    height: 1,
                                    color: "#DDDDDD".toColor,
                                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                                  ),
                                ),
                              ).paddingSymmetric(horizontal: 5.w),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: [
                                      state.data.productsPrice,
                                      state.data.totaleDiscount,
                                      state.data.deliveryPrice,
                                      state.data.totalPrice,
                                    ][i]
                                        .toString(),
                                    style: context.textTheme.headline2,
                                  ),
                                  TextSpan(
                                    text: " ${LocaleKeys.SR.tr()}",
                                    style: context.textTheme.subtitle1,
                                  ),
                                ],
                              ),
                            ).paddingOnly(bottom: 4.h),
                          ],
                        ).paddingSymmetric(horizontal: 32.w),
                      ),
                      Divider(color: "#DDDDDD".toColor, height: 32.h).paddingSymmetric(horizontal: 32.w),
                      // client data
                      ListTile(
                        leading: CustomImage(
                          state.data.client.imageUrl,
                          borderRadius: BorderRadius.circular(1000),
                          height: 46.h,
                          width: 46.h,
                        ),
                        title: Text(
                          state.data.client.name,
                          style: context.textTheme.headline3,
                        ),
                      ).paddingSymmetric(horizontal: 32.w),
                      Divider(color: "#DDDDDD".toColor, height: 32.h).paddingSymmetric(horizontal: 32.w),
                      Row(
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: LocaleKeys.Delivery_Address.tr(),
                                    style: context.textTheme.headline2?.copyWith(fontSize: 27),
                                  ),
                                  const TextSpan(text: "\n"),
                                  TextSpan(
                                    text: state.data.addressDetails.name,
                                    style: context.textTheme.headline6,
                                  ),
                                  const TextSpan(text: "\n"),
                                  TextSpan(
                                    text: state.data.addressDetails.address,
                                    style: context.textTheme.bodyText1?.copyWith(color: "#958A7E".toColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async => launchUrl(Uri.parse(
                                "https://www.google.com/maps/search/?api=1&query=${state.data.addressDetails.latLbg.latitude},${state.data.addressDetails.latLbg.longitude}")),
                            child: CustomImage(Assets.svg.iconAwesomeDirections).paddingOnly(top: 40.h),
                          )
                        ],
                      ).paddingSymmetric(horizontal: 32.w),
                      Divider(color: "#DDDDDD".toColor, height: 32.h).paddingSymmetric(horizontal: 32.w),
                      Text(
                        LocaleKeys.payment_method.tr(),
                        style: context.textTheme.headline2?.copyWith(fontSize: 27),
                        textAlign: TextAlign.right,
                      ).paddingSymmetric(horizontal: 32.w),
                      ListTile(
                        title: Text(state.data.payTypeTr, style: context.textTheme.headline5),
                        leading: CustomImage(
                          state.data.payImgTr,
                          height: 18.h,
                        ),
                      ).paddingSymmetric(horizontal: 32.w),
                      if (["pending", "accepted"].any((e) => e == state.data.status))
                        BlocConsumer(
                          bloc: _changeStatusBloc,
                          listener: (context, setStatus) {
                            if (setStatus is DoneChangStatusOrderState) {
                              if (setStatus.data.status == "finished") {
                                CustomAlert.succAlert(
                                  LocaleKeys.the_request_has_been_completed_successfully_and_transferred_in_the_ending_requests.tr(),
                                  Btn(
                                    text: LocaleKeys.Follow_up_requests.tr(),
                                    onTap: () {
                                      Navigator.pop(navigator.currentContext!);
                                      Navigator.pop(context, "remove");
                                    },
                                  ),
                                );
                              } else {
                                FlashHelper.successBar(message: setStatus.msg);
                              }
                              setState(() {
                                state.data = setStatus.data;
                              });
                            } else if (setStatus is FaildOrderState) {
                              FlashHelper.successBar(message: setStatus.msg);
                            }
                          },
                          builder: (context, changeStatusState) {
                            return Btn(
                              loading: changeStatusState is LoadingOrderState,
                              text: {
                                    "pending": LocaleKeys.implementation_of_order.tr(),
                                    "accepted": LocaleKeys.end_of_the_request.tr(),
                                  }[state.data.status] ??
                                  "",
                              color: {"pending": "#00C569".toColor, "accepted": "#FA4248".toColor}[state.data.status],
                              onTap: () {
                                _changeStatusBloc.add(
                                  StartChangStatusOrderEvent(
                                    {"pending": "accept_order", "accepted": "finished_order"}[state.data.status] ?? "",
                                    widget.id,
                                  ),
                                );
                              },
                            ).paddingAll(32.w);
                          },
                        ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ),
          );
        });
  }
}
