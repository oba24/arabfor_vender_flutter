import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/asset_image.dart';
import '../../helper/extintions.dart';

class OrderCard extends StatelessWidget {
  final int id;
  final String date;
  final double price;
  final String status;
  final void Function()? onTap;
  final Color statusColor;
  final List<String> images;

  const OrderCard({
    Key? key,
    required this.id,
    required this.date,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.images,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.only(start: 11.w, end: 13.w, top: 11.h, bottom: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color(0xFFF7F5EF),
          border: Border.all(
            width: 1.0,
            color: "#43290A".toColor.withOpacity(0.05),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: LocaleKeys.order_num.tr(),
                        style: context.textTheme.headline4,
                      ),
                      TextSpan(
                        text: "  ",
                        style: context.textTheme.subtitle1,
                      ),
                      TextSpan(
                        text: "#$id",
                        style: context.textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                Text(
                  date,
                  style: context.textTheme.bodyText1?.copyWith(color: "#929292".toColor),
                ),
              ],
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: price.toString(),
                    style: context.textTheme.headline2?.copyWith(color: "#00C569".toColor),
                  ),
                  TextSpan(
                    text: "  ${LocaleKeys.SR.tr()}",
                    style: context.textTheme.subtitle2?.copyWith(color: "#00C569".toColor),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  status,
                  style: context.textTheme.subtitle1?.copyWith(color: statusColor),
                ),
                const Spacer(),
                ...List.generate(
                  images.length >= 2 ? 2 : images.length,
                  (index) => CustomImage(
                    images[index],
                    borderRadius: BorderRadius.circular(10.0),
                    fit: BoxFit.fill,
                    width: 50.h,
                    height: 50.h,
                  ).paddingSymmetric(horizontal: 2.w),
                ),
                if (images.length > 2)
                  Container(
                    width: 50.h,
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(images[2]),
                        fit: BoxFit.fill,
                        opacity: 0.5,
                      ),
                      border: Border.all(
                        color: context.color.secondary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (images.length - 2).toString(),
                          style: context.textTheme.caption?.copyWith(
                            fontSize: 15,
                            color: context.color.secondary,
                          ),
                        ),
                        Icon(
                          Icons.add,
                          size: 15.h,
                          color: context.color.secondary,
                        ),
                      ],
                    ),
                  ).paddingSymmetric(horizontal: 2.w),
              ],
            )
          ],
        ),
      ),
    );
  }
}
