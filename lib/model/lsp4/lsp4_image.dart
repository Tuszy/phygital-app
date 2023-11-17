import 'package:ndef/utilities.dart';
import 'package:phygital/model/image.dart';
import 'package:phygital/model/lsp4/lsp4_verification.dart';
import 'package:phygital/model/lsp_image.dart';

class LSP4Image extends LSPImage {
  LSP4Image(
      {required int width,
      required int height,
      required String url,
      required this.verification}) : super(width: width, height: height, url: url);

  final LSP4Verification verification;

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'url': url,
      'verification': verification
    };
  }

  factory LSP4Image.fromJson(final Map<String, dynamic> data) {
    return LSP4Image(
      width: data["width"],
      height: data["height"],
      url: data["url"],
      verification: LSP4Verification.fromJson(data["verification"]),
    );
  }

  factory LSP4Image.fromImage(String url, Image compressedImage) {
    return LSP4Image(
        width: compressedImage.width,
        height: compressedImage.height,
        url: url,
        verification:
            LSP4Verification(data: "0x${compressedImage.hash.toHexString()}"));
  }
}
