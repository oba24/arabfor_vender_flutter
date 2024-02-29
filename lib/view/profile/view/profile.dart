import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimerchantsiller/view/setting/contact_view.dart';
import 'package:saudimerchantsiller/view/setting/pages.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen_bloc/profile/bloc.dart';
import '../../../gen_bloc/profile/events.dart';
import '../../../gen_bloc/profile/states.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../helper/asset_image.dart';
import '../../../helper/extintions.dart';
import '../../../helper/flash_helper.dart';
import '../../../helper/rout.dart';
import '../../../helper/user_data.dart';
import 'package:share_plus/share_plus.dart';
import '../../../common/loading_app.dart';
import '../../product/view/products.dart';
import '../../setting/common_questions.dart';
import '../../setting/support_view.dart';
import '../../wallet/view.dart';
import 'update_profile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileBloc _logoutBloc = KiwiContainer().resolve<ProfileBloc>();
  final ProfileBloc _deleteBloc = KiwiContainer().resolve<ProfileBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.secondary,
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 50.h),
        children: [
          Row(
            children: [
              CustomImage(
                UserHelper.userDatum.logo,
                fit: BoxFit.fill,
                width: 78.h,
                height: 78.h,
                borderRadius: BorderRadius.circular(1000),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Text(
                  UserHelper.userDatum.userName,
                  style: context.textTheme.headline2,
                  textAlign: TextAlign.right,
                ),
              ),
              IconButton(
                  onPressed: () => push(const EditProfileView()),
                  icon: CustomImage(
                    Assets.svg.edit,
                    color: context.color.primary,
                  )),
            ],
          ).paddingSymmetric(horizontal: 32.w),
          SizedBox(height: 20.h),
          ListTile(
            onTap: () => push(const ProductsView()),
            title: Text(
              LocaleKeys.Products.tr(),
              style: context.textTheme.subtitle1!
                  .copyWith(color: context.color.primary),
              textAlign: TextAlign.right,
            ),
            leading: CustomImage(
              Assets.images.products.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                color: Color(0xFF007036)),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () => push(const WalletView()),
            title: Text(
              LocaleKeys.Portfolio.tr(),
              style: context.textTheme.subtitle1!
                  .copyWith(color: context.color.primary),
              textAlign: TextAlign.right,
            ),
            leading: CustomImage(
              Assets.images.walletIcon.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                color: Color(0xFF007036)),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () => push(const ContactView()),
            title: Text(
              LocaleKeys.Complaints_and_suggestions.tr(),
              style: context.textTheme.subtitle1!
                  .copyWith(color: context.color.primary),
              textAlign: TextAlign.right,
            ),
            leading: CustomImage(
              Assets.images.iconEditProfile.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                color: Color(0xFF007036)),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () => push(const SupportView()),
            title: Text(
              LocaleKeys.call_us.tr(),
              style: context.textTheme.subtitle1!
                  .copyWith(color: context.color.primary),
              textAlign: TextAlign.right,
            ),
            leading: CustomImage(
              Assets.images.callUs.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                color: Color(0xFF007036)),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () => push(PagesView(
                type: "terms", title: LocaleKeys.Terms_and_Conditions.tr())),
            title: Text(
              LocaleKeys.Terms_and_Conditions.tr(),
              style: context.textTheme.subtitle1!
                  .copyWith(color: context.color.primary),
              textAlign: TextAlign.right,
            ),
            leading: CustomImage(
              Assets.images.iconEditProfile.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                color: Color(0xFF007036)),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () => push(
                PagesView(type: "policy", title: LocaleKeys.Usage_policy.tr())),
            title: Text(
              LocaleKeys.Usage_policy.tr(),
              style: context.textTheme.subtitle1!
                  .copyWith(color: context.color.primary),
              textAlign: TextAlign.right,
            ),
            leading: CustomImage(
              Assets.images.iconEditProfile.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                color: Color(0xFF007036)),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () => push(const CommonQuestionsView()),
            title: Text(
              LocaleKeys.common_questions.tr(),
              style: context.textTheme.subtitle1!
                  .copyWith(color: context.color.primary),
              textAlign: TextAlign.right,
            ),
            leading: CustomImage(
              Assets.images.common_question.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                color: Color(0xFF007036)),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () => push(PagesView(
                type: "about", title: LocaleKeys.About_application.tr())),
            title: Text(
              LocaleKeys.About_application.tr(),
              style: context.textTheme.subtitle1!
                  .copyWith(color: context.color.primary),
              textAlign: TextAlign.right,
            ),
            leading: CustomImage(
              Assets.images.aboutApp.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                color: Color(0xFF007036)),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            title: Text(
              LocaleKeys.Evaluate_application.tr(),
              style: context.textTheme.subtitle1!
                  .copyWith(color: context.color.primary),
              textAlign: TextAlign.right,
            ),
            leading: CustomImage(
              Assets.images.starApp.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                color: Color(0xFF007036)),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () => Share.share(
                "يمكنك الان تحميل تطبيق عرب فور من العناوين الاتية\n\nِAndroid: https://play.google.com/store/apps/details?id=com.alalmiyalhura.saudimarchclient\n\nIos: https://apps.apple.com/us/app/%D8%B3%D8%B9%D9%88%D8%AF%D9%8A-%D9%85%D8%A7%D8%B1%D8%B4%D9%8A%D8%A9/id1629653278"),
            title: Text(
              LocaleKeys.Share_application.tr(),
              style: context.textTheme.subtitle1!
                  .copyWith(color: context.color.primary),
              textAlign: TextAlign.right,
            ),
            leading: CustomImage(
              Assets.images.shear.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                color: Color(0xFF007036)),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          if (Platform.isIOS)
            BlocConsumer(
                bloc: _deleteBloc,
                listener: (context, state) {
                  if (state is DoneLogoutState) {
                    FlashHelper.successBar(message: state.msg);
                  } else if (state is FaildProfileState) {
                    FlashHelper.errorBar(message: state.msg);
                  }
                },
                builder: (context, snapshot) {
                  return ListTile(
                    onTap: () =>
                        _deleteBloc.add(StartLogoutEvent('delete_account')),
                    title: Text(LocaleKeys.delete_account.tr(),
                        style: context.textTheme.subtitle1!
                            .copyWith(color: context.color.primary),
                        textAlign: TextAlign.right),
                    leading: CustomImage(Assets.images.deleteAccount.path,
                        height: 40.h),
                    trailing: snapshot is LoadingProfileState
                        ? CustomProgress(
                            size: 15.h, color: context.color.secondary)
                        : const Icon(Icons.arrow_forward_ios_rounded,
                            color: Color(0xFF007036)),
                  ).paddingSymmetric(horizontal: 24.w, vertical: 2.h);
                }),
          BlocConsumer(
              bloc: _logoutBloc,
              listener: (context, state) {
                if (state is DoneLogoutState) {
                  FlashHelper.successBar(message: state.msg);
                } else if (state is FaildProfileState) {
                  FlashHelper.errorBar(message: state.msg);
                }
              },
              builder: (context, snapshot) {
                return ListTile(
                  onTap: () => _logoutBloc.add(StartLogoutEvent('logout')),
                  title: Text(LocaleKeys.Logout.tr(),
                      style: context.textTheme.subtitle1!
                          .copyWith(color: context.color.primary),
                      textAlign: TextAlign.right),
                  leading:
                      CustomImage(Assets.images.iconExit.path, height: 40.h),
                  trailing: snapshot is LoadingProfileState
                      ? CustomProgress(
                          size: 15.h, color: context.color.secondary)
                      : const Icon(Icons.arrow_forward_ios_rounded,
                          color: Color(0xFF007036)),
                ).paddingSymmetric(horizontal: 24.w, vertical: 2.h);
              }),
        ],
      ),
    );
  }
}
