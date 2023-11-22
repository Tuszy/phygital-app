import 'package:flutter/material.dart';

import '../model/phygital/phygital_tag_data.dart';

typedef OnAddCallback = void Function();
typedef OnRemoveCallback = void Function(int);

class PhygitalListSection extends StatelessWidget {
  const PhygitalListSection({
    super.key,
    required this.name,
    required this.label,
    required this.onAdd,
    required this.onRemove,
    required this.phygitalTags,
    this.topBorder = true,
  });

  final String name;
  final String label;
  final OnAddCallback onAdd;
  final OnRemoveCallback onRemove;
  final List<PhygitalTagData> phygitalTags;
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
                      name: "ADD",
                      onClick: onAdd,
                    ),
                  ],
                ),
                ...phygitalTags.indexed.map(
                  ((int, PhygitalTagData) phygitalTagData) => Container(
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
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "#${phygitalTagData.$1 + 1} Phygital",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            _Button(
                              name: "REMOVE",
                              onClick: () => onRemove(phygitalTagData.$1),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Text(
                              phygitalTagData.$2.phygitalTag.address.hexEip55,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.7),
                            ),
                          ],
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
