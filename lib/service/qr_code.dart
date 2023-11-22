import 'package:ndef/utilities.dart';
import 'package:phygital/model/lsp0/universal_profile.dart';
import 'package:phygital/service/backend_client.dart';
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

  String? getJWTFromCode(String scannedCode) {
    String jwt = scannedCode.replaceAll("ethereum:0x", "").split(":").last;
    if (jwt.contains("@")) return null;
    return jwt;
  }

  String createCodeFromAddress(EthereumAddress address) {
    return "ethereum:${address.hexEip55}@${LuksoClient.chainId}";
  }

  Future<(Result, UniversalProfile?, String?)> getUniversalProfileWithJWT(
      {required String scannedCode, bool validatePermissions = false}) async {
    EthereumAddress? address = getAddressFromCode(scannedCode);
    if (address == null) {
      return (Result.invalidUniversalProfileAddress, null, null);
    }

    String? jwt = getJWTFromCode(scannedCode);
    if (jwt == null) return (Result.invalidAppLoginQRCode, null, null);
    if (!await BackendClient()
        .verifyLoginToken(universalProfileAddress: address, jwt: jwt)) {
      return (Result.invalidAppLoginQRCode, null, null);
    }

    if (validatePermissions) {
      Result validationResult =
          await LuksoClient().validateUniversalProfilePermissions(
        address: address,
      );
      if (Result.success != validationResult) {
        return (validationResult, null, null);
      }
    }

    UniversalProfile? universalProfile =
        await LuksoClient().fetchUniversalProfile(
      universalProfileAddress: address,
    );
    if (universalProfile == null) {
      return (Result.invalidUniversalProfileData, null, null);
    }

    return (Result.success, universalProfile, jwt);
  }

  Future<(Result, UniversalProfile?)> getUniversalProfile(
      {required String scannedCode, bool validatePermissions = false}) async {
    EthereumAddress? address = getAddressFromCode(scannedCode);
    if (address == null) {
      return (Result.invalidUniversalProfileAddress, null);
    }

    if (validatePermissions) {
      Result validationResult =
          await LuksoClient().validateUniversalProfilePermissions(
        address: address,
      );
      if (Result.success != validationResult) {
        return (validationResult, null);
      }
    }

    UniversalProfile? universalProfile =
        await LuksoClient().fetchUniversalProfile(
      universalProfileAddress: address,
    );
    if (universalProfile == null) {
      return (Result.invalidUniversalProfileData, null);
    }

    return (Result.success, universalProfile);
  }
}
