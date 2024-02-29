import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';

class CustomStarBar extends StatelessWidget {
  final double? size;
  final num? rate;
  final Function(double)? onRated;
  const CustomStarBar({Key? key, this.size, this.rate, this.onRated}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: RatingBar(
        itemSize: size ?? 40.h,
        ratingWidget: RatingWidget(
            full: const Icon(Icons.star_rate_rounded, color: Color(0xffF6CF00)),
            half: const Icon(Icons.star_half_rounded, color: Color(0xffF6CF00)),
            empty: const Icon(Icons.star_rate_rounded, color: Colors.white)),
        onRatingUpdate: onRated ?? (v) {},
        maxRating: 5,
        minRating: 0,
        ignoreGestures: onRated == null,
        initialRating: (rate ?? 0) + 0.00000,
        glowColor: const Color(0xffF6CF00),
        unratedColor: const Color(0xffF6CF00),
        allowHalfRating: true,
      ),
    );
  }
}
