import 'package:flutter/material.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/component/image_preview.dart';
import 'package:phygital/component/phygital_preview_section.dart';
import 'package:phygital/model/phygital_with_data.dart';

class PhygitalPreview extends StatelessWidget {
  const PhygitalPreview({super.key, required this.phygitalWithData});

  final PhygitalWithData phygitalWithData;

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
            phygitalWithData.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (phygitalWithData.metadata.image != null)
            ImagePreview(
              image: phygitalWithData.metadata.image!,
              width: 200,
              height: 200,
            ),
          Text(
            "\$${phygitalWithData.symbol}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          PhygitalPreviewSection(
            label: "Contract Address",
            text: phygitalWithData.contractAddress.hexEip55,
          ),
          PhygitalPreviewSection(
            label: "Phygital ID",
            text: phygitalWithData.id.toHexString(),
          ),
          PhygitalPreviewSection(
            label: "Owner",
            text: phygitalWithData.owner == null
                ? "Not minted yet."
                : phygitalWithData.owner!.formattedName,
          ),
          if (phygitalWithData.creators.isNotEmpty)
            PhygitalPreviewSection(
              label: "Creators",
              text: phygitalWithData.creators
                  .map((creator) => "- ${creator.formattedName}")
                  .join("\n"),
            )
        ],
      ),
    );
  }
}
