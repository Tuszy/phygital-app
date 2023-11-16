import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:ndef/utilities.dart';
import 'dart:convert';
import 'package:phygital/contracts/PhygitalAsset.g.dart';
import 'package:phygital/contracts/UniversalProfile.g.dart';
import 'package:phygital/service/backend_client.dart';
import 'package:pointycastle/api.dart';
import 'package:web3dart/web3dart.dart';

import '../model/phygital.dart';
import 'nfc.dart';

class LuksoClient extends ChangeNotifier {
  static const String backendUrl =
      "http://192.168.178.70:8888"; // TODO change after tests
  static const String rpcUrl = "https://rpc.testnet.lukso.gateway.fm";
  static const String ipfsGatewayUrl = "https://2eff.lukso.dev/ipfs/";
  static const int chainId = 4201;

  static final mintEndpoint = Uri.parse("$backendUrl/api/mint");
  static final verifyOwnershipAfterTransferEndpoint =
      Uri.parse("$backendUrl/api/verify-ownership-after-transfer");
  static final transferEndpoint = Uri.parse(
      "$backendUrl/api/transfer"); // TODO remove if not used - deadline issue
  static final createEndpoint = Uri.parse("$backendUrl/api/create");

  static final keccak256HashValue = "6f357c6a".toBytes();
  static final universalProfileInterfaceId = "24871b3d".toBytes();
  static final lsp6KeyManagerInterfaceId = "23f34c62".toBytes();
  static final phygitalAssetInterfaceId = "f6021190".toBytes();
  static final phygitalAssetCollectionUriKey =
      "4eff76d745d12fd5e5f7b38e8f396dd0d099124739e69a289ca1faa7ebc53768"
          .toBytes();

  static final controllerKey =
      EthereumAddress("Ac11803507C05A21daAF9D354F7100B1dC9CD590".toBytes());
  static final necessaryPermissions = {
    "keys": [
      "0x4b80742de2bf82acb3630000ac11803507c05a21daaf9d354f7100b1dc9cd590",
      // Call & SetData
      "0x4b80742de2bf393a64c70000ac11803507c05a21daaf9d354f7100b1dc9cd590",
      // Call Phygital Asset Functions: mint, verifyOwnershipAfterTransfer and transfer
      "0x4b80742de2bf866c29110000ac11803507c05a21daaf9d354f7100b1dc9cd590",
      // SetData LSP12IssuedAssets array and map
    ],
    "values": [
      // assign permissions to controller key
      "0x0000000000000000000000000000000000000000000000000000000000040800",
      "0x002000000002fffffffffffffffffffffffffffffffffffffffff602119031646613002000000002fffffffffffffffffffffffffffffffffffffffff602119041b3d513002000000002fffffffffffffffffffffffffffffffffffffffff6021190511b6952",
      "0x00107c8c3416d6cda87cd42c71ea1843df28000c74ac2555c10b9349e78f0000",
    ],
  };

  LuksoClient._sharedInstance();

  static final LuksoClient _shared = LuksoClient._sharedInstance();

  factory LuksoClient() {
    if (_shared._initialized) return _shared;

    _shared._web3client = Web3Client(rpcUrl, _shared._httpClient);
    _shared._initialized = true;
    return _shared;
  }

  bool _initialized = false;
  final Client _httpClient = Client();
  Web3Client? _web3client;

  Future<String> _fetchLsp2JsonUrl(Uint8List lsp2JsonUrl) async {
    // bytes4 hash func + bytes32 hashed json value (+ bytes7 'ipfs://')
    Uint8List hashFunc = lsp2JsonUrl.sublist(0, 4);
    if (hashFunc.toHexString() != keccak256HashValue.toHexString()) {
      throw "Only Keccak256 hashed JSON urls are supported";
    }
    Uint8List jsonHash = lsp2JsonUrl.sublist(4, 36);
    String url = utf8.decode(lsp2JsonUrl.sublist(36));
    if (url.startsWith("ipfs://")) {
      url = "$ipfsGatewayUrl${url.substring(7)}";
    }

    Response response = await _httpClient.get(Uri.parse(url));
    String jsonStringified = utf8
        .decode(response.bodyBytes)
        .replaceAll(RegExp(r"\s+\b|\b\s|\s|\b"), "");
    Uint8List calculatedJsonHash = Digest('Keccak/256')
        .process(Uint8List.fromList(utf8.encode(jsonStringified)));

    if (jsonHash.toHexString() != calculatedJsonHash.toHexString()) {
      throw "JSON hash validation failed";
    }

    return jsonStringified;
  }

  Future<List<EthereumAddress>> _fetchCollection(Uint8List lsp2JsonUrl) async {
    String json = await _fetchLsp2JsonUrl(lsp2JsonUrl);
    List rawCollection = jsonDecode(json) as List;
    List<EthereumAddress> formattedCollection = rawCollection
        .map((address) =>
            EthereumAddress(ByteUtils.hexStringToBytes(address.substring(2))))
        .toList();
    return formattedCollection;
  }

  Future<BigInt?> _getNonceOfPhygital(Phygital phygital) async {
    if (!_initialized || phygital.contractAddress == null) return null;

    try {
      PhygitalAsset contract = PhygitalAsset(
          address: phygital.contractAddress!, client: _web3client!);
      return await contract.nonce(phygital.id);
    } catch (e) {
      if (kDebugMode) {
        print(
            "Failed to get nonce for the phygital ${phygital.address.hexEip55} ($e)");
      }
      return null;
    }
  }

  Future<bool> _isPhygitalInCollection(Phygital phygital) async {
    if (!_initialized || phygital.contractAddress == null) return false;

    try {
      PhygitalAsset contract = PhygitalAsset(
          address: phygital.contractAddress!, client: _web3client!);
      Uint8List lsp2JsonUrl =
          await contract.getData(phygitalAssetCollectionUriKey);
      List<EthereumAddress> collection = await _fetchCollection(lsp2JsonUrl);
      if (kDebugMode) {
        print("Phygital collection: $collection");
      }
      return collection.contains(phygital.address);
    } catch (e) {
      if (kDebugMode) {
        print(
            "Failed to check if the phygital ${phygital.address.hexEip55} is part of the collection ${phygital.contractAddress!.hexEip55} ($e)");
      }
      return false;
    }
  }

  Future<void> _throwIfAddressOfPhygitalAssetContractIsInvalid(
      EthereumAddress? address) async {
    if (!_initialized) return;

    if (address != null) {
      try {
        PhygitalAsset contract =
            PhygitalAsset(address: address, client: _web3client!);
        if (await contract.supportsInterface(phygitalAssetInterfaceId)) {
          return;
        }
      } catch (e) {
        if (kDebugMode) {
          print(
              "Failed to check if the address ${address.hexEip55} is a valid PhygitalAsset ($e)");
        }
      }
    }

    throw "Invalid Phygital contract address";
  }

  Future<void> _throwIfAddressOfUniversalProfileIsInvalid(
      EthereumAddress? address) async {
    if (!_initialized) return;

    if (address != null) {
      try {
        UniversalProfile contract =
            UniversalProfile(address: address, client: _web3client!);
        if (await contract.supportsInterface(universalProfileInterfaceId)) {
          return;
        }
      } catch (e) {
        if (kDebugMode) {
          print(
              "Failed to check if the address ${address.hexEip55} is a valid Universal Profile ($e)");
        }
      }
    }
  }

  Future<void>
      _throwIfAddressOfUniversalProfileHasNotTheNecessaryPermissionsSet(
          EthereumAddress? address) async {
    if (!_initialized) return;
    await _throwIfAddressOfUniversalProfileIsInvalid(address);

    if (address != null) {
      try {
        UniversalProfile contract =
            UniversalProfile(address: address, client: _web3client!);
        if (await contract.supportsInterface(universalProfileInterfaceId)) {
          return;
        }
      } catch (e) {
        if (kDebugMode) {
          print(
              "Failed to check if the Universal Profile ${address.hexEip55} has set the necessary permissions ($e)");
        }
      }
    }

    throw "Please set the necessary permissions on the Universal Profile";
  }

  Future<MintResult> mint(
      Phygital phygital, EthereumAddress universalProfileAddress) async {
    if (!_initialized) return MintResult.fail;

    if (phygital.contractAddress == null) return MintResult.notPartOfAnyCollection;
    await _throwIfAddressOfPhygitalAssetContractIsInvalid(
        phygital.contractAddress);
    await _throwIfAddressOfUniversalProfileHasNotTheNecessaryPermissionsSet(
        universalProfileAddress);

    BigInt? nonce = await _getNonceOfPhygital(phygital);
    if (nonce == null) return MintResult.fail;
    if (nonce.compareTo(BigInt.from(0)) != 0) return MintResult.alreadyMinted;

    if (!(await _isPhygitalInCollection(phygital))) {
      return MintResult.notPartOfCollection;
    }

    String? phygitalSignature = await NFC()
        .signUniversalProfileAddress(universalProfileAddress, nonce.toInt());
    if (phygitalSignature == null) return MintResult.signingFailed;

    if (await BackendClient().mint(
        universalProfileAddress: universalProfileAddress,
        phygitalSignature: phygitalSignature,
        phygital: phygital)) {
      return MintResult.success;
    }

    return MintResult.fail;
  }
}

enum MintResult {
  success,
  alreadyMinted,
  notPartOfCollection,
  notPartOfAnyCollection,
  signingFailed,
  fail
}

String getErrorMessageForMintResult(MintResult mintResult){
  switch(mintResult){
    case MintResult.success: return "Successfully minted Phygital.";
    case MintResult.alreadyMinted: return "Phygital has already been minted.";
    case MintResult.notPartOfCollection: return "Phygital is not part of the set collection.\nPlease check the contract address.";
    case MintResult.notPartOfAnyCollection: return "Phygital is not part of any collection.\nNo contract address found.";
    case MintResult.signingFailed: return "Creating phygital signature failed. Try again";
    case MintResult.fail: return "Unknown error occurred during minting. Try again.";
  }
}
