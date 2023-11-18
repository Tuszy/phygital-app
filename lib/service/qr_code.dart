import 'package:ndef/utilities.dart';
import 'package:phygital/model/lsp0/universal_profile.dart';
import 'package:web3dart/credentials.dart';

import 'blockchain/lukso_client.dart';
import 'result.dart';

class QRCode {
  QRCode._sharedInstance();

  static final QRCode _shared = QRCode._sharedInstance();

  factory QRCode() => _shared;

  EthereumAddress? getAddressFromCode(String scannedCode) {
    String addressAsString =
        scannedCode.replaceAll("ethereum:0x", "").split("@").first;
    if (addressAsString.length != 40) return null;
    return EthereumAddress(addressAsString.toBytes());
  }

  String createCodeFromAddress(EthereumAddress address) {
    return "ethereum:0x${address.hexEip55}@${LuksoClient.chainId}";
  }

  Future<(Result, UniversalProfile?)> getUniversalProfile(
      {required String scannedCode, bool validatePermissions = false}) async {
    EthereumAddress? address = getAddressFromCode(scannedCode);
    if (address == null) return (Result.invalidUniversalProfileAddress, null);

    if (validatePermissions) {
      Result validationResult =
          await LuksoClient().validateUniversalProfilePermissions(address);
      if (Result.success != validationResult) return (validationResult, null);
    }

    UniversalProfile? universalProfile =
        await LuksoClient().fetchUniversalProfile(address);
    if (universalProfile == null) {
      return (Result.invalidUniversalProfileData, null);
    }

    return (Result.success, universalProfile);
  }
}
