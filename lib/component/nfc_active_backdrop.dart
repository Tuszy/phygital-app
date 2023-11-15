import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/nfc.dart';

class NfcActiveBackdrop extends StatelessWidget {
  const NfcActiveBackdrop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    NFC nfc = Provider.of<NFC>(context);
    return Positioned.fill(
      child: AnimatedOpacity(
        opacity: nfc.isActive ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: IgnorePointer(
          ignoring: !nfc.isActive,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 4,
              sigmaY: 4,
            ),
            child: Container(
              color: const Color(0x66000000),
              child: Center(
                child: Transform.scale(
                  scale: 2,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.cyan),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
