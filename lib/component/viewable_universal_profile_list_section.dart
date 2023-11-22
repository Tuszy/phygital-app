import 'package:flutter/material.dart';
import 'package:phygital/model/lsp0/universal_profile.dart';
import 'package:phygital/page/universal_profile_page.dart';

import 'image_preview.dart';

class ViewableUniversalProfileListSection extends StatefulWidget {
  const ViewableUniversalProfileListSection({
    super.key,
    required this.label,
    required this.universalProfiles,
    this.topBorder = true,
    this.trailingLabel,
  });

  final String label;
  final List<UniversalProfile> universalProfiles;
  final bool topBorder;
  final String? trailingLabel;

  @override
  State<StatefulWidget> createState() =>
      _ViewableUniversalProfileListSectionState();
}

class _ViewableUniversalProfileListSectionState
    extends State<ViewableUniversalProfileListSection> {
  void _onShow(UniversalProfile universalProfile) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UniversalProfilePage(
            universalProfile: universalProfile,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 8),
      decoration: BoxDecoration(
        border: widget.topBorder
            ? const Border(
                top: BorderSide(width: 2, color: Colors.white38),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        widget.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (widget.trailingLabel != null)
                      Text(
                        widget.trailingLabel!,
                        style: const TextStyle(
                          color: Colors.white,
                          height: 2,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                  ],
                ),
                ...widget.universalProfiles.indexed.map(
                  ((int, UniversalProfile) universalProfile) => GestureDetector(
                    onTap: () => _onShow(universalProfile.$2),
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0x33ffffff),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0x77ffffff),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (universalProfile.$2.profileImage != null)
                                ImagePreview(
                                  image: universalProfile.$2.profileImage!,
                                  width: 50,
                                  height: 50,
                                ),
                              Expanded(
                                child: Text(
                                  universalProfile.$2.formattedName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}