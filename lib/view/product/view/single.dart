import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimerchantsiller/common/alert.dart';
import 'package:saudimerchantsiller/gen_bloc/delete/bloc.dart';
import 'package:saudimerchantsiller/gen_bloc/delete/events.dart';
import 'package:saudimerchantsiller/gen_bloc/delete/states.dart';
import 'package:saudimerchantsiller/helper/flash_helper.dart';
import 'package:saudimerchantsiller/helper/rout.dart';
import 'package:saudimerchantsiller/view/add_product/view.dart';
import 'package:saudimerchantsiller/view/product/bloc/bloc.dart';
import 'package:saudimerchantsiller/view/product/bloc/events.dart';
import '../../../common/failed_widget.dart';
import '../../../common/loading_app.dart';
import '../../../common/stare_bar.dart';
import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../helper/asset_image.dart';
import '../../../helper/extintions.dart';
import '../bloc/states.dart';

class SingleProductView extends StatefulWidget {
  final int id;
  const SingleProductView({Key? key, required this.id}) : super(key: key);

  @override
  State<SingleProductView> createState() => _SingleProductViewState();
}

class _SingleProductViewState extends State<SingleProductView> {
  PageController controller = PageController();
  final ProductBloc _bloc = KiwiContainer().resolve<ProductBloc>();
  final DeleteBloc _deleteProductBloc = KiwiContainer().resolve<DeleteBloc>();
  Timer? _timer;
  @override
  void initState() {
    _bloc.add(StartSingleProductsEvent(widget.id));
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: "#FBF9F4".toColor,
      body: BlocConsumer(
        bloc: _bloc,
        listener: (context, state) {
          if (state is DoneSingleProductsState && state.data.productImage.length > 1) {
            _timer = Timer.periodic(10.seconds, (v) {
              if (controller.page != state.data.productImage.length - 1) {
                controller.nextPage(duration: 500.milliseconds, curve: Curves.easeInOutCubicEmphasized);
              } else {
                controller.animateToPage(0, duration: 500.milliseconds, curve: Curves.decelerate);
              }
            });
          }
        },
        builder: (context, state) {
          if (state is LoadingProductState) {
            return const LoadingApp();
          } else if (state is FaildProductState) {
            return FailedWidget(
              errType: state.errType,
              title: state.msg,
              onTap: () => _bloc.add(StartSingleProductsEvent(widget.id)),
            );
          } else if (state is DoneSingleProductsState) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    width: context.w,
                    height: 422.h,
                    alignment: Alignment.topCenter,
                    child: PageView.builder(
                      controller: controller,
                      itemCount: state.data.productImage.length,
                      itemBuilder: (context, i) {
                        return CustomImage(
                          state.data.productImage[i].url,
                          fit: BoxFit.fill,
                          width: context.w,
                          height: 422.h,
                        );
                      },
                    ),
                  ),
                  Container(
                    width: context.w,
                    height: 121.0.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: const Alignment(-0.04, -1.99),
                        end: const Alignment(-0.04, 0.78),
                        colors: [Colors.black, Colors.black.withOpacity(0.0)],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => push(AddProductView(data: state.data)).then((value) {
                            if (value == true) {
                              _bloc.add(StartSingleProductsEvent(widget.id));
                            }
                          }),
                          icon: CustomImage(Assets.svg.editProduct),
                        ),
                        IconButton(
                          onPressed: () => _deleteProduct(state.data.id),
                          icon: BlocConsumer(
                            bloc: _deleteProductBloc,
                            listener: (context, state) {
                              if (state is DoneDeleteState) {
                                FlashHelper.successBar(message: state.msg);
                                Navigator.pop(context, "delete");
                              } else if (state is FaildDeleteState) {
                                FlashHelper.errorBar(message: state.msg);
                              }
                            },
                            builder: (context, snapshot) {
                              if (snapshot is LoadingDeleteState) {
                                return SizedBox(height: 20.w, width: 20.w, child: const CircularProgressIndicator(strokeWidth: 2));
                              }
                              return CustomImage(Assets.svg.deleteProduct);
                            },
                          ),
                        ),
                      ],
                    ),
                  ).paddingSymmetric(horizontal: 10.w),
                  if (state.data.discountPercentage > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 35.h,
                          height: 35.h,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: context.color.secondary),
                          child: Text(
                            "${state.data.discountPercentage}%\nOFF",
                            style: context.textTheme.subtitle1?.copyWith(color: Colors.white, height: 0.8, fontSize: 16),
                            textAlign: TextAlign.center,
                          ).onCenter,
                        ).paddingOnly(top: 281.h, left: 24.w, right: 24.w),
                      ],
                    ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 22.h),
                    width: context.w,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
                      color: Color(0xFFFBF9F4),
                    ),
                    child: Column(
                      children: [
                        Text(state.data.name, style: context.textTheme.headline2),
                        CustomStarBar(rate: state.data.avgRate, size: 20.h).paddingSymmetric(vertical: 4.h),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: state.data.userName,
                                style: context.textTheme.subtitle1?.copyWith(fontSize: 20.0, color: context.color.secondary),
                              ),
                              const TextSpan(text: "\n"),
                              TextSpan(
                                text: state.data.realPrice.toString(),
                                style: context.textTheme.headline3?.copyWith(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: "  ${LocaleKeys.SR.tr()}  ",
                                style: TextStyle(
                                  fontFamily: 'Somar',
                                  fontSize: 18.0,
                                  color: context.color.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (state.data.discountPercentage > 0)
                                TextSpan(
                                  text: "${state.data.priceBeforeDicount}  ${LocaleKeys.SR.tr()}",
                                  style: context.textTheme.subtitle2?.copyWith(
                                      fontFamily: 'Somar',
                                      fontSize: 17.0,
                                      color: const Color(0xFF958A7E),
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              const TextSpan(text: "\n"),
                              TextSpan(
                                text: LocaleKeys.Product_Code.tr(),
                                style: context.textTheme.subtitle1?.copyWith(
                                  fontSize: 18.0,
                                  color: const Color(0xFF958A7E),
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                              TextSpan(
                                text: ' ${state.data.id}',
                                style: context.textTheme.subtitle1?.copyWith(
                                  color: context.color.secondary,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                              const TextSpan(text: "         "),
                              TextSpan(
                                text: LocaleKeys.Quantity_available.tr(),
                                style: context.textTheme.subtitle1?.copyWith(
                                  fontSize: 18.0,
                                  color: const Color(0xFF958A7E),
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                              TextSpan(
                                text: ' ${state.data.quantity}',
                                style: context.textTheme.subtitle1?.copyWith(
                                  color: context.color.secondary,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.h),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: List.generate(
                        //     state.data.allColors.length,
                        //     (i) => Container(
                        //       margin: EdgeInsets.symmetric(horizontal: 5.w),
                        //       height: 20.h,
                        //       width: 20.h,
                        //       decoration: BoxDecoration(
                        //         color: state.data.allColors[i].hexValue.toColor,
                        //         borderRadius: BorderRadius.circular(5),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 25.h),
                        Row(
                          children: [
                            Text(state.data.desc, style: context.textTheme.bodyText1),
                          ],
                        ),
                        SizedBox(height: 18.h),
                        // ...List.generate(
                        //   4,
                        //   (index) => Row(
                        //     children: [
                        //       CustomNetworkImage(
                        //         "https://carss.cc/wp-content/uploads/2018/07/1783.jpg",
                        //         width: 41.h,
                        //         height: 41.h,
                        //         fit: BoxFit.cover,
                        //         borderRadius: BorderRadius.circular(1000),
                        //       ),
                        //       SizedBox(width: 20.w),
                        //       Column(
                        //         children: [
                        //           Row(
                        //             children: [
                        //               Text(
                        //                 'إسلام مجدي',
                        //                 style: context.textTheme.bodyText1,
                        //               ),
                        //               CustomStarBar(size: 15.h)
                        //             ],
                        //           )
                        //         ],
                        //       ),
                        //       Text.rich(
                        //         TextSpan(
                        //           children: [
                        //             TextSpan(
                        //               text: 'إسلام مجدي',
                        //               style: context.textTheme.bodyText1,
                        //             ),
                        //             const TextSpan(text: "\n"),
                        //             TextSpan(
                        //               text: 'بيت الأزياء منتجاته كلها متميزة',
                        //               style: context.textTheme.subtitle1,
                        //             ),
                        //           ],
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ).paddingOnly(top: 328.h),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  _deleteProduct(int id) {
    return CustomAlert.optionalDialog(
      btnMsg: LocaleKeys.delete.tr(),
      cancelText: LocaleKeys.retreat.tr(),
      onCancel: () => Navigator.pop(context),
      onClick: () {
        Navigator.pop(context);
        _deleteProductBloc.add(StartDeleteEvent("provider/products/$id", {"_method": "DELETE"}));
      },
      title: LocaleKeys.warning.tr(),
      msg: LocaleKeys.are_you_sure_to_delete_this_product.tr(),
    );
  }
}
