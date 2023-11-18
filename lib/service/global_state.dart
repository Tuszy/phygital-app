import 'package:flutter/foundation.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/model/lsp0/universal_profile.dart';
import 'package:phygital/service/blockchain/lukso_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/credentials.dart';

class GlobalState extends ChangeNotifier {
  GlobalState._sharedInstance();

  static final GlobalState _shared = GlobalState._sharedInstance();

  factory GlobalState() => _shared;

  SharedPreferences? _prefs;

  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    String? universalProfileAddress =
        _prefs!.getString(universalProfileAddressKey);
    if (universalProfileAddress != null) {
      LuksoClient().fetchUniversalProfile(
        EthereumAddress(
          universalProfileAddress.toBytes(),
        ),
      );
    }
    _initialized = true;
    notifyListeners();
  }

  static const String universalProfileAddressKey =
      "UNIVERSAL_PROFILE_ADDRESS_KEY";

  bool _initialized = false;

  bool get initialized => _initialized;

  UniversalProfile? _universalProfile;

  UniversalProfile? get universalProfile => _universalProfile;

  set universalProfile(UniversalProfile? newValue) {
    if (!_initialized) return;
    _universalProfile = newValue;
    if (newValue != null) {
      _prefs!.setString(
          universalProfileAddressKey, newValue.address.hexEip55.substring(2));
    } else {
      _prefs!.remove(universalProfileAddressKey);
    }
    notifyListeners();
  }

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool newValue) {
    _loading = newValue;
    notifyListeners();
  }
}
