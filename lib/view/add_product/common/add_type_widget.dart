import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimerchantsiller/gen_bloc/delete/bloc.dart';
import 'package:saudimerchantsiller/gen_bloc/delete/events.dart';
import 'package:saudimerchantsiller/gen_bloc/delete/states.dart';
import 'package:saudimerchantsiller/helper/extintions.dart';
import 'package:saudimerchantsiller/models/product_model.dart';

import '../../../common/alert.dart';
import '../../../common/custom_text_failed.dart';
import '../../../gen_bloc/categories/states.dart';
import '../../../gen_bloc/colors/bloc.dart';
import '../../../gen_bloc/colors/events.dart';
import '../../../gen_bloc/colors/states.dart';
import '../../../gen_bloc/sizes/bloc.dart';
import '../../../gen_bloc/sizes/events.dart';
import '../../../gen_bloc/sizes/states.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../helper/flash_helper.dart';

class TypeWidget extends StatefulWidget {
  final ProductDetailDatum data;
  final Function onRemove;
  const TypeWidget({Key? key, required this.data, required this.onRemove})
      : super(key: key);

  @override
  State<TypeWidget> createState() => _TypeWidgetState();
}

class _TypeWidgetState extends State<TypeWidget> {
  final ColorsBloc _colorsBloc = KiwiContainer().resolve<ColorsBloc>();
  final SizesBloc _sizesBloc = KiwiContainer().resolve<SizesBloc>();
  final DeleteBloc _deleteBloc = KiwiContainer().resolve<DeleteBloc>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        border: Border.all(color: context.color.secondary.withOpacity(.1)),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: BlocConsumer(
              bloc: _deleteBloc,
              listener: (context, state) {
                if (state is DoneDeleteState) {
                  widget.onRemove();
                } else if (state is FaildDeleteState) {
                  FlashHelper.errorBar(message: state.msg);
                }
              },
              builder: (context, state) {
                if (state is LoadingDeleteState) {
                  return SizedBox(
                    height: 18.w,
                    width: 18.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ).paddingOnly(top: 5.h);
                }
                return InkWell(
                    onTap: () {
                      if (widget.data.id != 0) {
                        _deleteBloc.add(StartDeleteEvent(
                            "provider/products/delete_product_details",
                            {"product_detail_id": widget.data.id}));
                      } else {
                        widget.onRemove();
                      }
                    },
                    child: const Icon(Icons.close).paddingOnly(top: 5.h));
              },
            ),
          ),
          BlocConsumer(
            bloc: _colorsBloc,
            listener: (context, state) {
              if (state is DoneColorsState) {
                CustomAlert.selectOptionalSeetButton(
                  title: LocaleKeys.colors.tr(),
                  trailing: List.generate(
                    state.data.length,
                    (i) => Container(
                      margin: EdgeInsetsDirectional.only(end: 8.w),
                      height: 20.h,
                      width: 20.h,
                      decoration: BoxDecoration(
                          color: state.data[i].hexValue.toColor,
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  items: state.data,
                  onSubmit: (v) {
                    setState(() {
                      widget.data.color = v;
                    });
                  },
                  item: widget.data.color,
                );
              } else if (state is FaildCategoryState) {
                FlashHelper.errorBar(message: state.msg);
              }
            },
            builder: (context, snapshot) {
              return CustomTextFailed(
                controller: TextEditingController(text: widget.data.color.name),
                onTap: () {
                  if (snapshot is! LoadingColorsState)
                    _colorsBloc.add(StartColorsEvent());
                },
                hint: LocaleKeys.colors.tr(),
                keyboardType: TextInputType.number,
                endIcon: Builder(
                  builder: (context) {
                    if (snapshot is LoadingColorsState) {
                      return SizedBox(
                        width: 5,
                        height: 5,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              context.color.secondary),
                        ).paddingAll(15.h),
                      );
                    } else if (widget.data.color.id != 0) {
                      return Container(
                        margin: EdgeInsetsDirectional.only(end: 8.w),
                        height: 15.w,
                        width: 15.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: widget.data.color.hexValue.toColor,
                            borderRadius: BorderRadius.circular(4)),
                      ).paddingOnly(top: 25.h, left: 8.w, right: 8.w);
                    } else {
                      return Icon(Icons.arrow_forward_ios,
                          color: context.color.secondary, size: 15.h);
                    }
                  },
                ),
              ).paddingSymmetric(vertical: 14.h);
            },
          ),
          BlocConsumer(
            bloc: _sizesBloc,
            listener: (context, state) {
              if (state is DoneSizesState) {
                CustomAlert.selectOptionalSeetButton(
                  title: LocaleKeys.sizes.tr(),
                  trailing: List.generate(
                    state.data.length,
                    (i) => Container(
                      margin: EdgeInsetsDirectional.only(end: 8.w),
                      height: 20.h,
                      width: 20.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: context.color.secondary,
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        state.data[i].abbreviation,
                        style: context.textTheme.subtitle1
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  items: state.data,
                  onSubmit: (v) {
                    setState(() {
                      widget.data.size = v;
                    });
                  },
                  item: widget.data.size,
                );
              } else if (state is FaildSizesState) {
                FlashHelper.errorBar(message: state.msg);
              }
            },
            builder: (context, snapshot) {
              return CustomTextFailed(
                controller: TextEditingController(text: widget.data.size.name),
                onTap: () {
                  if (snapshot is! LoadingSizesState)
                    _sizesBloc.add(StartSizesEvent());
                },
                hint: LocaleKeys.sizes.tr(),
                endIcon: Builder(
                  builder: (context) {
                    if (snapshot is LoadingSizesState) {
                      return SizedBox(
                        width: 5,
                        height: 5,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              context.color.secondary),
                        ).paddingAll(15.h),
                      );
                    } else if (widget.data.size.id != 0) {
                      return Container(
                        margin: EdgeInsetsDirectional.only(end: 8.w),
                        height: 15.w,
                        width: 15.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: context.color.secondary,
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          widget.data.size.abbreviation,
                          style: context.textTheme.subtitle1
                              ?.copyWith(color: Colors.white),
                        ),
                      ).paddingOnly(top: 25.h, left: 8.w, right: 8.w);
                    } else {
                      return Icon(Icons.arrow_forward_ios,
                          color: context.color.secondary, size: 15.h);
                    }
                  },
                ),
              ).paddingSymmetric(vertical: 14.h);
            },
          ),
        ],
      ),
    );
  }
}
