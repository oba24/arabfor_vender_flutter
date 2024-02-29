import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kiwi/kiwi.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen_bloc/cities/states.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../helper/asset_image.dart';
import '../../../helper/extintions.dart';
import '../../../helper/rout.dart';
import 'bloc/states.dart';
import '../../../common/alert.dart';
import '../../../common/pick_location_map.dart';
import '../../../gen_bloc/cities/bloc.dart';
import '../../../gen_bloc/cities/events.dart';
import '../../../helper/flash_helper.dart';
import '../../../helper/image_picker.dart';
import '../../../common/btn.dart';
import '../../../common/custom_text_failed.dart';
import '../active_code/bloc/events.dart';
import '../active_code/view.dart';
import 'bloc/bloc.dart';
import 'bloc/events.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final StartRegisterEvent _event = StartRegisterEvent();
  final CitiesBloc _citiesBloc = KiwiContainer().resolve();
  final RegisterBloc _bloc = KiwiContainer().resolve();
  bool isAcceptedTerms = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primary,
      body: SingleChildScrollView(
        child: Form(
          key: _event.formKey,
          child: Column(
            children: [
              CustomImage(
                Assets.svg.artboardAr,
                height: 85.h,
                fit: BoxFit.fill,
              ).paddingOnly(top: 95.h, bottom: 46.h).onCenter,
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.h),
                    color: context.theme.primaryColor),
                child: Column(
                  children: [
                    Text(LocaleKeys.welcome.tr(),
                            style: context.textTheme.headline1)
                        .paddingOnly(top: 38.h, bottom: 14.h),
                    Text(
                      LocaleKeys
                              .Please_enter_the_following_data_to_create_a_new_account
                          .tr(),
                      style: context.textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ).paddingOnly(bottom: 27.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        2,
                        (index) => GestureDetector(
                          onTap: () =>
                              CustomImagePicker.openImagePicker(onSubmit: (v) {
                            setState(() {
                              index == 0
                                  ? _event.establishmentLogo = v
                                  : _event.commercialRegisterImage = v;
                            });
                          }),
                          child: Container(
                            width: 104.h,
                            height: 104.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: [
                                        _event.establishmentLogo,
                                        _event.commercialRegisterImage
                                      ][index] ==
                                      null
                                  ? null
                                  : DecorationImage(
                                      image: FileImage([
                                      _event.establishmentLogo,
                                      _event.commercialRegisterImage
                                    ][index]!)),
                              color: context.color.surface,
                            ),
                            child: Builder(builder: (context) {
                              // if ([_event.establishmentLogo, _event.commercialRegisterImage][index] != null) {
                              //   return Image.file([_event.establishmentLogo, _event.commercialRegisterImage][index]!);
                              // }
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomImage(
                                    Assets.images.camiraIcon.path,
                                    height: 30.h,
                                  ),
                                  Text(
                                    [
                                      LocaleKeys.Establishment_logo.tr(),
                                      LocaleKeys.Commercial_Register_Image.tr()
                                    ][index],
                                    style: context.textTheme.subtitle2,
                                    textAlign: TextAlign.center,
                                  ).paddingAll(5.h),
                                ],
                              );
                            }),
                          ).paddingSymmetric(horizontal: 17.w),
                        ),
                      ),
                    ),
                    const SizedBox(height: 27),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFailed(
                          controller: _event.facilityName,
                          keyboardType: TextInputType.name,
                          hint: LocaleKeys.Facility_Name.tr(),
                        ),
                        SizedBox(height: 14.h),
                        CustomTextFailed(
                          controller: _event.mobile,
                          keyboardType: TextInputType.phone,
                          hint: LocaleKeys.Mobile_number.tr(),
                        ),
                        SizedBox(height: 14.h),
                        CustomTextFailed(
                          controller: _event.email,
                          keyboardType: TextInputType.emailAddress,
                          hint: LocaleKeys.Email.tr(),
                        ),
                        SizedBox(height: 14.h),
                        CustomTextFailed(
                          controller: _event.establishmentActivity,
                          keyboardType: TextInputType.name,
                          hint: LocaleKeys.Establishment_Activity.tr(),
                        ),
                        SizedBox(height: 14.h),
                        BlocConsumer(
                          bloc: _citiesBloc,
                          listener: (context, citiesState) {
                            if (citiesState is DoneCitiesState) {
                              CustomAlert.selectOptionalSeetButton(
                                title: LocaleKeys.City.tr(),
                                items: citiesState.cities,
                                onSubmit: (v) {
                                  setState(() {
                                    _event.city = v;
                                  });
                                },
                                item: _event.city,
                              );
                            }
                          },
                          builder: (context, citiesState) {
                            return CustomTextFailed(
                              controller:
                                  TextEditingController(text: _event.city.name),
                              keyboardType: TextInputType.name,
                              onTap: () {
                                if (citiesState is! LoadingCitiesState) {
                                  _citiesBloc.add(StartCitiesEvent());
                                }
                              },
                              hint: LocaleKeys.City.tr(),
                              endIcon: citiesState is LoadingCitiesState
                                  ? SizedBox(
                                      width: 5,
                                      height: 5,
                                      child: CircularProgressIndicator.adaptive(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                context.color.secondary),
                                      ).paddingAll(15.h),
                                    )
                                  : Icon(Icons.arrow_forward_ios,
                                      color: context.color.tertiary,
                                      size: 15.h),
                            );
                          },
                        ),
                        SizedBox(height: 14.h),
                        CustomTextFailed(
                          onTap: () {
                            push(PickLocationMap(
                              onSelect: (String locationName, LatLng latLng) {
                                setState(() {
                                  _event.addressName.text = locationName;
                                  _event.latLng = latLng;
                                });
                              },
                            ));
                          },
                          controller: _event.addressName,
                          keyboardType: TextInputType.name,
                          hint: LocaleKeys.Location_on_the_map.tr(),
                          endIcon: Icon(Icons.arrow_forward_ios,
                              color: context.color.tertiary, size: 15.h),
                        ),
                        SizedBox(height: 14.h),
                        CustomTextFailed(
                          controller: _event.password,
                          keyboardType: TextInputType.visiblePassword,
                          hint: LocaleKeys.password.tr(),
                        ),
                        SizedBox(height: 14.h),
                        CustomTextFailed(
                          controller: _event.confirmPassword,
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "${LocaleKeys.confirm_password.tr()} ${LocaleKeys.requerd.tr()}";
                            } else if (v != _event.password.text) {
                              return LocaleKeys.The_passwords_are_not_identical
                                  .tr();
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          hint: LocaleKeys.confirm_password.tr(),
                        ),
                        SizedBox(height: 42.h),
                      ],
                    ).paddingSymmetric(horizontal: 25.w),
                  ],
                ),
              ).paddingSymmetric(horizontal: 11.w),
              SizedBox(height: 27.h),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isAcceptedTerms = !isAcceptedTerms;
                      });
                    },
                    icon: Icon(
                      isAcceptedTerms
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: context.color.secondary,
                    ),
                  ),
                  Text(
                    LocaleKeys.I_agree_with_the_terms_and_conditions.tr(),
                    style: context.textTheme.subtitle1!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ).paddingSymmetric(horizontal: 24.w),
              SizedBox(height: 29.h),
              BlocConsumer(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is DoneRegisterState) {
                    push(ActiveCodeView(
                        event: StartActiveCodeEvent(
                            type: TYPE.register, mobile: _event.mobile)));
                  } else if (state is FaildRegisterState) {
                    FlashHelper.errorBar(message: state.msg);
                  }
                },
                builder: (context, state) {
                  return Btn(
                    loading: state is LoadingRegisterState,
                    text: LocaleKeys.Create_an_account.tr(),
                    textColor: context.color.primary,
                    onTap: () {
                      if (_event.establishmentLogo == null) {
                        FlashHelper.infoBar(
                            message:
                                "${LocaleKeys.Establishment_logo.tr()} ${LocaleKeys.requerd.tr()}");
                      } else if (_event.commercialRegisterImage == null) {
                        FlashHelper.infoBar(
                            message:
                                "${LocaleKeys.Commercial_Register_Image.tr()} ${LocaleKeys.requerd.tr()}");
                      } else if (!isAcceptedTerms) {
                        FlashHelper.infoBar(
                            message: LocaleKeys
                                    .The_terms_and_conditions_must_be_approved
                                .tr());
                      } else if (_event.formKey.currentState!.validate()) {
                        _bloc.add(_event);
                      }
                    },
                  ).paddingSymmetric(horizontal: 24.w);
                },
              ),
              SizedBox(height: 30.h),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: LocaleKeys.You_have_already_account.tr(),
                          style: context.textTheme.subtitle1),
                      const TextSpan(text: " "),
                      TextSpan(
                        text: LocaleKeys.Login.tr(),
                        style: context.textTheme.headline5
                            ?.copyWith(color: context.color.secondary),
                      ),
                    ],
                  ),
                ).paddingSymmetric(vertical: 8.h),
              ),
              SizedBox(height: 56.h),
            ],
          ),
        ),
      ),
    );
  }
}
