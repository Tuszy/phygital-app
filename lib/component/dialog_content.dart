import 'dart:ui';

import 'package:flutter/material.dart';

class DialogContent extends StatelessWidget {
  const DialogContent(
      {super.key, required this.child, this.width = 600, this.height});

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5,
        sigmaY: 5,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: height,
              width: width,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70, width: 3),
                color: const Color(0xee00aaaa),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xcc00ffff),
                    spreadRadius: 2,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
