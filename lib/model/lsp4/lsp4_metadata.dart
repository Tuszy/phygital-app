import 'dart:core';

import 'lsp4_image.dart';
import 'lsp4_link.dart';

class LSP4Metadata {
  LSP4Metadata(
      {this.description, this.links, required this.icon, required this.images});

  String? description;
  List<LSP4Link>? links;
  List<LSP4Metadata>? assets;
  List<LSP4Image> icon;
  List<List<LSP4Image>> images;
}
