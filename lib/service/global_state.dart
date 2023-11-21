import 'package:flutter/foundation.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/model/lsp0/universal_profile.dart';
import 'package:phygital/service/backend_client.dart';
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
    List<String>? universalProfileLoginData =
        _prefs!.getString(universalProfileLoginKey)?.split(":");
    String? universalProfileAddress =
        universalProfileLoginData?.elementAtOrNull(0);
    String? jwt = universalProfileLoginData?.elementAtOrNull(1);
    if (universalProfileAddress != null && jwt != null) {
      EthereumAddress? universalProfileEthAddress = EthereumAddress(
        universalProfileAddress.toBytes(),
      );
      if (await BackendClient().verifyLoginToken(
          universalProfileAddress: universalProfileEthAddress, jwt: jwt)) {
        _universalProfile = await LuksoClient().fetchUniversalProfile(
          universalProfileAddress: universalProfileEthAddress,
        );
        if (universalProfile != null) {
          _jwt = jwt;
        }else{
          await _prefs!.remove(universalProfileLoginKey);
        }
      }else{
        await _prefs!.remove(universalProfileLoginKey);
      }
    } else {
      await _prefs!.remove(universalProfileLoginKey);
    }
    _initialized = true;
    notifyListeners();
  }

  static const String universalProfileLoginKey =
      "UNIVERSAL_PROFILE_ADDRESS_KEY";

  bool _initialized = false;

  bool get initialized => _initialized;

  String? _jwt;

  String? get jwt => _jwt;

  UniversalProfile? _universalProfile;

  UniversalProfile? get universalProfile => _universalProfile;

  void login(UniversalProfile universalProfile, String jwt) {
    if (!_initialized) return;
    _universalProfile = universalProfile;
    _jwt = jwt;
    _prefs!.setString(universalProfileLoginKey,
        "${universalProfile.address.hexEip55.substring(2)}:$jwt");
    notifyListeners();
  }

  void logout() {
    _universalProfile = null;
    _jwt = null;
    _prefs!.remove(universalProfileLoginKey);
    notifyListeners();
  }

  String? _loadingWithText;

  String? get loadingWithText => _loadingWithText;

  set loadingWithText(String? newValue) {
    _loadingWithText = newValue;
    notifyListeners();
  }
}
