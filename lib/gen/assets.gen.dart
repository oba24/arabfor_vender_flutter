/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  AssetGenImage get iconEditProfile =>
      const AssetGenImage('assets/images/Icon_Edit-Profile.png');
  AssetGenImage get iconExit =>
      const AssetGenImage('assets/images/Icon_Exit.png');
  AssetGenImage get iconMasterCard =>
      const AssetGenImage('assets/images/Icon_MasterCard.png');
  AssetGenImage get iconSearch =>
      const AssetGenImage('assets/images/Icon_Search.png');
  AssetGenImage get aboutApp =>
      const AssetGenImage('assets/images/about_app.png');
  AssetGenImage get callUs => const AssetGenImage('assets/images/call_us.png');
  AssetGenImage get camiraIcon =>
      const AssetGenImage('assets/images/camira_icon.png');
  AssetGenImage get cash => const AssetGenImage('assets/images/cash.png');
  AssetGenImage get deleteAccount =>
      const AssetGenImage('assets/images/delete_account.png');
  AssetGenImage get products =>
      const AssetGenImage('assets/images/products.png');
  AssetGenImage get common_question =>
      const AssetGenImage('assets/images/common_question.png');
  AssetGenImage get shear => const AssetGenImage('assets/images/shear.png');
  AssetGenImage get splashDown =>
      const AssetGenImage('assets/images/splash_down.png');
  AssetGenImage get splashUp =>
      const AssetGenImage('assets/images/splash_up.png');
  AssetGenImage get starApp =>
      const AssetGenImage('assets/images/star_app.png');
  AssetGenImage get wallet => const AssetGenImage('assets/images/wallet.png');
  AssetGenImage get walletIcon =>
      const AssetGenImage('assets/images/wallet_icon.png');
}

class $AssetsLangsGen {
  const $AssetsLangsGen();

  String get arSA => 'assets/langs/ar-SA.json';
  String get enUS => 'assets/langs/en-US.json';
}

class $AssetsLoattieGen {
  const $AssetsLoattieGen();

  String get error => 'assets/loattie/error.json';
  String get loadingBtn => 'assets/loattie/loading_btn.json';
  String get networkError => 'assets/loattie/network_error.json';
  String get worn => 'assets/loattie/worn.json';
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  String get addIcon => 'assets/svg/ADD_ICON.svg';
  String get iconFeatherHome => 'assets/svg/Icon feather-home.svg';
  String get iconAlert => 'assets/svg/Icon_Alert.svg';
  String get iconSearch => 'assets/svg/Icon_Search.svg';
  String get iconUser => 'assets/svg/Icon_User.svg';
  String get iconAwesomeDirections => 'assets/svg/Icon_awesome_directions.svg';
  String get camiraIcon => 'assets/svg/camira_icon.svg';
  String get circleEdit => 'assets/svg/circle_edit.svg';
  String get deleteProduct => 'assets/svg/delete_product.svg';
  String get edit => 'assets/svg/edit.svg';
  String get editProduct => 'assets/svg/edit_product.svg';
  String get email => 'assets/svg/email.svg';
  String get facebook => 'assets/svg/facebook.svg';
  String get homeLogo => 'assets/svg/home_logo.svg';
  String get artboardAr => 'assets/svg/Artboard_ar.svg';
  String get instgram => 'assets/svg/instgram.svg';
  String get location => 'assets/svg/location.svg';
  String get logo => 'assets/svg/logo.svg';
  String get orders => 'assets/svg/orders.svg';
  String get phone => 'assets/svg/phone.svg';
  String get sucss => 'assets/svg/sucss.svg';
  String get twitter => 'assets/svg/twitter.svg';
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLangsGen langs = $AssetsLangsGen();
  static const $AssetsLoattieGen loattie = $AssetsLoattieGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
