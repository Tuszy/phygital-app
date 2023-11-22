import 'package:flutter/material.dart';
import 'package:phygital/model/phygital/phygital_tag_data.dart';

class PhygitalAssignmentListSection extends StatelessWidget {
  const PhygitalAssignmentListSection({
    super.key,
    required this.label,
    required this.phygitalTags,
    required this.onAssign,
    this.topBorder = true,
  });

  final String label;
  final List<PhygitalTagData> phygitalTags;
  final bool topBorder;
  final VoidCallback onAssign;

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
                    _Button(
                      name: "ASSIGN",
                      onClick: onAssign,
                    )
                  ],
                ),
                ...phygitalTags.indexed.map(
                  ((int, PhygitalTagData) phygitalTag) => Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0x22ffffff),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0x33ffffff),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          phygitalTag.$2.phygitalTag.address.hexEip55,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.7,
                          ),
                        )
                      ],
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

class _Button extends StatelessWidget {
  const _Button({required this.name, required this.onClick});

  final String name;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onClick,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white70,
        backgroundColor: const Color(0x20ffffff),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(
          letterSpacing: 3,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
        side: const BorderSide(color: Colors.white60, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}
