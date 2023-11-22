import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/utilities.dart';
import 'package:pointycastle/api.dart';
import 'package:web3dart/credentials.dart';

import '../model/phygital/phygital_tag.dart';

typedef NFCTagCommandFunction = Future<dynamic> Function(
    NFCTag tag, PhygitalTag phygitalTag);

class NFC extends ChangeNotifier {
  NFC._sharedInstance();

  static final NFC _shared = NFC._sharedInstance();

  factory NFC() => _shared;

  NFCAvailability _availability = NFCAvailability.not_supported;

  bool get isAvailable => _availability == NFCAvailability.available;

  bool _active = false;

  bool get isActive => _active;

  set active(bool newValue) {
    _active = newValue;
    notifyListeners();
  }

  static const String uri = "phygital.tuszy.com";

  static const String ndefUriIdentifier = "U";
  static const String ndefTextIdentifier = "T";

  static const int lengthExcludingContractAddressNdefRecord = 2;
  static const int lengthIncludingContractAddressNdefRecord = 3;

  static const int uriNdefIndex = 0;
  static const int phygitalAddressNdefIndex = 1;
  static const int contractAddressNdefIndex = 2;

  static const int luksoAddressLength = 42;

  static const int retryCount = 20;
  static const Duration retryDelay = Duration(milliseconds: 500);

  static const String signMessageHashCommandId = "00";
  static const String setContractAddressCommandId = "01";

  Future<void> init() async {
    try {
      _availability = await FlutterNfcKit.nfcAvailability;
    } on PlatformException {
      _availability = NFCAvailability.not_supported;
    }

    notifyListeners();
  }

  Future<dynamic> _startNFCCommunication({
    required String message,
    String? successMessage,
    String? failMessage,
    Duration? energyHarvestingDuration,
    Set<PhygitalTag>? expectedPhygitals,
    bool? mustHaveContractAddress,
    bool? mustNotHaveContractAddress,
    required NFCTagCommandFunction nfcTagCommandFunction,
  }) async {
    if (!isAvailable) throw "NFC is not available";

    try {
      active = true;

      NFCTag tag = await FlutterNfcKit.poll(
        iosAlertMessage: "Hold your iPhone near the Phygital",
      );

      PhygitalTag tagWrapper = PhygitalTag(
        address: EthereumAddress("0".padLeft(40, '0').toBytes()),
        tagId: tag.id,
      );

      if (expectedPhygitals != null &&
          !expectedPhygitals.contains(tagWrapper)) {
        throw "Unexpected Phygital detected.";
      }
      await FlutterNfcKit.setIosAlertMessage(message);

      PhygitalTag? phygital =
          expectedPhygitals?.lookup(tagWrapper) ?? await _validate(tag);
      if (phygital == null) {
        throw "This is not a valid Phygital";
      }

      if (mustHaveContractAddress == true && phygital.contractAddress == null) {
        throw "Unassigned Phygital";
      } else if (mustNotHaveContractAddress == true &&
          phygital.contractAddress != null) {
        throw "Phygital is already assigned to a collection";
      }

      if (energyHarvestingDuration != null) sleep(energyHarvestingDuration);

      var result = await nfcTagCommandFunction(tag, phygital);

      active = false;

      await FlutterNfcKit.finish(
          iosAlertMessage: successMessage ?? "Succeeded!");

      return result;
    } catch (e) {
      if (kDebugMode) print("NFC communication failed ($e)");
      active = false;
      await FlutterNfcKit.finish(iosAlertMessage: failMessage ?? "Failed!");
      if (e is PlatformException) {
        if (e.code == "409") {
          throw "You have cancelled the NFC communication"; // User cancelled
        } else if (e.code == "500") {
          throw "Phygital connection lost.\nPlease hold your mobile phone as close as possible while processing.";
        }
      }
      rethrow;
    }
  }

  Future<PhygitalTag?> _validate(NFCTag tag) async {
    if (NFCTagType.iso15693 != tag.type ||
        "ISO 15693" != tag.standard ||
        !(tag.ndefAvailable ?? false)) return null;

    try {
      var ndefRecords = await FlutterNfcKit.readNDEFRecords();

      if (ndefRecords.length != lengthExcludingContractAddressNdefRecord &&
          ndefRecords.length != lengthIncludingContractAddressNdefRecord) {
        return null;
      }

      if (ndefRecords[uriNdefIndex].decodedType != ndefUriIdentifier ||
          ndefRecords[phygitalAddressNdefIndex].decodedType !=
              ndefTextIdentifier ||
          (ndefRecords.length == lengthIncludingContractAddressNdefRecord &&
              ndefRecords[contractAddressNdefIndex].decodedType !=
                  ndefTextIdentifier)) {
        return null;
      }

      String uri =
          String.fromCharCodes(ndefRecords[uriNdefIndex].payload!.sublist(1));
      if (NFC.uri != uri) return null;

      EthereumAddress address = EthereumAddress(String.fromCharCodes(
              ndefRecords[phygitalAddressNdefIndex].payload!.sublist(5))
          .toBytes());

      EthereumAddress? contractAddress =
          ndefRecords.length == lengthIncludingContractAddressNdefRecord
              ? EthereumAddress(String.fromCharCodes(
                      ndefRecords[contractAddressNdefIndex].payload!.sublist(5))
                  .toBytes())
              : null;

      return PhygitalTag(
          tagId: tag.id, address: address, contractAddress: contractAddress);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw "Scan failed. Please retry.";
    }
  }

  Future<bool> _isMessageAvailable() async {
    Uint8List readMessageBoxStateCommand = "02ad020d".toBytes();
    if (kDebugMode) {
      print(
          "Reading message state: ${readMessageBoxStateCommand.toHexString()}");
    }
    var value = await FlutterNfcKit.transceive(readMessageBoxStateCommand);
    if (kDebugMode) {
      print("Response: ${value.toHexString()} ${value[1].toRadixString(2)}");
    }

    return value[0] == 0 && (value[1] & 0x02) == 0x02;
  }

  Future<int?> _getMessageLength() async {
    Uint8List readMessageLengthCommand = "02ab02".toBytes();
    if (kDebugMode) {
      print(
          "Reading message length: ${readMessageLengthCommand.toHexString()}");
    }
    var value = await FlutterNfcKit.transceive(readMessageLengthCommand);
    if (kDebugMode) {
      print("Response: ${value.toHexString()}");
    }

    return value[0] == 0 ? value[1] + 1 : null;
  }

  Future<Uint8List?> _readMessage() async {
    Uint8List readMessageCommand = "02ac020000".toBytes();
    if (kDebugMode) {
      print("Reading message: ${readMessageCommand.toHexString()}");
    }
    var value = await FlutterNfcKit.transceive(readMessageCommand);
    if (kDebugMode) {
      print("Response: ${value.toHexString()}");
    }

    return value[0] == 0 ? value.sublist(1) : null;
  }

  Uint8List _hashMessageWithNonce(Uint8List message, int nonce) {
    Uint8List messageConcatenatedWithNonce = Uint8List.fromList(
        message + (nonce.toRadixString(16).padLeft(64, '0')).toBytes());
    final hashedMessage =
        Digest('Keccak/256').process(messageConcatenatedWithNonce);
    return hashedMessage;
  }

  Future<bool> _sendMessageToSign(Uint8List message, int nonce) async {
    Uint8List hashedMessage = _hashMessageWithNonce(message, nonce);
    Uint8List signMessageCommand = Uint8List.fromList("02aa0220".toBytes() +
        signMessageHashCommandId.toBytes() +
        hashedMessage);
    if (kDebugMode) {
      print(
          "Sending message to sign (${hashedMessage.toHexString()}): ${signMessageCommand.toHexString()}");
    }
    var value = await FlutterNfcKit.transceive(signMessageCommand);
    if (kDebugMode) {
      print("Response: ${value.toHexString()}");
    }

    return value[0] == 0;
  }

  Future<String?> signUniversalProfileAddress({
    required String message,
    String? successMessage,
    required PhygitalTag phygitalTag,
    required EthereumAddress universalProfileAddress,
    required int nonce,
  }) async {
    if (nonce < 0) throw "Invalid nonce";

    return await _startNFCCommunication(
      expectedPhygitals: {phygitalTag},
      message: message,
      successMessage: successMessage,
      energyHarvestingDuration: const Duration(seconds: 2),
      nfcTagCommandFunction: (NFCTag tag, PhygitalTag phygitalTag) async {
        String errorMessage = "Failed to sign the universal profile address";

        bool isSent = false;
        for (int i = 0; i < retryCount && !isSent; i++) {
          sleep(retryDelay);
          isSent = await _sendMessageToSign(
              universalProfileAddress.addressBytes, nonce);
        }
        if (!isSent) {
          throw errorMessage;
        }

        bool isAvailable = false;
        for (int i = 0; i < retryCount && !isAvailable; i++) {
          sleep(retryDelay);
          isAvailable = await _isMessageAvailable();
        }
        if (!isAvailable) {
          throw errorMessage;
        }

        Uint8List? message = await _readMessage();
        if (message == null) {
          throw errorMessage;
        }

        String signature = message.sublist(1).toHexString();
        if (kDebugMode) print("Signature $signature");

        return signature;
      },
    );
  }

  Future<bool> _sendContractAddressToWrite(Uint8List contractAddress) async {
    Uint8List writeContractAddressCommand = Uint8List.fromList(
        "02aa022A".toBytes() +
            setContractAddressCommandId.toBytes() +
            contractAddress);
    if (kDebugMode) {
      print(
          "Writing contract address $contractAddress: ${writeContractAddressCommand.toHexString()}");
    }
    Uint8List value =
        await FlutterNfcKit.transceive(writeContractAddressCommand);
    if (kDebugMode) {
      print("Response: ${value.toHexString()}");
    }

    return value[0] == 0;
  }

  Future<PhygitalTag?> setContractAddress({
    required Set<PhygitalTag> phygitalTags,
    required EthereumAddress contractAddress,
  }) async {
    return await _startNFCCommunication(
      expectedPhygitals: phygitalTags,
      message: "Assigning collection",
      successMessage: "Collection assigned",
      energyHarvestingDuration: const Duration(seconds: 2),
      nfcTagCommandFunction: (NFCTag tag, PhygitalTag? phygitalTag) async {
        String errorMessage = "Failed to set the contract address";
        Uint8List contractAddressAsBytes =
            Uint8List.fromList(utf8.encode(contractAddress.hexEip55));

        bool isSent = false;
        for (int i = 0; i < retryCount && !isSent; i++) {
          sleep(retryDelay);
          isSent = await _sendContractAddressToWrite(contractAddressAsBytes);
        }
        if (!isSent) {
          throw errorMessage;
        }

        bool isAvailable = false;
        for (int i = 0; i < retryCount && !isAvailable; i++) {
          sleep(retryDelay);
          isAvailable = await _isMessageAvailable();
        }
        if (!isAvailable) {
          throw errorMessage;
        }

        Uint8List? message = await _readMessage();
        if (message == null) {
          throw errorMessage;
        }

        if (message[0] != setContractAddressCommandId.toBytes()[0]) {
          throw errorMessage;
        }

        return phygitalTag;
      },
    );
  }

  Future<PhygitalTag> read(
      {bool? mustHaveContractAddress, bool? mustNotHaveContractAddress}) async {
    return await _startNFCCommunication(
      message: "Validating Phygital",
      successMessage: "Valid Phygital Detected",
      mustHaveContractAddress: mustHaveContractAddress,
      mustNotHaveContractAddress: mustNotHaveContractAddress,
      nfcTagCommandFunction: (NFCTag tag, PhygitalTag phygitalTag) async =>
          phygitalTag,
    );
  }
}
