import 'package:ndef/utilities.dart';
import 'package:phygital/model/image.dart';
import 'package:phygital/model/lsp4/lsp4_verification.dart';
import 'package:phygital/service/ipfs_client.dart';

class LSP4Image {
  LSP4Image(
      {required this.width,
      required this.height,
      required this.url,
      required this.verification});

  final int width;
  final int height;
  final String url;
  final LSP4Verification verification;

  String get gatewayUrl => url.replaceFirst(IpfsClient.protocolPrefix, IpfsClient.gatewayUrl);

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'url': url,
      'verification': verification
    };
  }

  factory LSP4Image.fromImage(
      String url, Image compressedImage) {
    return LSP4Image(
        width: compressedImage.width,
        height: compressedImage.height,
        url: url,
        verification:
            LSP4Verification(data: "0x${compressedImage.hash.toHexString()}"));
  }
}
