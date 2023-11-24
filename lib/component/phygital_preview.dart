import 'package:flutter/material.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/component/image_preview.dart';
import 'package:phygital/component/preview_section.dart';
import 'package:phygital/component/viewable_link_list_section.dart';
import 'package:phygital/component/viewable_universal_profile_list_section.dart';
import 'package:phygital/model/phygital/phygital.dart';
import 'package:phygital/model/phygital/phygital_collection.dart';
import 'package:phygital/service/blockchain/lukso_client.dart';
import 'package:phygital/service/global_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../page/phygital_collection_page.dart';
import '../service/custom_dialog.dart';
import '../service/result.dart';

class PhygitalPreview extends StatefulWidget {
  const PhygitalPreview({super.key, required this.phygital});

  final Phygital phygital;

  @override
  State<StatefulWidget> createState() => _PhygitalPreviewState();
}

class _PhygitalPreviewState extends State<PhygitalPreview> {
  Future<void> _showPhygitalCollection() async {
    GlobalState().loadingWithText = "Fetching Phygital Collection Data";
    (Result, PhygitalCollection?) result = await LuksoClient()
        .fetchPhygitalCollectionData(
            contractAddress: widget.phygital.contractAddress);
    GlobalState().loadingWithText = null;

    if (result.$2 == null) {
      showInfoDialog(title: "Result", text: getMessageForResult(result.$1));
      return;
    }

    if (!mounted) return;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhygitalCollectionPage(
            phygitalCollection: result.$2!,
          ),
        ));
  }

  Future<void> showInfoDialog(
      {required String title, required String text}) async {
    return CustomDialog.showInfo(
        context: context, title: title, text: text, onPressed: () {});
  }

  void _showOnUniversalPage() => launchUrl(
        Uri.parse(
            "https://universalpage.dev/collections/${widget.phygital.contractAddress.hexEip55}/0x${widget.phygital.id.toHexString()}"),
      );

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
            widget.phygital.metadata.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (widget.phygital.metadata.image != null)
            ImagePreview(
              image: widget.phygital.metadata.image!,
              width: 200,
              height: 200,
              keepContainerSize: false,
            ),
          PreviewSection(
            label: "Collection",
            text: widget.phygital.name,
            trailingLabel: "Show",
            trailingAction: _showPhygitalCollection,
          ),
          PreviewSection(
            label: "Phygital ID",
            text: widget.phygital.id.toHexString(),
            trailingLabel: "UniversalPage",
            trailingAction: _showOnUniversalPage,
          ),
          if (widget.phygital.metadata.description.isNotEmpty)
            PreviewSection(
              label: "Description",
              text: widget.phygital.metadata.description,
            ),
          if (widget.phygital.owner != null)
            ViewableUniversalProfileListSection(
              label: "Owner",
              universalProfiles: [widget.phygital.owner!],
              trailingLabel:
                  "${widget.phygital.verifiedOwnership ? "VERIFIED" : "UNVERIFIED"} OWNERSHIP",
            ),
          if (widget.phygital.owner == null)
            const PreviewSection(
              label: "Owner",
              text: "NOT MINTED YET",
            ),
          if (widget.phygital.metadata.attributes.isNotEmpty)
            PreviewSection(
              label: "Attributes",
              text: widget.phygital.metadata.attributes
                  .map((attribute) =>
                      "${attribute.key}: ${attribute.formattedValue}")
                  .join("\n"),
            ),
          if (widget.phygital.metadata.links.isNotEmpty)
            ViewableLinkListSection(
              label: "Links",
              links: widget.phygital.metadata.links,
            ),
          if (widget.phygital.creators.isNotEmpty)
            ViewableUniversalProfileListSection(
              label: "Creators",
              universalProfiles: widget.phygital.creators,
            ),
        ],
      ),
    );
  }
}
