import 'package:phygital/model/phygital/phygital_tag.dart';
import 'dart:io';

import '../lsp4/lsp4_attribute.dart';
import '../lsp4/lsp4_link.dart';

class PhygitalTagData {
  PhygitalTagData({
    required this.phygitalTag,
    required this.phygitalImage,
    required this.name,
    required this.description,
    required this.links,
    required this.attributes,
  });

  final PhygitalTag phygitalTag;
  final File phygitalImage;
  final String name;
  final String description;
  final List<LSP4Link> links;
  final List<LSP4Attribute> attributes;

  @override
  bool operator ==(Object other) {
    return (other is PhygitalTagData &&
            phygitalTag.tagId.hashCode == other.phygitalTag.tagId.hashCode) ||
        (other is PhygitalTag &&
            phygitalTag.tagId.hashCode == other.tagId.hashCode);
  }

  @override
  int get hashCode => phygitalTag.tagId.hashCode;
}
