import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:phygital/component/scanner_widget.dart';

class QrCodeScanner {
  void scanQrCode(
      {BuildContext? context, required String title, required Function(String? code) onScanSuccess}) {
    assert(context != null);

    showDialog(
      context: context!,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),

        /// Filter effect field
        child: Container(
          alignment: Alignment.center,
          child: Container(
            height: 400,
            width: 600,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white70, width: 3),
              color: const Color(0xa500ffff),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x7700ffff),
                  spreadRadius: 2,
                  blurRadius: 8,
                ),
              ],
            ),
            child: ScannerWidget(title: title, onScanSuccess: (code) {
              if (code != null) {
                Navigator.pop(context);
                onScanSuccess(code);
              }
            }),
          ),
        ),
      ),
    );
  }
}
