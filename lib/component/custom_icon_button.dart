import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.borderRadius,
      this.gradientColors});

  final VoidCallback onPressed;
  final IconData icon;
  final BorderRadius? borderRadius;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(48),
        border: Border.all(color: Colors.white38, width: 5),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors ??
              <Color>[
                const Color(0xffa00661),
                const Color(0xff3a0838),
              ],
        ),
      ),
      child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 48,
            color: Colors.white60,
          )),
    );
  }
}
