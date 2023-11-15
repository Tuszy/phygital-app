import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/utilities.dart';
import 'package:pointycastle/api.dart';

import 'NFC.dart';

typedef NFCTagCommandFunction = Future<dynamic> Function(
    NFCTag tag, Phygital phygital);

class Phygital {
  static const String uri = "phygital.tuszy.com";
  static const String ndefUriIdentifier = "U";
  static const String ndefTextIdentifier = "T";
  static const int lengthExcludingContractAddressNdefRecord = 2;
  static const int lengthIncludingContractAddressNdefRecord = 3;
  static const int uriNdefIndex = 0;
  static const int phygitalAddressNdefIndex = 1;
  static const int contractAddressNdefIndex = 2;

  static const int luksoAddressLength = 42;

  Phygital._({required this.address, required this.contractAddress});

  final String address;
  final String? contractAddress;

  static Future<dynamic> _startNFCCommunication(
      NFCTagCommandFunction nfcTagCommandFunction) async {
    if (!NFC().isAvailable) throw Exception("NFC is not available");

    try {
      NFCTag tag = await FlutterNfcKit.poll(
          iosAlertMessage: "Hold your iPhone near the Phygital");
      await FlutterNfcKit.setIosAlertMessage("Reading Phygital");
      Phygital? phygital = await _validate(tag);

      if (phygital == null) throw Exception("This is not a valid Phygital");

      sleep(const Duration(seconds: 2)); // Energy harvesting for MCU

      var result = await nfcTagCommandFunction(tag, phygital);
      await FlutterNfcKit.finish(iosAlertMessage: "Succeeded!");
      return result;
    } catch (e) {
      await FlutterNfcKit.finish(iosAlertMessage: "Failed!");
      throw Exception(e.toString());
    }
  }

  static Future<Phygital?> _validate(NFCTag tag) async {
    if (NFCTagType.iso15693 != tag.type ||
        "ISO 15693" != tag.standard ||
        !(tag.ndefAvailable ?? false)) return null;

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
    if (Phygital.uri != uri) return null;

    String address = String.fromCharCodes(
        ndefRecords[phygitalAddressNdefIndex].payload!.sublist(3));
    String? contractAddress =
        ndefRecords.length == lengthIncludingContractAddressNdefRecord
            ? String.fromCharCodes(
                ndefRecords[contractAddressNdefIndex].payload!.sublist(3))
            : null;

    return Phygital._(address: address, contractAddress: contractAddress);
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
    Uint8List signMessageCommand =
        Uint8List.fromList("02aa022000".toBytes() + hashedMessage);
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

  static Future<String> signUniversalProfileAddress(
      String universalProfileAddress, int nonce) async {
    if (universalProfileAddress.length != luksoAddressLength ||
        nonce < 0) throw Exception("Invalid Universal Profile Address");

    return await _startNFCCommunication((NFCTag tag, Phygital phygital) async {
      String errorMessage = "Failed to sign the universal profile address";

      Uint8List universalProfileAddressAsBytes = universalProfileAddress.substring(2).toBytes();
      bool isSent = false;
      for (var i = 0; i < 20 && !isSent; i++) {
        sleep(const Duration(milliseconds: 500));
        isSent = await phygital._sendMessageToSign(
            universalProfileAddressAsBytes, nonce);
      }
      if (!isSent) {
        throw Exception(errorMessage);
      }

      bool isAvailable = false;
      for (var i = 0; i < 20 && !isAvailable; i++) {
        sleep(const Duration(milliseconds: 500));
        isAvailable = await phygital._isMessageAvailable();
      }
      if (!isAvailable) {
        throw Exception(errorMessage);
      }

      var message = await phygital._readMessage();
      if (message == null) {
        throw Exception(errorMessage);
      }

      String signature = message.sublist(1).toHexString();
      if (kDebugMode) print("Signature $signature");

      return signature;
    });
  }

  Future<bool> _sendContractAddressToWrite(Uint8List contractAddress) async {
    Uint8List writeContractAddressCommand = Uint8List.fromList(
        "02aa022A01".toBytes() + contractAddress);
    if (kDebugMode) {
      print(
          "Writing contract address $contractAddress: ${writeContractAddressCommand.toHexString()}");
    }
    var value = await FlutterNfcKit.transceive(writeContractAddressCommand);
    if (kDebugMode) {
      print("Response: ${value.toHexString()}");
    }

    return value[0] == 0;
  }

  static Future<void> setContractAddress(
      String contractAddress) async {
    if (contractAddress.length != luksoAddressLength) throw Exception("Invalid Contract Address");

    return await _startNFCCommunication((NFCTag tag, Phygital phygital) async {
      String errorMessage = "Failed to set the contract address";

      bool isSent = false;
      for (var i = 0; i < 20 && !isSent; i++) {
        sleep(const Duration(milliseconds: 500));
        isSent = await phygital._sendContractAddressToWrite(Uint8List.fromList(utf8.encode(contractAddress)));
      }
      if (!isSent) {
        throw Exception(errorMessage);
      }

      bool isAvailable = false;
      for (var i = 0; i < 20 && !isAvailable; i++) {
        sleep(const Duration(milliseconds: 500));
        isAvailable = await phygital._isMessageAvailable();
      }
      if (!isAvailable) {
        throw Exception(errorMessage);
      }

      var message = await phygital._readMessage();
      if (message == null) {
        throw Exception(errorMessage);
      }

      if(message[0] != 0x01) throw Exception(errorMessage);
    });
  }



  @override
  String toString() {
    return "Phygital Address: $address\n${contractAddress != null ? "Contract Address: $contractAddress\n" : ""}";
  }
}
