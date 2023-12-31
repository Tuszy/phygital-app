import 'package:flutter/material.dart';

class PreviewSection extends StatelessWidget {
  const PreviewSection(
      {super.key,
      required this.label,
      required this.text,
      this.trailingLabel,
      this.trailingAction});

  final String label;
  final String text;
  final String? trailingLabel;
  final VoidCallback? trailingAction;

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
                    if (trailingLabel != null && trailingAction == null)
                      Text(
                        trailingLabel!,
                        style: const TextStyle(
                          color: Colors.white,
                          height: 2,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    if (trailingLabel != null && trailingAction != null)
                      _Button(
                        name: trailingLabel!,
                        onClick: trailingAction!,
                      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
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
