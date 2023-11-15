import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NFC extends ChangeNotifier {
  NFC._sharedInstance();

  static final NFC _shared = NFC._sharedInstance();

  factory NFC() => _shared;

  NFCAvailability _availability = NFCAvailability.not_supported;

  bool get isAvailable => _availability == NFCAvailability.available;

  Future<void> init() async {
    try {
      _availability = await FlutterNfcKit.nfcAvailability;
    } on PlatformException {
      _availability = NFCAvailability.not_supported;
    }

    notifyListeners();
  }
}
