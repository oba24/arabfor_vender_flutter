import 'dart:io';
// import 'package:file_picker/file_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:saudimerchantsiller/generated/locale_keys.g.dart';
import 'package:saudimerchantsiller/helper/extintions.dart';
import 'package:saudimerchantsiller/helper/rout.dart';

class CustomImagePicker {
  static openGallery(Function(List<File> fils) onGet,
      {bool isFile = false}) async {
    List<File> _fils = [];
    if (isFile) {
      // FilePickerResult result = await FilePicker.platform.pickFiles(
      //   allowMultiple: true,
      //   type: FileType.custom,
      //   allowedExtensions: ['pdf', 'doc'],
      // );

      // if (result != null) {
      //   _fils = result.paths.map((path) => File(path)).toList();
      // }
    } else {
      // List<Asset> resultList = await MultiImagePicker.pickImages(maxImages: 5, enableCamera: false);

      // for (int i = 0; i < resultList.length; i++) {
      //   var path = await FlutterAbsolutePath.getAbsolutePath(resultList[i].identifier);
      //   _fils.add(File(path));
      // }
    }

    onGet(_fils);
  }

  static dynamic openImagePicker(
      {required Function(File file) onSubmit,
      Function(List<File> fils)? onMuiltySubmit,
      bool withCrop = false,
      bool withFile = false}) {
    FocusScope.of(navigator.currentContext!).unfocus();
    ImagePicker _pick = ImagePicker();

    showCupertinoModalPopup(
      context: navigator.currentContext!,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          cancelButton: CupertinoButton(
            child: Text(LocaleKeys.Cancel.tr(),
                style: context.textTheme.subtitle1!
                    .copyWith(color: context.color.secondary, fontSize: 20)),
            onPressed: () => Navigator.of(context).pop(),
            color: context.color.primary,
          ),
          actions: <Widget>[
            CupertinoButton(
              child: Row(
                children: <Widget>[
                  Icon(CupertinoIcons.photo_camera_solid,
                      color: context.color.primary),
                  const SizedBox(width: 20),
                  Text(LocaleKeys.Camera.tr(),
                      style: context.textTheme.subtitle1!
                          .copyWith(color: context.color.primary)),
                ],
              ),
              onPressed: () async {
                XFile? pickedFile = await _pick.pickImage(
                    source: ImageSource.camera, maxWidth: 400);
                File _filePicked = File(pickedFile!.path);
                if (withCrop == true) {
                  ImageCropper cropper = ImageCropper();
                  _filePicked = (await cropper.cropImage(
                    sourcePath: pickedFile.path,
                    aspectRatioPresets: [CropAspectRatioPreset.square],
                    androidUiSettings: AndroidUiSettings(
                      toolbarTitle: 'Cropper',
                      toolbarWidgetColor: Colors.white,
                      toolbarColor: context.color.secondary,
                      hideBottomControls: true,
                      initAspectRatio: CropAspectRatioPreset.original,
                    ),
                    iosUiSettings: const IOSUiSettings(minimumAspectRatio: 1.0),
                  ))!;
                }
                // if (_filePicked != null) {
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
                onSubmit(_filePicked);
                // }
              },
            ),
            CupertinoButton(
              child: Row(
                children: <Widget>[
                  Icon(Icons.insert_photo, color: context.color.primary),
                  const SizedBox(width: 20),
                  Text(LocaleKeys.Gallery.tr(),
                      style: context.textTheme.subtitle1!
                          .copyWith(color: context.color.primary)),
                ],
              ),
              onPressed: () async {
                XFile? pickedFile = await _pick.pickImage(
                    source: ImageSource.gallery, maxWidth: 400);
                File? _filePicked = File(pickedFile!.path);
                if (withCrop == true) {
                  ImageCropper cropper = ImageCropper();
                  _filePicked = await cropper.cropImage(
                    sourcePath: pickedFile.path,
                    aspectRatioPresets: [CropAspectRatioPreset.square],
                    androidUiSettings: AndroidUiSettings(
                      toolbarTitle: 'Cropper',
                      toolbarColor: context.color.secondary,
                      toolbarWidgetColor: Colors.white,
                      hideBottomControls: true,
                      initAspectRatio: CropAspectRatioPreset.original,
                    ),
                    iosUiSettings: const IOSUiSettings(minimumAspectRatio: 1.0),
                  );
                }
                Navigator.pop(context);
                FocusScope.of(context).unfocus();

                onSubmit(_filePicked!);
              },
            ),
            // if (withFile)
            //   CupertinoButton(
            //     child: Row(
            //       children: <Widget>[
            //         Icon(Icons.attach_file_rounded, color: context.color.primary),
            //         const SizedBox(width: 20),
            //         Text(
            //           navigator.currentContext.locale.languageCode == "en" ? "File" : "ملف",
            //           style: regularStyle.copyWith(
            //             color: primaryColor,
            //             fontSize: 15,
            //           ),
            //         ),
            //       ],
            //     ),
            //     onPressed: () async {
            //       FilePickerResult result = await FilePicker.platform.pickFiles(
            //         allowMultiple: false,
            //         type: FileType.custom,
            //         allowedExtensions: ['pdf', 'doc'],
            //       );

            //       if (result != null) {
            //         Navigator.pop(context);
            //         FocusScope.of(context).unfocus();
            //         onSubmit(File(result.files.first.path));
            //       }
            //     },
            //   ),
          ],
        );
      },
    );
  }
}
