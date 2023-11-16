import 'package:phygital/model/lsp4/lsp4_verification.dart';

class LSP4Image {
  LSP4Image(
      {required this.fileType, required this.url, required this.verification});

  final String url;
  final LSP4Verification verification;
  final String fileType;
}
