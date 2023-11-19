import 'package:flutter/material.dart';

class PhygitalPreviewSection extends StatelessWidget {
  const PhygitalPreviewSection({
    super.key,
    required this.label,
    required this.text,
    this.trailingLabel,
  });

  final String label;
  final String text;
  final String? trailingLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 8),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 2, color: Colors.white38),
        ),
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
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (trailingLabel != null)
                      Text(
                        trailingLabel!,
                        style: const TextStyle(
                          color: Colors.white,
                          height: 2,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
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
