import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phygital/component/phygital_assignment_list_section.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/model/lsp4/lsp4_metadata.dart';
import 'package:phygital/model/phygital/phygital_collection.dart';
import 'package:phygital/page/phygital_collection_page.dart';
import 'package:web3dart/credentials.dart';

import '../model/phygital/phygital_tag.dart';
import '../model/phygital/phygital_tag_data.dart';
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
  final List<PhygitalTagData> tags;

  @override
  State<StatefulWidget> createState() => _AssignCollectionPageState();
}

class _AssignCollectionPageState extends State<AssignCollectionPage> {
  late List<PhygitalTagData> _tags;
  final List<PhygitalTagData> _assignedTags = <PhygitalTagData>[];

  @override
  void initState() {
    super.initState();

    _tags = widget.tags;
  }

  Future<void> _onAssignCollection() async {
    try {
      GlobalState().loadingWithText = "Assigning collection";

      PhygitalTag? phygitalTag = await NFC().setContractAddress(
        phygitalTags:
            _tags.map((phygitalTagData) => phygitalTagData.phygitalTag).toSet(),
        contractAddress: widget.contractAddress,
      );

      if (phygitalTag != null) {
        PhygitalTagData phygitalTagData = _tags.firstWhere(
            (element) => element.phygitalTag.tagId == phygitalTag.tagId);
        setState(() {
          _tags.remove(phygitalTagData);
          _assignedTags.add(phygitalTagData);
        });
        print(_tags);
        GlobalState().loadingWithText = null;
        if (_tags.isNotEmpty) return;
        await showInfoDialog(
          title: "Assignment completed",
          text: "Successfully assigned collection to all phygitals.",
        );

        PhygitalCollection phygitalCollection = PhygitalCollection(
            contractAddress: widget.contractAddress,
            name: widget.metadata.name,
            symbol: widget.metadata.symbol!,
            metadata: widget.metadata,
            creators: GlobalState().universalProfile == null
                ? []
                : [GlobalState().universalProfile!],
            totalSupply: 0);

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PhygitalCollectionPage(
              phygitalCollection: phygitalCollection,
            ),
          ),
          (route) => route.settings.name == "menu",
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
