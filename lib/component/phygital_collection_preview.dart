import 'package:flutter/material.dart';
import 'package:phygital/component/image_preview_section.dart';
import 'package:phygital/component/preview_section.dart';
import 'package:phygital/component/viewable_link_list_section.dart';
import 'package:phygital/component/viewable_universal_profile_list_section.dart';

import '../model/phygital/phygital_collection.dart';

class PhygitalCollectionPreview extends StatelessWidget {
  const PhygitalCollectionPreview(
      {super.key, required this.phygitalCollection});

  final PhygitalCollection phygitalCollection;

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
          if (phygitalCollection.metadata.icon != null)
            ImagePreviewSection(
              topBorder: false,
              image: phygitalCollection.metadata.icon!,
              label: "Icon",
              width: 200,
              height: 200,
            ),
          if (phygitalCollection.metadata.backgroundImage != null)
            ImagePreviewSection(
              image: phygitalCollection.metadata.backgroundImage!,
              label: "Background Image",
              width: 200,
              height: 200,
            ),
          PreviewSection(
            label: "Name",
            text: phygitalCollection.name,
          ),
          PreviewSection(
            label: "Symbol",
            text: phygitalCollection.symbol,
          ),
          PreviewSection(
            label: "Contract Address",
            text: phygitalCollection.contractAddress.hexEip55,
          ),
          PreviewSection(
            label: "Total Supply",
            text: phygitalCollection.totalSupply == 0
                ? "None minted yet."
                : phygitalCollection.totalSupply.toString(),
          ),
          if (phygitalCollection.metadata.description.isNotEmpty)
            PreviewSection(
              label: "Description",
              text: phygitalCollection.metadata.description,
            ),
          if (phygitalCollection.metadata.links.isNotEmpty)
            ViewableLinkListSection(
              label: "Links",
              links: phygitalCollection.metadata.links,
            ),
          if (phygitalCollection.creators.isNotEmpty)
            if (phygitalCollection.creators.isNotEmpty)
              ViewableUniversalProfileListSection(
                label: "Creators",
                universalProfiles: phygitalCollection.creators,
              ),
        ],
      ),
    );
  }
}
