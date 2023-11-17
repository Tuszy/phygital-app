import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:phygital/component/scanner_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'dialog_content.dart';

class CustomDialog {
  static void showQrScanner(
      {BuildContext? context,
      required String title,
      required Function(String? code) onScanSuccess}) {
    assert(context != null);

    showDialog(
      context: context!,
      builder: (context) => BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5,
            sigmaY: 5,
          ),
          child: DialogContent(
            height: 440,
            child: ScannerWidget(
                title: title,
                onScanSuccess: (code) {
                  if (code != null) {
                    Navigator.pop(context);
                    onScanSuccess(code);
                  }
                }),
          )),
    );
  }

  static void showQrCode(
      {BuildContext? context,
      required String title,
      required String data,
      required VoidCallback onPressed}) {
    assert(context != null);

    showDialog(
      context: context!,
      builder: (context) => DialogContent(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: DefaultTextStyle(
              style: const TextStyle(
                  color: Color(0xddffffff),
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
              child: Text(title),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: QrImageView(
              data: data,
              version: QrVersions.auto,
              //size: 400.0,
            ),
          ),
          Container(
            color: Colors.white70,
            height: 2,
            margin: const EdgeInsets.only(top: 16),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xcdffffff),
              backgroundColor: const Color(0x22000000),
              padding: const EdgeInsets.all(16.0),
              textStyle: const TextStyle(
                letterSpacing: 3,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onPressed();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [Text("Close")],
            ),
          )
        ],
      )),
    );
  }

  static void showInfo(
      {BuildContext? context,
      required String title,
      required String text,
      required VoidCallback onPressed}) {
    assert(context != null);

    showDialog(
      context: context!,
      builder: (context) => DialogContent(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: DefaultTextStyle(
              style: const TextStyle(
                  color: Color(0xddffffff),
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
              child: Text(title),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Color(0xddffffff),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              child: Text(text),
            ),
          ),
          Container(
            color: Colors.white70,
            height: 2,
            margin: const EdgeInsets.only(top: 16),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xcdffffff),
              backgroundColor: const Color(0x22000000),
              padding: const EdgeInsets.all(16.0),
              textStyle: const TextStyle(
                letterSpacing: 3,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onPressed();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [Text("OK")],
            ),
          )
        ],
      )),
    );
  }
}
