import 'package:ndef/utilities.dart';
import 'package:phygital/model/image.dart';
import 'package:phygital/model/lsp_image.dart';

class LSP3Image extends LSPImage{
  LSP3Image(
      {required int width,
      required int height,
      required String url,
      required this.hash,
      this.hashFunction = "keccak256(bytes)"}) : super(width: width, height: height, url: url);

  final String hash;
  final String hashFunction;

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'url': url,
      'hash': hash,
      'hashFunction': hashFunction
    };
  }

  factory LSP3Image.fromJson(final Map<String, dynamic> data) {
    return LSP3Image(
      width: data["width"],
      height: data["height"],
      url: data["url"],
      hash: data["hash"],
      hashFunction: data["hashFunction"],
    );
  }

  factory LSP3Image.fromImage(String url, Image compressedImage) {
    return LSP3Image(
        width: compressedImage.width,
        height: compressedImage.height,
        url: url,
        hash: "0x${compressedImage.hash.toHexString()}");
  }
}
