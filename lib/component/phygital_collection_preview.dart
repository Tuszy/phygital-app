import 'package:flutter/material.dart';
import 'package:phygital/component/image_preview_section.dart';
import 'package:phygital/component/preview_section.dart';
import 'package:phygital/model/lsp4/lsp4_metadata.dart';
import 'package:web3dart/credentials.dart';

class PhygitalCollectionPreview extends StatelessWidget {
  const PhygitalCollectionPreview(
      {super.key, required this.contractAddress, required this.metadata});

  final EthereumAddress contractAddress;
  final LSP4Metadata metadata;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x22000000),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white38, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x7700ffff),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            metadata.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          PreviewSection(
            label: "Contract Address",
            text: contractAddress.hexEip55,
          ),
          if (metadata.icon != null)
            ImagePreviewSection(image: metadata.icon!, label: "Icon", width: 200, height: 200),
          if (metadata.image != null)
            ImagePreviewSection(image: metadata.image!, label: "Phygital Image", width: 200, height: 200),
          if (metadata.backgroundImage != null)
            ImagePreviewSection(image: metadata.backgroundImage!, label: "Background Image", width: 200, height: 200),
          if (metadata.description.isNotEmpty)
            PreviewSection(
              label: "Description",
              text: metadata.description,
            ),
          if (metadata.links.isNotEmpty)
            PreviewSection(
              label: "Links",
              text: metadata.links
                  .map((link) => "- ${link.title}: ${link.url}")
                  .join("\n"),
            ),
        ],
      ),
    );
  }
}
