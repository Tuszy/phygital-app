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

    bool active = nfc.isActive || globalState.loadingWithText != null;

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
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0x66009999),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white38,
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xcc009999),
                        spreadRadius: 2,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        width: 64,
                        height: 64,
                        child: const CircularProgressIndicator(
                          strokeWidth: 6,
                          valueColor: AlwaysStoppedAnimation(Colors.white54),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: Text(
                          nfc.isActive
                              ? "NFC is active."
                              : globalState.loadingWithText ?? "Loading...",
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            color: Colors.white60,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
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
