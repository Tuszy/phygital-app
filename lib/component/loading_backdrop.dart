import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/global_state.dart';
import '../service/nfc.dart';

class LoadingBackdrop extends StatelessWidget {
  const LoadingBackdrop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    NFC nfc = Provider.of<NFC>(context);
    GlobalState globalState = Provider.of<GlobalState>(context);

    bool active = nfc.isActive || globalState.loading;

    return Positioned.fill(
      child: AnimatedOpacity(
        opacity: active ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: IgnorePointer(
          ignoring: !active,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 4,
              sigmaY: 4,
            ),
            child: Container(
              color: const Color(0x66000000),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 2,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.cyan),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
