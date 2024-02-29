import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimerchantsiller/helper/flash_helper.dart';
import 'package:saudimerchantsiller/view/product/bloc/states.dart';
import '../../../common/failed_widget.dart';
import '../../../common/loading_app.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../helper/extintions.dart';
import '../../../helper/rout.dart';

import '../../../helper/asset_image.dart';
import '../bloc/bloc.dart';
import '../bloc/events.dart';
import 'single.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({Key? key}) : super(key: key);

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final ProductBloc _bloc = KiwiContainer().resolve<ProductBloc>();
  @override
  void initState() {
    _bloc.add(StartProductsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.secondary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.color.primaryContainer,
        centerTitle: true,
        title: Text(
          LocaleKeys.Products.tr(),
          style: context.textTheme.headline3!
              .copyWith(color: context.color.secondary),
        ),
        // leading: IconButton(
        //   onPressed: () => Navigator.pop(context),
        //   icon: Icon(
        //     Icons.arrow_forward_ios_sharp,
        //     color: context.color.secondary,
        //   ),
        // ),
      ),
      body: BlocConsumer(
          bloc: _bloc,
          listener: (context, state) {
            if (state is DoneProductsState && state.msg != "") {
              FlashHelper.errorBar(message: state.msg);
            }
          },
          builder: (context, state) {
            if (state is LoadingProductState) {
              return const LoadingApp();
            } else if (state is FaildProductState) {
              return FailedWidget(
                errType: state.errType,
                title: state.msg,
                onTap: () => _bloc.add(StartProductsEvent()),
              );
            } else if (state is DoneProductsState) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Wrap(
                  // alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.spaceBetween,
                  children: List.generate(
                    state.data.length,
                    (index) => InkWell(
                      onTap: () =>
                          push(SingleProductView(id: state.data[index].id))
                              .then((value) {
                        if (value == "delete") {
                          setState(() {
                            state.data.removeAt(index);
                          });
                        }
                      }),
                      child: SizedBox(
                        width: (context.w / 2) - 8.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImage(
                              state.data[index].mainImage.url,
                              width: (context.w / 2) - 8.w,
                              height: 240.h,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            SizedBox(height: 10.h),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: state.data[index].name,
                                    style: context.textTheme.headline3
                                        ?.copyWith(
                                            color: context.color.secondary,
                                            fontSize: 21),
                                  ),
                                  const TextSpan(text: "\n"),
                                  // TextSpan(
                                  //   text: state.msg,
                                  //   style: context.textTheme.bodyText1?.copyWith(color: "#958A7E".toColor),
                                  // ),
                                  // const TextSpan(text: "\n"),
                                  TextSpan(
                                    text:
                                        state.data[index].realPrice.toString(),
                                    style: context.textTheme.headline3,
                                  ),
                                  TextSpan(
                                    text: "  ${LocaleKeys.SR.tr()}  ",
                                    style: context.textTheme.subtitle2
                                        ?.copyWith(
                                            color: context.color.secondary),
                                  ),
                                  if (state.data[index].discountPercentage > 0)
                                    TextSpan(
                                      text:
                                          "${state.data[index].priceBeforeDicount}  ${LocaleKeys.SR.tr()}",
                                      style:
                                          context.textTheme.subtitle2?.copyWith(
                                        color: context.color.secondary,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 8.w, vertical: 14.h),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
    );
  }
}
