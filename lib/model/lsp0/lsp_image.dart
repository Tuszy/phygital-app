import 'package:phygital/service/ipfs_client.dart';

class LSPImage {
  LSPImage({required this.width, required this.height, required this.url});

  final int width;
  final int height;
  final String url;

  String get gatewayUrl =>
      url.replaceFirst(IpfsClient.protocolPrefix, IpfsClient.gatewayUrl);

  Map<String, dynamic> toJson() {
    return {'width': width, 'height': height, 'url': url};
  }

  factory LSPImage.fromJson(final Map<String, dynamic> data) {
    return LSPImage(
        width: data["width"], height: data["height"], url: data["url"]);
  }
}
