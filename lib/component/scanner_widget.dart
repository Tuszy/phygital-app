import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerWidget extends StatefulWidget {
  const ScannerWidget(
      {super.key, required this.onScanSuccess, required this.title});

  final String title;
  final void Function(String? code) onScanSuccess;

  @override
  createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  QRViewController? controller;
  GlobalKey qrKey = GlobalKey(debugLabel: 'scanner');

  bool isInitialized = false;
  bool isScanned = false;

  @override
  void reassemble() {
    try {
      super.reassemble();
      if (Platform.isAndroid) {
        controller?.pauseCamera();
      } else if (Platform.isIOS) {
        controller?.resumeCamera();
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    /// dispose the controller
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: DefaultTextStyle(
            style: const TextStyle(
                color: Color(0xddffffff),
                fontSize: 24,
                fontWeight: FontWeight.w700),
            child: Text(
              widget.title,
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildQrView(context),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.white70,
          height: 2,
          margin: const EdgeInsets.only(top: 16),
        ),
        IgnorePointer(
          ignoring: !isInitialized,
          child: TextButton(
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
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [Text(isInitialized ? "Close" : "Initializing...")],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    double smallestDimension = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    smallestDimension = min(smallestDimension, 550);

    return QRView(
      key: qrKey,
      onQRViewCreated: (controller) {
        _onQRViewCreated(controller);
      },
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: smallestDimension - 140,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    try {
      controller.scannedDataStream.listen((Barcode scanData) async {
        if (!isScanned) {
          isScanned = true;
          widget.onScanSuccess(scanData.code);
        }
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          isInitialized = true;
        });
      });
    } catch (e) {
      Navigator.pop(context);
    }
  }
}
