import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimerchantsiller/common/loading_app.dart';
import 'package:saudimerchantsiller/helper/flash_helper.dart';
import 'package:saudimerchantsiller/view/profile/bloc/states.dart';
import '../../../common/alert.dart';
import '../../../common/btn.dart';
import '../../../common/custom_text_failed.dart';
import '../../../common/pick_location_map.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen_bloc/cities/bloc.dart';
import '../../../gen_bloc/cities/events.dart';
import '../../../gen_bloc/cities/states.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../helper/asset_image.dart';
import '../../../helper/extintions.dart';
import '../../../helper/image_picker.dart';
import '../../../helper/rout.dart';

import '../bloc/bloc.dart';
import '../bloc/events.dart';
import 'edit_password.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final StartUpdateProfileEvent _event = StartUpdateProfileEvent();
  final CitiesBloc _citiesBloc = KiwiContainer().resolve();
  final UpdateProfileBloc _bloc = KiwiContainer().resolve<UpdateProfileBloc>();

  final GlobalKey<FormState> _fKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.secondary,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: context.color.primaryContainer,
        title: Text(
          LocaleKeys.Edit_profile.tr(),
          style: context.textTheme.headline2!
              .copyWith(color: context.color.secondary),
          textAlign: TextAlign.center,
        ),
        // leading: IconButton(
        //   onPressed: () => Navigator.pop(context),
        //   icon: Icon(
        //     Icons.arrow_forward_ios_sharp,
        //     color: context.color.secondary,
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 29.h, horizontal: 24.w),
        child: Form(
          key: _fKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  2,
                  (i) {
                    var item = [_event.commercialRegisterImage, _event.logo][i];
                    return InkWell(
                      onTap: () => CustomImagePicker.openImagePicker(
                        onSubmit: (v) {
                          i == 1
                              ? _event.logo = v
                              : _event.commercialRegisterImage = v;
                          setState(() {});
                        },
                      ),
                      child: SizedBox(
                        height: 116.h,
                        width: 116.h,
                        child: Stack(
                          children: [
                            Builder(
                              builder: (context) {
                                if (item.path.startsWith("http")) {
                                  return CustomImage(
                                    item.path,
                                    height: 104.h,
                                    width: 104.h,
                                    border: Border.all(
                                        color: Colors.white, width: 2.w),
                                    borderRadius: BorderRadius.circular(1000),
                                  );
                                } else {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2.w),
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(1000),
                                      child: Image.file(
                                        item,
                                        height: 104.h,
                                        width: 104.h,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ).onCenter,
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: CustomImage(
                                Assets.svg.circleEdit,
                                height: 24.h,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 14.h),
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
              // CustomTextFailed(
              //   controller: TextEditingController(text: _event.city.name),
              //   keyboardType: TextInputType.name,
              //   hint: LocaleKeys.City.tr(),
              //   endIcon: Icon(Icons.arrow_forward_ios, color: context.color.secondary, size: 15.h),
              // ),
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
                    controller: TextEditingController(text: _event.city.name),
                    keyboardType: TextInputType.name,
                    onTap: () {
                      if (citiesState is! LoadingCitiesState) {
                        _citiesBloc.add(StartCitiesEvent());
                      }
                    },
                    hint: LocaleKeys.City.tr(),
                    endIcon: citiesState is LoadingCitiesState
                        ? CustomProgress(
                                size: 5, color: context.color.secondary)
                            .paddingAll(15.h)
                        : Icon(Icons.arrow_forward_ios,
                            color: context.color.primary, size: 15.h),
                  );
                },
              ),
              SizedBox(height: 14.h),
              CustomTextFailed(
                onTap: () {
                  push(PickLocationMap(
                    latLng: _event.latLng,
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
                    color: context.color.primary, size: 15.h),
              ),
              SizedBox(height: 46.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.password.tr(),
                    style: context.textTheme.headline4!
                        .copyWith(color: context.color.primary),
                  ),
                  IconButton(
                    onPressed: () => push(const EditPasswordView()),
                    icon: CustomImage(
                      Assets.svg.edit,
                      color: context.color.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 45.h),
              BlocConsumer(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is DoneUpdateProfileState) {
                    Phoenix.rebirth(context);
                    FlashHelper.successBar(message: state.msg);
                  } else if (state is FaildUpdateProfileState) {
                    FlashHelper.errorBar(message: state.msg);
                  }
                },
                builder: (context, snapshot) {
                  return Btn(
                    loading: snapshot is LoadingUpdateProfileState,
                    text: LocaleKeys.Save.tr(),
                    color: context.color.primary,
                    textColor: context.color.secondary,
                    onTap: () {
                      if (_fKey.currentState!.validate()) _bloc.add(_event);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
