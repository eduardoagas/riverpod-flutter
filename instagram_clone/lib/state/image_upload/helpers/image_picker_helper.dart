import 'dart:io';

import 'package:flutter/foundation.dart' show immutable;
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/state/image_upload/extensions/to_file.dart';
//import 'package:instagram_clone/state/image_upload/extensions/to_file.dart';
import 'package:image_picker_web/image_picker_web.dart';

@immutable
class ImagePickerHelper {
  static final ImagePicker _imagePicker = ImagePicker();

  /*static Future<String?> pickImageFromGalleryWeb() async {
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }*/

  static Future<MediaInfo?> pickImageFromGalleryWeb() async {
    final fileInfo = await ImagePickerWeb.getImageInfo; //get image
    return fileInfo;
  }

  static Future<XFile?> pickImageFromGallery() =>
      _imagePicker.pickImage(source: ImageSource.gallery);
  //_imagePicker.pickImage(source: ImageSource.gallery).toFile();

  static Future<File?> pickVideoFromGallery() =>
      //_imagePicker.pickVideo(source: ImageSource.gallery);
      _imagePicker.pickVideo(source: ImageSource.gallery).toFile();
}
