import 'package:phygital/model/lsp4/lsp4_verification.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'url': url,
      'verification': verification
    };
  }
}
