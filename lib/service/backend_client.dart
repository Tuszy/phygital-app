import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:ndef/utilities.dart';
import 'dart:convert';
import 'package:web3dart/web3dart.dart';

import '../model/lsp4/lsp4_metadata.dart';
import '../model/phygital.dart';
import 'blockchain/result.dart';

class BackendClient extends ChangeNotifier {
  static const String backendUrl =
      "http://192.168.178.70:8888"; // TODO change after tests

  static const contentTypeApplicationJson = {
    "Content-Type": "application/json"
  };

  static final mintEndpoint = Uri.parse("$backendUrl/api/mint");
  static final verifyOwnershipAfterTransferEndpoint =
      Uri.parse("$backendUrl/api/verify-ownership-after-transfer");
  static final transferEndpoint = Uri.parse("$backendUrl/api/transfer");
  static final createEndpoint = Uri.parse("$backendUrl/api/create");

  BackendClient._sharedInstance();

  static final BackendClient _shared = BackendClient._sharedInstance();

  factory BackendClient() => _shared;

  final Client _httpClient = Client();

  Future<Result> mint(
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
        print("Mint response: $jsonObject");
      }
      if (response.statusCode == 200) {
        return Result.mintSucceeded;
      } else {
        return mapContractErrorCodeToResult(jsonObject["error"] as String);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error while parsing mint response: $e");
      }
    }

    return Result.mintFailed;
  }

  Future<Result> verifyOwnershipAfterTransfer(
      {required EthereumAddress universalProfileAddress,
      required String phygitalSignature,
      required Phygital phygital}) async {
    var data = {
      "universal_profile_address": universalProfileAddress.hexEip55,
      "phygital_asset_contract_address": phygital.contractAddress!.hexEip55,
      "phygital_address": phygital.address.hexEip55,
      "phygital_signature": "0x$phygitalSignature"
    };
    Response response = await _httpClient.post(
        verifyOwnershipAfterTransferEndpoint,
        headers: contentTypeApplicationJson,
        body: json.encode(data));
    String jsonStringified = utf8.decode(response.bodyBytes);
    try {
      var jsonObject = json.decode(jsonStringified);
      if (kDebugMode) {
        print("Ownership verification response: $jsonObject");
      }
      if (response.statusCode == 200) {
        return Result.ownershipVerificationSucceeded;
      } else {
        return mapContractErrorCodeToResult(jsonObject["error"] as String);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error while parsing ownership verification response: $e");
      }
    }

    return Result.ownershipVerificationFailed;
  }

  Future<Result> transfer(
      {required EthereumAddress universalProfileAddress,
      required EthereumAddress toUniversalProfileAddress,
      required String phygitalSignature,
      required Phygital phygital}) async {
    var data = {
      "universal_profile_address": universalProfileAddress.hexEip55,
      "to_universal_profile_address": toUniversalProfileAddress.hexEip55,
      "phygital_asset_contract_address": phygital.contractAddress!.hexEip55,
      "phygital_address": phygital.address.hexEip55,
      "phygital_signature": "0x$phygitalSignature"
    };
    Response response = await _httpClient.post(transferEndpoint,
        headers: contentTypeApplicationJson, body: json.encode(data));
    String jsonStringified = utf8.decode(response.bodyBytes);
    try {
      var jsonObject = json.decode(jsonStringified);
      if (kDebugMode) {
        print("Transfer response: $jsonObject");
      }
      if (response.statusCode == 200) {
        return Result.transferSucceeded;
      } else {
        return mapContractErrorCodeToResult(jsonObject["error"] as String);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error while parsing transfer response: $e");
      }
    }

    return Result.transferFailed;
  }

  Future<(Result, EthereumAddress?)> create(
      {required EthereumAddress universalProfileAddress,
      required String name,
      required String symbol,
      required List<EthereumAddress> phygitalCollection,
      required LSP4Metadata metadata,
      required String baseUri}) async {
    var data = {
      "universal_profile_address": universalProfileAddress.hexEip55,
      "name": name,
      "symbol": symbol,
      "phygital_collection":
          phygitalCollection.map((EthereumAddress address) => address.hexEip55),
      "metadata": jsonEncode(metadata),
      "base_uri": baseUri
    };
    Response response = await _httpClient.post(createEndpoint,
        headers: contentTypeApplicationJson, body: json.encode(data));
    String jsonStringified = utf8.decode(response.bodyBytes);
    try {
      Map<String, dynamic> jsonObject = json.decode(jsonStringified);
      if (kDebugMode) {
        print("Create response: $jsonObject");
      }
      if (response.statusCode == 200 &&
          jsonObject.containsKey("contractAddress")) {
        return (
          Result.createSucceeded,
          EthereumAddress((jsonObject["contractAddress"] as String).toBytes())
        );
      } else {
        return (
          mapContractErrorCodeToResult(jsonObject["error"] as String),
          null
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error while parsing create response: $e");
      }
    }

    return (Result.createFailed, null);
  }
}
