import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:ndef/utilities.dart';
import 'dart:convert';
import 'package:phygital/contracts/PhygitalAsset.g.dart';
import 'package:phygital/contracts/UniversalProfile.g.dart';
import 'package:pointycastle/api.dart';
import 'package:web3dart/web3dart.dart';

import '../model/phygital.dart';
import 'nfc.dart';

class BackendClient extends ChangeNotifier {
  static const String backendUrl =
      "http://192.168.178.70:8888"; // TODO change after tests

  static const contentTypeApplicationJson = {
    "Content-Type": "application/json"
  };

  static final mintEndpoint = Uri.parse("$backendUrl/api/mint");
  static final verifyOwnershipAfterTransferEndpoint =
      Uri.parse("$backendUrl/api/verify-ownership-after-transfer");
  static final transferEndpoint = Uri.parse(
      "$backendUrl/api/transfer"); // TODO remove if not used - deadline issue
  static final createEndpoint = Uri.parse("$backendUrl/api/create");

  BackendClient._sharedInstance();

  static final BackendClient _shared = BackendClient._sharedInstance();

  factory BackendClient() => _shared;

  final Client _httpClient = Client();

  Future<bool> mint(
      {required EthereumAddress universalProfileAddress,
      required String phygitalSignature,
      required Phygital phygital}) async {
    var data = {
      "universal_profile_address": universalProfileAddress.hexEip55,
      "phygital_asset_contract_address": phygital.contractAddress!.hexEip55,
      "phygital_address": phygital.address.hexEip55,
      "phygital_signature": "0x$phygitalSignature"
    };
    Response response = await _httpClient.post(mintEndpoint,
        headers: contentTypeApplicationJson, body: json.encode(data));
    String jsonStringified = utf8.decode(response.bodyBytes);
    try {
      var jsonObject = json.decode(jsonStringified);
      if (kDebugMode) {
        print("Mint receipt: $jsonObject");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error while parsing mint receipt: $e");
      }
    }

    return response.statusCode == 200;
  }
}

enum MintResult {
  success,
  alreadyMinted,
  notMintedYet,
  notPartOfCollection,
  signingFailed,
  fail
}
