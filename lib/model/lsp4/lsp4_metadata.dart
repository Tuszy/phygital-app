import 'dart:core';

import 'package:phygital/model/lsp4/lsp4_image.dart';

import 'lsp4_asset.dart';
import 'lsp4_attribute.dart';
import 'lsp4_link.dart';

class LSP4Metadata {
  LSP4Metadata(
      {required this.description,
      required this.links,
      required this.icon,
      required this.images,
      this.assets,
      this.attributes});

  String description;
  List<LSP4Link> links;
  List<LSP4Image> icon;
  List<List<LSP4Image>> images;
  List<LSP4Asset>? assets;
  List<LSP4Attribute>? attributes;

  Map<String, dynamic> toJson() {
    return {
      'LSP4Metadata': {
        'description': description,
        'links': links,
        'icon': icon,
        'images': images,
        if (assets != null) 'assets': assets,
        if (attributes != null) 'attributes': attributes
      }
    };
  }
}
