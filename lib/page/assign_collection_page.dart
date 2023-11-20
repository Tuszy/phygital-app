import 'package:flutter/material.dart';
import 'package:phygital/component/phygital_assignment_list_section.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/model/lsp4/lsp4_metadata.dart';
import 'package:phygital/page/phygital_collection_page.dart';
import 'package:web3dart/credentials.dart';

import '../model/phygital/phygital_tag.dart';
import '../service/custom_dialog.dart';
import '../service/global_state.dart';
import '../service/nfc.dart';
import '../service/result.dart';

class AssignCollectionPage extends StatefulWidget {
  const AssignCollectionPage({
    super.key,
    required this.contractAddress,
    required this.metadata,
    required this.tags,
  });

  final EthereumAddress contractAddress;
  final LSP4Metadata metadata;
  final List<PhygitalTag> tags;

  @override
  State<StatefulWidget> createState() => _AssignCollectionPageState();
}

class _AssignCollectionPageState extends State<AssignCollectionPage> {
  late final Set<PhygitalTag> _tags;
  final Set<PhygitalTag> _assignedTags = <PhygitalTag>{};

  @override
  void initState() {
    super.initState();

    _tags = widget.tags.toSet();
  }

  Future<void> _onAssignCollection() async {
    try {
      PhygitalTag phygitalTag = await NFC().read(mustHaveContractAddress: true);
      if (!_tags.contains(phygitalTag)) {
        showInfoDialog(
          title: "Failed",
          text: _assignedTags.contains(phygitalTag)
              ? "This Phygital has already been assigned"
              : "Phygital is not part of the collection",
        );
        return;
      }

      if (!mounted) return;

      Result result =
          await phygitalTag.setContractAddress(widget.contractAddress);
      if (Result.assigningCollectionSucceeded == result) {
        _tags.remove(phygitalTag);
        _assignedTags.add(phygitalTag);
        if (_tags.isNotEmpty) return;
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PhygitalCollectionPage(
              contractAddress: widget.contractAddress,
              metadata: widget.metadata,
            ),
          ),
          (var route) => route.settings.name == "menu",
        );
      } else {
        await showInfoDialog(
          title: "Result",
          text: getMessageForResult(result),
        );
        return;
      }
    } catch (e) {
      GlobalState().loadingWithText = null;
      showInfoDialog(
        title: "Result",
        text: e.toString(),
      );
    }
  }

  Future<void> showInfoDialog(
      {required String title, required String text}) async {
    return CustomDialog.showInfo(
        context: context, title: title, text: text, onPressed: () {});
  }

  @override
  Widget build(BuildContext context) {
    return StandardLayout(
      hideBackButton: true,
      title: "Assign Collection",
      child: Column(
        children: [
          Container(
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
                PhygitalAssignmentListSection(
                  label: "Left Phygitals to assign",
                  phygitalTags: _tags.toList(),
                  onAssign: _onAssignCollection,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
