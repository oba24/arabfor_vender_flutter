import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../generated/locale_keys.g.dart';
import '../helper/extintions.dart';
// import '../helper/extintions.dart';

class CustomTextFailed extends StatelessWidget {
  final String hint;
  final String? label;
  final int? maxInput;
  final Widget? endIcon;
  final void Function()? onTap;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const CustomTextFailed({
    Key? key,
    required this.hint,
    this.label,
    this.keyboardType = TextInputType.name,
    this.controller,
    this.validator,
    this.endIcon,
    this.onTap,
    this.maxInput,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: TextFormField(
        enabled: onTap == null,
        controller: controller,
        keyboardType: keyboardType,
        validator: validator ??
            (v) {
              if (keyboardType == TextInputType.phone && !(v!.length >= 9)) {
                return LocaleKeys.the_phone_number_must_be_more_than_8_numbers
                    .tr();
              } else if (v != null && v.isEmpty) {
                return "$hint ${LocaleKeys.requerd.tr()}";
              }
              return null;
            },
        obscureText: keyboardType == TextInputType.visiblePassword,
        inputFormatters: [
          if (maxInput != null) LengthLimitingTextInputFormatter(maxInput),
        ],
        style: context.textTheme.subtitle2
            ?.copyWith(color: context.color.primary, fontSize: 16),
        decoration: InputDecoration(
          errorStyle: context.textTheme.subtitle2!
              .copyWith(color: Colors.red, fontSize: 12),
          suffixIcon: endIcon,
          hintText: hint,
          hintStyle: context.textTheme.subtitle2?.copyWith(fontSize: 16),
          label: Text(label ?? hint,
              style: context.textTheme.subtitle2!
                  .copyWith(color: context.color.primary)),
        ),
      ),
    );
  }
}
