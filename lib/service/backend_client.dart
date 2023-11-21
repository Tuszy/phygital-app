import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/service/global_state.dart';
import 'package:phygital/service/ipfs_client.dart';
import 'dart:convert';
import 'package:web3dart/web3dart.dart';

import '../model/lsp4/lsp4_metadata.dart';
import '../model/phygital/phygital_tag.dart';
import 'result.dart';

class BackendClient extends ChangeNotifier {
  static const String backendUrl =
      "http://192.168.178.70:8888"; // TODO change after tests

  static contentTypeApplicationJson({String? jwt}) => {
        "Content-Type": "application/json",
        if (jwt != null || GlobalState().jwt != null)
          "Authorization": "Bearer ${jwt ?? GlobalState().jwt}"
      };

  static final verifyLoginTokenEndpoint =
      Uri.parse("$backendUrl/api/verify-token");
  static final mintEndpoint = Uri.parse("$backendUrl/api/mint");
  static final verifyOwnershipAfterTransferEndpoint =
      Uri.parse("$backendUrl/api/verify-ownership-after-transfer");
  static final transferEndpoint = Uri.parse("$backendUrl/api/transfer");
  static final createEndpoint = Uri.parse("$backendUrl/api/create");

  BackendClient._sharedInstance();

  static final BackendClient _shared = BackendClient._sharedInstance();

  factory BackendClient() => _shared;

  final Client _httpClient = Client();

  Future<bool> verifyLoginToken({
    required EthereumAddress universalProfileAddress,
    required String jwt,
  }) async {
    var data = {"universal_profile_address": universalProfileAddress.hexEip55};

    Response response = await _httpClient.post(verifyLoginTokenEndpoint,
        headers: contentTypeApplicationJson(jwt: jwt), body: json.encode(data));

    return response.statusCode == 200;
  }

  Future<Result> mint({
    required EthereumAddress universalProfileAddress,
    required String phygitalSignature,
    required PhygitalTag phygitalTag,
  }) async {
    var data = {
      "universal_profile_address": universalProfileAddress.hexEip55,
      "phygital_asset_contract_address": phygitalTag.contractAddress!.hexEip55,
      "phygital_address": phygitalTag.address.hexEip55,
      "phygital_signature": "0x$phygitalSignature"
    };
    Response response = await _httpClient.post(mintEndpoint,
        headers: contentTypeApplicationJson(), body: json.encode(data));
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

  Future<Result> verifyOwnershipAfterTransfer({
    required EthereumAddress universalProfileAddress,
    required String phygitalSignature,
    required PhygitalTag phygitalTag,
  }) async {
    var data = {
      "universal_profile_address": universalProfileAddress.hexEip55,
      "phygital_asset_contract_address": phygitalTag.contractAddress!.hexEip55,
      "phygital_address": phygitalTag.address.hexEip55,
      "phygital_signature": "0x$phygitalSignature"
    };
    Response response = await _httpClient.post(
        verifyOwnershipAfterTransferEndpoint,
        headers: contentTypeApplicationJson(),
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

  Future<Result> transfer({
    required EthereumAddress universalProfileAddress,
    required EthereumAddress toUniversalProfileAddress,
    required String phygitalSignature,
    required PhygitalTag phygitalTag,
  }) async {
    var data = {
      "universal_profile_address": universalProfileAddress.hexEip55,
      "to_universal_profile_address": toUniversalProfileAddress.hexEip55,
      "phygital_asset_contract_address": phygitalTag.contractAddress!.hexEip55,
      "phygital_address": phygitalTag.address.hexEip55,
      "phygital_signature": "0x$phygitalSignature"
    };
    Response response = await _httpClient.post(transferEndpoint,
        headers: contentTypeApplicationJson(), body: json.encode(data));
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

  Future<(Result, EthereumAddress?)> create({
    required EthereumAddress universalProfileAddress,
    required String name,
    required String symbol,
    required List<PhygitalTag> phygitalCollection,
    required LSP4Metadata metadata,
  }) async {
    (String, String)? uploadedMetadataResult = await metadata.uploadToIpfs(
        name: name,
        symbol: symbol,
        universalProfileAddress: universalProfileAddress);
    if (uploadedMetadataResult == null) {
      return (Result.uploadingLSP4MetadataFailed, null);
    }

    String? baseUri = await IpfsClient()
        .uploadLSP4MetadataForPhygitals(metadata, phygitalCollection);
    if (baseUri == null) return (Result.uploadingLSP4MetadataFailed, null);

    var data = {
      "universal_profile_address": universalProfileAddress.hexEip55,
      "name": name,
      "symbol": symbol,
      "phygital_collection": phygitalCollection
          .map((PhygitalTag phygitalTag) => phygitalTag.address.hexEip55)
          .toList(),
      "metadata": uploadedMetadataResult.$2,
      "base_uri": baseUri
    };

    Response response = await _httpClient.post(createEndpoint,
        headers: contentTypeApplicationJson(), body: json.encode(data));
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
          EthereumAddress(
            (jsonObject["contractAddress"] as String).substring(2).toBytes(),
          )
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
