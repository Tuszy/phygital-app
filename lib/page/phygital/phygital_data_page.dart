import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phygital/component/phygital_preview.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/model/phygital_with_data.dart';

class PhygitalDataPage extends StatelessWidget {
  const PhygitalDataPage({super.key, required this.phygitalWithData});

  final PhygitalWithData phygitalWithData;

  @override
  Widget build(BuildContext context) {
    return StandardLayout(
      title: "Phygital Data",
      child: Column(
        children: [
          PhygitalPreview(phygitalWithData: phygitalWithData)
        ],
      ),
    );
  }
}