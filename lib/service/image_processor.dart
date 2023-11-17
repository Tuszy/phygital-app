import 'dart:async';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:phygital/util/lsp2_utils.dart';
import 'dart:io';

import '../model/compressed_image.dart';

class ImageProcessor extends ChangeNotifier {
  static const int compressThresholdWidth = 1280;
  static const int compressThresholdHeight = 1280;
  static const int compressQuality = 90;

  static const String pngExtension = "png";
  static const String jpegExtension = "jpeg";

  ImageProcessor._sharedInstance();

  static final ImageProcessor _shared = ImageProcessor._sharedInstance();

  factory ImageProcessor() => _shared;

  MediaType? getMediaType(File file) {
    String? mimeType = lookupMimeType(file.path);
    return mimeType != null ? MediaType.parse(mimeType) : null;
  }

  Future<CompressedImage?> compress(File file) async {
    MediaType? mediaType = getMediaType(file);
    if (mediaType == null ||
        (!mediaType.mimeType.endsWith(pngExtension) && !mediaType.mimeType.endsWith(jpegExtension))) {
      return null;
    }

    Size size = ImageSizeGetter.getSize(FileInput(file));

    if (size.width > compressThresholdWidth ||
        size.height > compressThresholdHeight) {
      bool isPng = mediaType.mimeType.endsWith(pngExtension);
      XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          "${file.absolute.path}-temp.${isPng ? pngExtension : jpegExtension}",
          format: isPng ? CompressFormat.png : CompressFormat.jpeg,
          minHeight: compressThresholdHeight,
          minWidth: compressThresholdWidth,
          quality: compressQuality);
      if (compressedFile == null) return null;

      size = ImageSizeGetter.getSize(FileInput(File(compressedFile.path)));
      Uint8List bytes = await compressedFile.readAsBytes();
      Uint8List hash = LSP2Utils().hashBytes(bytes);
      return CompressedImage(bytes: bytes, width: size.width, height: size.height, mediaType: mediaType, hash: hash);
    } else {
      Uint8List bytes = await file.readAsBytes();
      Uint8List hash = LSP2Utils().hashBytes(bytes);
      return CompressedImage(bytes: bytes, width: size.width, height: size.height, mediaType: mediaType, hash: hash);
    }
  }
}
