import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimerchantsiller/gen_bloc/delete/bloc.dart';
import 'package:saudimerchantsiller/gen_bloc/delete/events.dart';
import 'package:saudimerchantsiller/gen_bloc/delete/states.dart';
import 'package:saudimerchantsiller/helper/extintions.dart';
import 'package:saudimerchantsiller/helper/flash_helper.dart';
import 'package:saudimerchantsiller/models/image_model.dart';

import '../../../helper/asset_image.dart';

class ImageEditCard extends StatefulWidget {
  final ImageDatum data;
  final Function onDelete;
  const ImageEditCard({Key? key, required this.data, required this.onDelete}) : super(key: key);

  @override
  State<ImageEditCard> createState() => _ImageEditCardState();
}

class _ImageEditCardState extends State<ImageEditCard> {
  final DeleteBloc _deleteImageBloc = KiwiContainer().resolve<DeleteBloc>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Builder(
          builder: (context) {
            if (widget.data.file.path.startsWith("http")) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10.h),
                child: CustomImage(
                  widget.data.file.path,
                  height: 127.h,
                  fit: BoxFit.fill,
                  width: 137.w,
                ),
              ).paddingSymmetric(horizontal: 8.w);
            } else {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10.h),
                child: Image.file(
                  widget.data.file,
                  height: 127.h,
                  fit: BoxFit.fill,
                  width: 137.w,
                ),
              ).paddingSymmetric(horizontal: 8.w);
            }
          },
        ),
        BlocConsumer(
          bloc: _deleteImageBloc,
          listener: (context, state) {
            if (state is DoneDeleteState) {
              setState(() {
                widget.onDelete();
              });
            } else if (state is FaildDeleteState) {
              FlashHelper.errorBar(message: state.msg);
            }
          },
          builder: (context, state) {
            if (state is LoadingDeleteState) {
              return SizedBox(
                height: 18.w,
                width: 18.w,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ).paddingSymmetric(horizontal: 12.w, vertical: 5);
            }
            return InkWell(
              onTap: () {
                if (widget.data.file.path.startsWith("http")) {
                  _deleteImageBloc.add(StartDeleteEvent("provider/products/deleteImage/${widget.data.id}", {"_method": "DELETE"}));
                } else {
                  setState(() {
                    widget.onDelete();
                  });
                }
              },
              child: const Icon(
                Icons.highlight_off,
                color: Colors.white,
              ).paddingSymmetric(horizontal: 12.w, vertical: 5),
            );
          },
        )
      ],
    );
  }
}
