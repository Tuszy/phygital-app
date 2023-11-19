import 'package:flutter/material.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/component/image_preview.dart';
import 'package:phygital/component/phygital_preview_section.dart';
import 'package:phygital/model/phygital.dart';

class PhygitalPreview extends StatelessWidget {
  const PhygitalPreview({super.key, required this.phygital});

  final Phygital phygital;

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
            phygital.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (phygital.metadata.image != null)
            ImagePreview(
              image: phygital.metadata.image!,
              width: 200,
              height: 200,
            ),
          Text(
            "\$${phygital.symbol}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          PhygitalPreviewSection(
            label: "Contract Address",
            text: phygital.contractAddress.hexEip55,
          ),
          PhygitalPreviewSection(
            label: "Phygital ID",
            text: phygital.id.toHexString(),
          ),
          PhygitalPreviewSection(
            label: "Owner",
            trailingLabel: phygital.owner != null ? "${phygital.verifiedOwnership ? "VERIFIED" : "UNVERIFIED"} OWNERSHIP" :null,
            text: phygital.owner == null
                ? "NOT MINTED YET"
                : phygital.owner!.formattedName,
          ),
          if (phygital.creators.isNotEmpty)
            PhygitalPreviewSection(
              label: "Creators",
              text: phygital.creators
                  .map((creator) => "- ${creator.formattedName}")
                  .join("\n"),
            )
        ],
      ),
    );
  }
}
