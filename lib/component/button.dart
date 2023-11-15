import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
      {super.key,
      required this.text,
      required this.onPressed,
      this.disabled = false});

  final String text;
  final bool disabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 4, color: Colors.white),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x7700ffff),
                      spreadRadius: 2,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0x3300ffff),
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(
                        letterSpacing: 3,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                              // bottomLeft
                              offset: Offset(-1.25, -1.25),
                              color: Color(0x7700ffff)),
                          Shadow(
                              // bottomRight
                              offset: Offset(1.25, -1.25),
                              color: Color(0x7700ffff)),
                          Shadow(
                              // topRight
                              offset: Offset(1.25, 1.25),
                              color: Color(0x7700ffff)),
                          Shadow(
                              // topLeft
                              offset: Offset(-1.25, 1.25),
                              color: Color(0x7700ffff)),
                        ]),
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: onPressed,
                  child: Text(text),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
