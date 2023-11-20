import 'package:flutter/material.dart';
import 'package:phygital/component/image_preview.dart';
import 'package:phygital/model/lsp0/lsp_image.dart';

class ImagePreviewSection extends StatelessWidget {
  const ImagePreviewSection({
    super.key,
    required this.image,
    required this.label,
    required this.width,
    required this.height,
    this.topBorder = true,
  });

  final LSPImage image;
  final String label;
  final double width;
  final double height;
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
                ImagePreview(
                  width: width,
                  height: height,
                  image: image,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
