import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/asset_image.dart';
import '../../helper/extintions.dart';
import '../../helper/rout.dart';

import '../add_product/view.dart';
import '../home/view.dart';
import '../notification/view.dart';
import '../orders/view.dart';
import '../profile/view/profile.dart';

class NavBarView extends StatefulWidget {
  final int? page;
  const NavBarView({Key? key, this.page}) : super(key: key);

  @override
  State<NavBarView> createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> {
  late int _pageRoute;
  @override
  void initState() {
    _pageRoute = widget.page ?? 0;
    super.initState();
  }

  final List<Widget> _roouts = const [
    HomeView(),
    OrdersView(),
    Center(),
    NotificationView(),
    ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _roouts[_pageRoute],
      backgroundColor: context.color.secondary,
      bottomNavigationBar: Container(
        height: 84.0.h,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
          color: context.color.primary,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 19, 10, 10).withOpacity(0.05),
              offset: const Offset(0, -1.0),
              blurRadius: 20.0,
            ),
          ],
        ),
        child: Row(
          children: List.generate(
            5,
            (index) => Expanded(
              child: AnimatedSwitcher(
                duration: 200.milliseconds,
                child: _pageRoute == index && index != 2
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            [
                              LocaleKeys.Main.tr(),
                              LocaleKeys.My_requests.tr(),
                              "",
                              LocaleKeys.Notifications.tr(),
                              LocaleKeys.Profile.tr(),
                            ][index],
                            style: context.textTheme.headline6!.copyWith(
                                height: 1, color: context.color.secondary),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            height: 3.h,
                            width: 3.h,
                            decoration: BoxDecoration(
                                color: context.color.secondary,
                                shape: BoxShape.circle),
                          )
                        ],
                      )
                    : IconButton(
                        onPressed: () {
                          if (index == 2) {
                            push(const AddProductView());
                          } else {
                            setState(() {
                              _pageRoute = index;
                            });
                          }
                        },
                        iconSize: index == 2 ? 50.h : 20.h,
                        icon: CustomImage(
                          [
                            Assets.svg.iconFeatherHome,
                            Assets.svg.orders,
                            Assets.svg.addIcon,
                            Assets.svg.iconAlert,
                            Assets.svg.iconUser,
                          ][index],
                        ),
                        color: context.color.secondary,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
