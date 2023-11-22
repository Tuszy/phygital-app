import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phygital/component/phygital_collection_preview.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/model/layout_button_data.dart';
import 'package:phygital/model/phygital/phygital_collection.dart';

class PhygitalCollectionPage extends StatelessWidget {
  const PhygitalCollectionPage({
    super.key,
    required this.phygitalCollection,
    this.layoutButtonData,
  });

  final PhygitalCollection phygitalCollection;
  final LayoutButtonData? layoutButtonData;

  @override
  Widget build(BuildContext context) {
    return StandardLayout(
      title: "Phygital Collection",
      layoutButtonData: layoutButtonData,
      child: Column(
        children: [
          PhygitalCollectionPreview(
            phygitalCollection: phygitalCollection,
          )
        ],
      ),
    );
  }
}
