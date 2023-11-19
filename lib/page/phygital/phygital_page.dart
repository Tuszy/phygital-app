import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phygital/component/phygital_preview.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/model/layout_button_data.dart';
import 'package:phygital/model/phygital.dart';

class PhygitalPage extends StatelessWidget {
  const PhygitalPage({
    super.key,
    required this.phygital,
    this.layoutButtonData,
  });

  final Phygital phygital;
  final LayoutButtonData? layoutButtonData;

  @override
  Widget build(BuildContext context) {
    return StandardLayout(
      title: "Phygital",
      layoutButtonData: layoutButtonData,
      child: Column(
        children: [
          PhygitalPreview(
            phygital: phygital,
          )
        ],
      ),
    );
  }
}
