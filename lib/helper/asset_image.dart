import 'package:flutter/material.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as provider;
import 'extintions.dart';

class CustomImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final double? opacity;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  const CustomImage(this.path,
      {Key? key,
      this.width,
      this.height,
      this.fit,
      this.color,
      this.opacity,
      this.border,
      this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (path.startsWith("http")) {
      return _CustomNetworkImage(path,
          height: height,
          width: width,
          opacity: opacity,
          border: border,
          fit: fit,
          borderRadius: borderRadius);
    } else if (path.startsWith("assets")) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(border: border, borderRadius: borderRadius),
          child: path.split(".").last.toLowerCase().contains("svg")
              ? SvgPicture.asset(
                  path,
                  height: height,
                  width: width,
                  color: color,
                  cacheColorFilter: false,
                  fit: fit ?? BoxFit.contain,
                )
              : Image.asset(
                  path,
                  height: height,
                  width: width,
                  color: color,
                  opacity: AlwaysStoppedAnimation(opacity ?? 1),
                  fit: fit ?? BoxFit.contain,
                ),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(.5)),
              borderRadius: borderRadius),
          child: Center(
            child: Icon(
              Icons.image_not_supported,
              color: Colors.grey.withOpacity(.5),
              size: 30.h,
            ),
          ),
        ),
      );
    }
  }
}

ImageProvider providerImage(String path, {double? height, double? width}) {
  if (path.split(".").last.toLowerCase().contains("svg")) {
    return provider.Svg(path);
  } else {
    return AssetImage(path);
  }
}

class CustomIconImg extends StatelessWidget {
  final String img;
  final double? size;
  final Color? color;

  const CustomIconImg(this.img, {Key? key, this.size, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageIcon(
      providerImage(img),
      color: color,
      size: size,
    );
  }
}

// Widget networkImage(String? url, {double? height, double? width, double? opacity, BoxFit? fit, BorderRadius? borderRadius}) {

// }

class _CustomNetworkImage extends StatelessWidget {
  final String? url;
  final double? height;
  final double? width;
  final double? opacity;
  final BoxBorder? border;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  const _CustomNetworkImage(this.url,
      {Key? key,
      this.height,
      this.width,
      this.opacity,
      this.fit,
      this.borderRadius,
      this.border})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CustomProductImage(
        height: height,
        width: width,
        opacity: opacity,
        fit: fit,
        border: border,
        borderRadius: borderRadius,
        image: url!,
      ),
    );
  }
}

class CustomProductImage extends StatelessWidget {
  final String image;
  final double? height, opacity, width;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  const CustomProductImage(
      {Key? key,
      required this.image,
      this.height,
      this.width,
      this.fit,
      this.borderRadius,
      this.opacity = 1,
      this.border})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.zero, border: border),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.network(
          image,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: ClipRRect(
                borderRadius: borderRadius ?? BorderRadius.zero,
                child: Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: borderRadius ?? BorderRadius.zero,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ),
            );
          },
          opacity: AlwaysStoppedAnimation<double>(opacity ?? 1),
          // height: height ?? double.infinity,
          // width: width ?? double.infinity,
          fit: fit ?? BoxFit.fill,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return ClipRRect(
                borderRadius: borderRadius ?? BorderRadius.zero,
                child: child,
              );
            }

            return Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                    borderRadius: borderRadius ?? BorderRadius.zero),
                child: const CircularProgressIndicator.adaptive().onCenter);
          },
        ),
      ),
    );
  }
}
