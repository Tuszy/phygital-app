import 'dart:io';

import 'package:flutter/material.dart';

import 'image_upload.dart';

typedef OnImageChangeCallback = void Function(File?);

class ImageUploadSection extends StatelessWidget {
  const ImageUploadSection(
      {super.key,
      required this.name,
      required this.label,
      required this.width,
      required this.height,
      required this.onImageChange,
      this.topBorder = true});

  final String name;
  final String label;
  final double width;
  final double height;
  final OnImageChangeCallback onImageChange;
  final bool topBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 8),
      decoration: BoxDecoration(
        border: topBorder
            ? const Border(
                top: BorderSide(width: 2, color: Colors.white38),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                ImageUpload(
                  width: width,
                  height: height,
                  onChange: onImageChange,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
