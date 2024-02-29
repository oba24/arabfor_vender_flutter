import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimerchantsiller/common/btn.dart';
import 'package:saudimerchantsiller/common/custom_text_failed.dart';
import 'package:saudimerchantsiller/generated/locale_keys.g.dart';
import 'package:saudimerchantsiller/helper/extintions.dart';
import 'package:saudimerchantsiller/helper/flash_helper.dart';
import 'package:saudimerchantsiller/view/wallet/bloc/events.dart';
import 'package:saudimerchantsiller/view/wallet/bloc/states.dart';
import '../../common/failed_widget.dart';
import '../../common/loading_app.dart';
import 'bloc/bloc.dart';

class WalletView extends StatefulWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  final _bloc = KiwiContainer().resolve<WalletBloc>();
  final _refundBloc = KiwiContainer().resolve<WalletBloc>();
  final _fKey = GlobalKey<FormState>();

  @override
  void initState() {
    _bloc.add(StartWalletEvent());
    super.initState();
  }

  StartRefundEvent _event = StartRefundEvent();
  bool withDrow = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.color.secondaryContainer,
            appBar: AppBar(
              title: Text(LocaleKeys.wallet.tr(),
                  style: context.textTheme.headline2!
                      .copyWith(color: context.color.secondary)),
              centerTitle: true,
              elevation: 0,
              backgroundColor: context.color.primaryContainer,
            ),
            // bottomNavigationBar: AnimatedSwitcher(
            //   duration: 1.seconds,
            //   child: Builder(
            //     builder: (context) {
            //       if (state is! DoneWalletState) return const SizedBox.shrink();
            //       if (withDrow) {
            //         return Btn(
            //           text: LocaleKeys.Send_the_request.tr(),
            //           onTap: () {
            //             setState(() {
            //               withDrow = false;
            //             });
            //           },
            //         );
            //       } else {
            //         return Btn(
            //           text: LocaleKeys.Refunding_the_amount.tr(),
            //           onTap: () {
            //             setState(() {
            //               withDrow = true;
            //             });
            //           },
            //         );
            //       }
            //     },
            //   ),
            // ).paddingSymmetric(horizontal: 16.w, vertical: 20.h),
            body: Builder(
              builder: (context) {
                if (state is LoadingWalletState) {
                  return LoadingApp(height: 100.h);
                } else if (state is FaildWalletState) {
                  return FailedWidget(
                    errType: state.errType,
                    title: state.msg,
                    onTap: () => _bloc.add(StartWalletEvent()),
                  );
                } else if (state is DoneWalletState) {
                  return ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 5.w),
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color(0xFFF7F5EF),
                          border: Border.all(
                              width: 1.0,
                              color: context.color.primaryContainer),
                        ),
                        child: Column(
                          children: [
                            Text(
                              LocaleKeys.Your_balance_is.tr(),
                              style: context.textTheme.headline5,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: state.wallet.toString(),
                                    style:
                                        context.textTheme.headline1?.copyWith(
                                      fontSize: 68,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  TextSpan(
                                    text: LocaleKeys.SR.tr(),
                                    style:
                                        context.textTheme.headline1?.copyWith(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w800,
                                      height: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      BlocConsumer(
                          bloc: _refundBloc,
                          listener: (context, state) {
                            if (state is DoneRefundState) {
                              setState(() {
                                withDrow = false;
                                _event = StartRefundEvent();
                              });
                              FlashHelper.successBar(message: state.msg);

                              // CustomAlert.succAlert(
                              //   state.msg,
                              //   Btn(
                              //     width: 156.w,
                              //     textColor: context.color.secondary,
                              //     text: LocaleKeys.c.tr(),
                              //     border: Border.all(color: context.color.secondary),
                              //     color: Colors.transparent,
                              //   ),
                              // );
                            } else if (state is FaildWalletState) {
                              FlashHelper.errorBar(message: state.msg);
                            }
                          },
                          builder: (context, snapshot) {
                            return AnimatedContainer(
                              duration: 1.seconds,
                              height: withDrow ? context.h : 0,
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Form(
                                  key: _fKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        LocaleKeys.Bank_account_data.tr(),
                                        textAlign: TextAlign.center,
                                        style: context.textTheme.headline1
                                            ?.copyWith(fontSize: 27.0),
                                      ),
                                      CustomTextFailed(
                                              controller: _event.clientName,
                                              hint:
                                                  LocaleKeys.customer_name.tr())
                                          .paddingSymmetric(vertical: 6.h),
                                      CustomTextFailed(
                                              controller: _event.banckName,
                                              hint: LocaleKeys.Bank_name.tr())
                                          .paddingSymmetric(vertical: 6.h),
                                      CustomTextFailed(
                                              controller: _event.bankBranch,
                                              hint: LocaleKeys.Bank_branch.tr())
                                          .paddingSymmetric(vertical: 6.h),
                                      CustomTextFailed(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: _event.accountNumber,
                                              hint: LocaleKeys.account_number
                                                  .tr())
                                          .paddingSymmetric(vertical: 6.h),
                                      CustomTextFailed(
                                              controller: _event.iban,
                                              hint: LocaleKeys.IPan_number.tr())
                                          .paddingSymmetric(vertical: 6.h),
                                      Btn(
                                        width: 156.w,
                                        loading: snapshot is LoadingWalletState,
                                        text: LocaleKeys.Send_the_request.tr(),
                                        onTap: () {
                                          // setState(() {
                                          //   withDrow = false;
                                          // });
                                          if (_fKey.currentState!.validate())
                                            _refundBloc.add(_event);
                                        },
                                      ).paddingSymmetric(vertical: 20.h),
                                    ],
                                  ),
                                ),
                              ),
                            ).paddingSymmetric(
                                horizontal: 26.w, vertical: 20.h);
                          }),
                      AnimatedSwitcher(
                        duration: 1.seconds,
                        child: Builder(
                          builder: (context) {
                            if (withDrow) return const SizedBox.shrink();
                            return Btn(
                              width: 156.w,
                              text: LocaleKeys.Refunding_the_amount.tr(),
                              onTap: () {
                                setState(() {
                                  withDrow = true;
                                });
                              },
                            );
                          },
                        ),
                      ).paddingSymmetric(horizontal: 16.w, vertical: 20.h),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          );
        });
  }
}
