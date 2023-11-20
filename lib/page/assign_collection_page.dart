import 'package:flutter/foundation.dart';
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
      GlobalState().loadingWithText = "Assigning collection";

      PhygitalTag? phygitalTag = await NFC().setContractAddress(
        phygitalTags: _tags,
        contractAddress: widget.contractAddress,
      );

      if (phygitalTag != null) {
        _tags.remove(phygitalTag);
        _assignedTags.add(phygitalTag);
        GlobalState().loadingWithText = null;
        if (_tags.isNotEmpty) return;
        await showInfoDialog(
          title: "Assignment completed",
          text: "Successfully assigned collection to all phygitals.",
        );
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
        GlobalState().loadingWithText = null;
        await showInfoDialog(
          title: "Assignment failed",
          text: "Unknown error occurred. Please try again.",
        );
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            "Setting contract address ${widget.contractAddress.hexEip55} failed ($e)");
      }
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
                  topBorder: false,
                  label: "Left Phygitals",
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
