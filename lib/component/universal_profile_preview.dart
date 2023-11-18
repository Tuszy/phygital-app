import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phygital/component/image_preview.dart';
import 'package:phygital/model/lsp0/universal_profile.dart';

class UniversalProfilePreview extends StatelessWidget {
  const UniversalProfilePreview({super.key, required this.universalProfile});

  final UniversalProfile universalProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
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
          if (universalProfile.profileImage != null)
            ImagePreview(
              image: universalProfile.profileImage!,
              width: 150,
              height: 150,
            ),
          if (universalProfile.name != null)
            Text(
              "${universalProfile.name ?? "Anonymous"}#${universalProfile.address.hexEip55.substring(2, 6)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            )
        ],
      ),
    );
  }
}
