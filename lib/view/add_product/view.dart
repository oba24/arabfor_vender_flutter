import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimerchantsiller/common/loading_app.dart';
import 'package:saudimerchantsiller/gen_bloc/categories/bloc.dart';
import 'package:saudimerchantsiller/gen_bloc/categories/events.dart';
import 'package:saudimerchantsiller/gen_bloc/categories/states.dart';
import 'package:saudimerchantsiller/helper/flash_helper.dart';
import 'package:saudimerchantsiller/view/add_product/bloc/states.dart';
import '../../common/btn.dart';
import '../../common/custom_text_failed.dart';
import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/asset_image.dart';
import '../../helper/extintions.dart';
import '../../helper/image_picker.dart';
import '../../helper/rout.dart';
import '../../models/image_model.dart';
import '../../models/product_model.dart';
import '../nav_bar/view.dart';
import '../../common/alert.dart';
import 'bloc/bloc.dart';
import 'bloc/events.dart';
import 'common/add_type_widget.dart';
import 'common/image_edit.dart';

class AddProductView extends StatefulWidget {
  final ProductDatum? data;
  const AddProductView({Key? key, this.data}) : super(key: key);

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late StartAddProductEvent _event;
  final CategoryBloc _categoryBloc = KiwiContainer().resolve<CategoryBloc>();
  final CategoryBloc _subCategoryBloc = KiwiContainer().resolve<CategoryBloc>();
  final AddProductBloc _bloc = KiwiContainer().resolve<AddProductBloc>();
  @override
  void initState() {
    _event = widget.data == null
        ? StartAddProductEvent()
        : StartAddProductEvent.buildFromModel(widget.data!);
    super.initState();
  }

  bool _back = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _back);
        return _back;
      },
      child: Scaffold(
        backgroundColor: context.color.secondaryContainer,
        appBar: AppBar(
          backgroundColor: context.color.primaryContainer,
          centerTitle: true,
          title: Text(
            widget.data == null
                ? LocaleKeys.add_product.tr()
                : LocaleKeys.edit_product.tr(),
            style: context.textTheme.headline2!
                .copyWith(color: context.color.secondary),
            textAlign: TextAlign.center,
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 127.h,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_event.images.length, (i) {
                        return ImageEditCard(
                          data: _event.images[i],
                          onDelete: () {
                            setState(() {
                              if (_event.images[i].id != 0) {
                                _back = true;
                              }
                              _event.images.removeAt(i);
                            });
                          },
                        );
                      })
                        ..add(
                          InkWell(
                            onTap: () {
                              CustomImagePicker.openImagePicker(onSubmit: (v) {
                                setState(() {
                                  _event.images.add(
                                      ImageDatum(file: v, id: 0, url: v.path));
                                });
                              });
                            },
                            child: Container(
                              width: 101.h,
                              height: 93.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: context.color.primary.withOpacity(0.3),
                                border: Border.all(
                                  width: 1.0,
                                  color: context.color.primary.withOpacity(0.8),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomImage(
                                    Assets.images.camiraIcon.path,
                                    height: 26.h,
                                    color: context.color.primary,
                                  ),
                                  Text(
                                    LocaleKeys.add_photo.tr(),
                                    style: context.textTheme.subtitle2!
                                        .copyWith(color: context.color.primary),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ).paddingSymmetric(horizontal: 8.w),
                          ),
                        ),
                    ),
                  ),
                ).paddingOnly(top: 32.h, bottom: 16.h),
                CustomTextFailed(
                  controller: _event.productName,
                  hint: LocaleKeys.product_name.tr(),
                ).paddingSymmetric(horizontal: 24.w, vertical: 14.h),
                CustomTextFailed(
                  controller: _event.descreption,
                  hint: LocaleKeys.product_description.tr(),
                ).paddingSymmetric(horizontal: 24.w, vertical: 14.h),
                BlocConsumer(
                  bloc: _categoryBloc,
                  listener: (context, state) {
                    if (state is DoneCategoryState) {
                      CustomAlert.selectOptionalSeetButton(
                        title: LocaleKeys.main_category.tr(),
                        items: state.data,
                        onSubmit: (v) {
                          setState(() {
                            _event.mainCategory = v;
                          });
                        },
                        item: _event.mainCategory,
                      );
                    } else if (state is FaildCategoryState) {
                      FlashHelper.errorBar(message: state.msg);
                    }
                  },
                  builder: (context, snapshot) {
                    return CustomTextFailed(
                      controller:
                          TextEditingController(text: _event.mainCategory.name),
                      hint: LocaleKeys.main_category.tr(),
                      onTap: () => _categoryBloc.add(StartCategoryEvent()),
                      endIcon: snapshot is LoadingCategoryState
                          ? CustomProgress(
                              size: 15.h, color: context.color.secondary)
                          : Icon(Icons.arrow_forward_ios,
                              color: context.color.secondary, size: 15.h),
                    ).paddingSymmetric(horizontal: 24.w, vertical: 14.h);
                  },
                ),
                BlocConsumer(
                  bloc: _subCategoryBloc,
                  listener: (context, state) {
                    if (state is DoneSubCategoryState) {
                      CustomAlert.selectOptionalSeetButton(
                        title: LocaleKeys.sub_category.tr(),
                        items: state.data,
                        onSubmit: (v) {
                          setState(() {
                            _event.subcategory = v;
                          });
                        },
                        item: _event.subcategory,
                      );
                    } else if (state is FaildCategoryState) {
                      FlashHelper.errorBar(message: state.msg);
                    }
                  },
                  builder: (context, snapshot) {
                    return CustomTextFailed(
                      onTap: () {
                        if (_event.mainCategory.id != 0) {
                          _subCategoryBloc.add(
                              StartSubCategoryEvent(_event.mainCategory.id));
                        } else {
                          FlashHelper.infoBar(
                              message: LocaleKeys
                                  .please_select_the_main_category_first
                                  .tr());
                        }
                      },
                      controller:
                          TextEditingController(text: _event.subcategory.name),
                      hint: LocaleKeys.sub_category.tr(),
                      endIcon: snapshot is LoadingCategoryState
                          ? SizedBox(
                              width: 5,
                              height: 5,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    context.color.secondary),
                              ).paddingAll(15.h),
                            )
                          : Icon(Icons.arrow_forward_ios,
                              color: context.color.secondary, size: 15.h),
                    ).paddingSymmetric(horizontal: 24.w, vertical: 14.h);
                  },
                ),
                CustomTextFailed(
                  controller: _event.priceBeforeDicount,
                  hint: LocaleKeys.Price_before_discount.tr(),
                  keyboardType: TextInputType.number,
                  endIcon: SizedBox(
                    width: 5,
                    child: Text(
                      LocaleKeys.SR.tr(),
                      style: context.textTheme.headline6,
                    ).onCenter,
                  ),
                ).paddingSymmetric(horizontal: 24.w, vertical: 14.h),
                Text(
                  LocaleKeys.types.tr(),
                  style: context.textTheme.headline3,
                ).paddingSymmetric(horizontal: 24.w),
                ...List.generate(
                  _event.productDetailDatum.length,
                  (i) => TypeWidget(
                    data: _event.productDetailDatum[i],
                    onRemove: () {
                      if (_event.productDetailDatum[i].id != 0) {
                        _back = true;
                      }
                      setState(() {
                        _event.productDetailDatum.removeAt(i);
                      });
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _event.productDetailDatum
                          .add(ProductDetailDatum.fromJson({}));
                    });
                  },
                  child: Text(LocaleKeys.add_type.tr(),
                      style: context.textTheme.bodyText1),
                ).onCenter,
                CustomTextFailed(
                  controller: _event.discountPercentage,
                  maxInput: 2,
                  validator: (v) {
                    if (v == "1") {
                      return LocaleKeys
                          .the_discount_ratio_should_not_be_less_than_1
                          .tr();
                    }
                    return null;
                  },
                  endIcon: SizedBox(
                      width: 5,
                      child: Text("%", style: context.textTheme.bodyText1)),
                  hint: LocaleKeys.discount_percentage.tr(),
                  keyboardType: TextInputType.number,
                ).paddingSymmetric(horizontal: 24.w, vertical: 14.h),
                CustomTextFailed(
                  controller: _event.quantity,
                  hint: LocaleKeys.quantity_available.tr(),
                  keyboardType: TextInputType.number,
                ).paddingSymmetric(horizontal: 24.w, vertical: 14.h),
                BlocConsumer(
                  bloc: _bloc,
                  listener: (context, state) {
                    if (state is DoneAddProductState) {
                      CustomAlert.succAlert(
                        widget.data == null
                            ? LocaleKeys.product_has_been_successfully_added
                                .tr()
                            : LocaleKeys
                                .the_product_has_been_successfully_modified
                                .tr(),
                        Btn(
                          text: LocaleKeys.Main.tr(),
                          onTap: () => push(const NavBarView(page: 0)),
                        ),
                      );
                    } else if (state is FaildAddProductState) {
                      FlashHelper.errorBar(message: state.msg);
                    }
                  },
                  builder: (context, snapshot) {
                    return Btn(
                      loading: snapshot is LoadingAddProductState,
                      color: context.color.primary,
                      textColor: context.color.secondary,
                      text: widget.data == null
                          ? LocaleKeys.add_product.tr()
                          : LocaleKeys.edit.tr(),
                      onTap: () {
                        if (_event.images.isEmpty) {
                          FlashHelper.infoBar(
                              message: LocaleKeys
                                  .add_a_picture_of_the_product_at_least
                                  .tr());
                        } else if (_formKey.currentState!.validate()) {
                          _bloc.add(_event);
                        }
                      },
                    ).paddingSymmetric(horizontal: 24.w, vertical: 24.h);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
