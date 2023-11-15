import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';

import 'nfc_active_backdrop.dart';

class StandardPage extends StatefulWidget {
  const StandardPage({super.key, required this.child});

  final Widget child;

  @override
  State<StandardPage> createState() => _StandardPageState();
}

class _StandardPageState extends State<StandardPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xffa00661),
              Color(0xff3a0838),
            ],
          ),
        ),
        child: Stack(
          children: [
            IgnorePointer(
              ignoring: true,
              child: AnimatedBackground(
                  behaviour:
                      SpaceBehaviour(backgroundColor: Colors.transparent),
                  vsync: this,
                  child: const ColoredBox(color: Colors.transparent)),
            ),
            SafeArea(
              child: widget.child,
            ),
            const NfcActiveBackdrop()
          ],
        ),
      ),
    );
  }
}
