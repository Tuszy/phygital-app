import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/model/layout_button_data.dart';

import '../component/universal_profile_preview.dart';
import '../model/lsp0/universal_profile.dart';

class UniversalProfilePage extends StatelessWidget {
  const UniversalProfilePage({
    super.key,
    required this.universalProfile,
    this.layoutButtonData,
  });

  final UniversalProfile universalProfile;
  final LayoutButtonData? layoutButtonData;

  @override
  Widget build(BuildContext context) {
    return StandardLayout(
      title: "Universal Profile",
      layoutButtonData: layoutButtonData,
      child: Column(
        children: [
          UniversalProfilePreview(
            universalProfile: universalProfile,
          )
        ],
      ),
    );
  }
}
