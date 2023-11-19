import 'package:flutter/material.dart';
import 'package:phygital/component/image_preview.dart';
import 'package:phygital/component/preview_section.dart';
import 'package:phygital/model/lsp0/universal_profile.dart';

class UniversalProfilePreview extends StatelessWidget {
  const UniversalProfilePreview(
      {super.key, required this.universalProfile});

  final UniversalProfile universalProfile;

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
            universalProfile.formattedName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (universalProfile.profileImage != null)
            ImagePreview(
              image: universalProfile.profileImage!,
              width: 200,
              height: 200,
            ),
          PreviewSection(
            label: "Lukso Address",
            text: universalProfile.address.hexEip55,
          ),
          if (universalProfile.description != null &&
              universalProfile.description!.isNotEmpty)
            PreviewSection(
              label: "Description",
              text: universalProfile.description!,
            ),
          if (universalProfile.tags != null &&
              universalProfile.tags!.isNotEmpty)
            PreviewSection(
              label: "Tags",
              text: universalProfile.tags!.join(", "),
            ),
          if (universalProfile.links != null &&
              universalProfile.links!.isNotEmpty)
            PreviewSection(
              label: "Links",
              text: universalProfile.links!
                  .map((link) => "- ${link.title}: ${link.url}")
                  .join("\n"),
            ),
        ],
      ),
    );
  }
}
