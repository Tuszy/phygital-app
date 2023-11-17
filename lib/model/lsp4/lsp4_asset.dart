import 'package:phygital/model/lsp4/lsp4_verification.dart';

class LSP4Asset {
  LSP4Asset(
      {required this.fileType, required this.url, required this.verification});

  final String url;
  final LSP4Verification verification;
  final String fileType;

  Map<String, dynamic> toJson() {
    return {'url': url, 'verification': verification, 'fileType': fileType};
  }

  factory LSP4Asset.fromJson(final Map<String, dynamic> data) {
    return LSP4Asset(
      fileType: data["fileType"],
      url: data["url"],
      verification: LSP4Verification.fromJson(data["verification"]),
    );
  }
}
