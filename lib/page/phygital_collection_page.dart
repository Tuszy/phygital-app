import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phygital/component/phygital_collection_preview.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/model/layout_button_data.dart';
import 'package:phygital/model/lsp4/lsp4_metadata.dart';
import 'package:web3dart/credentials.dart';

class PhygitalCollectionPage extends StatelessWidget {
  const PhygitalCollectionPage({
    super.key,
    required this.contractAddress,
    required this.metadata,
    this.layoutButtonData,
  });

  final EthereumAddress contractAddress;
  final LSP4Metadata metadata;
  final LayoutButtonData? layoutButtonData;

  @override
  Widget build(BuildContext context) {
    return StandardLayout(
      title: "Phygital Collection",
      layoutButtonData: layoutButtonData,
      child: Column(
        children: [
          PhygitalCollectionPreview(
            contractAddress: contractAddress,
            metadata: metadata,
          )
        ],
      ),
    );
  }
}
