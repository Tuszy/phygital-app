import 'package:flutter/material.dart';
import 'package:phygital/component/image_preview.dart';
import 'package:phygital/component/preview_section.dart';
import 'package:phygital/model/lsp0/universal_profile.dart';
import 'package:phygital/service/qr_code.dart';

import '../service/custom_dialog.dart';

class UniversalProfilePreview extends StatefulWidget {
  const UniversalProfilePreview({
    super.key,
    required this.universalProfile,
  });

  final UniversalProfile universalProfile;

  @override
  State<StatefulWidget> createState() => _UniversalProfilePreviewState();
}

class _UniversalProfilePreviewState extends State<UniversalProfilePreview> {
  void _showQRCode() {
    CustomDialog.showQrCode(
      context: context,
      title: "Universal Profile Address",
      data:
          QRCode().createCodeFromAddress(widget.universalProfile.address),
      onPressed: () {},
    );
  }

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
            widget.universalProfile.formattedName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (widget.universalProfile.profileImage != null)
            ImagePreview(
              image: widget.universalProfile.profileImage!,
              width: 200,
              height: 200,
            ),
          PreviewSection(
            label: "Lukso Address",
            text: widget.universalProfile.address.hexEip55,
            trailingLabel: "QR Code",
            trailingAction: _showQRCode,
          ),
          if (widget.universalProfile.description != null &&
              widget.universalProfile.description!.isNotEmpty)
            PreviewSection(
              label: "Description",
              text: widget.universalProfile.description!,
            ),
          if (widget.universalProfile.tags != null &&
              widget.universalProfile.tags!.isNotEmpty)
            PreviewSection(
              label: "Tags",
              text: widget.universalProfile.tags!.join(", "),
            ),
          if (widget.universalProfile.links != null &&
              widget.universalProfile.links!.isNotEmpty)
            PreviewSection(
              label: "Links",
              text: widget.universalProfile.links!
                  .map((link) => "- ${link.title}: ${link.url}")
                  .join("\n"),
            ),
        ],
      ),
    );
  }
}
