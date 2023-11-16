import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:ndef/utilities.dart';
import 'dart:convert';
import 'package:phygital/contracts/PhygitalAsset.g.dart';
import 'package:pointycastle/api.dart';
import 'package:web3dart/web3dart.dart';

import '../model/phygital.dart';

class LuksoClient extends ChangeNotifier {
  static const String rpcUrl = "https://rpc.testnet.lukso.gateway.fm";
  static const String ipfsGatewayUrl = "https://2eff.lukso.dev/ipfs/";
  static const int chainId = 4201;

  static final keccak256HashValue = "6f357c6a".toBytes();
  static final phygitalAssetCollectionUriKey =
      "4eff76d745d12fd5e5f7b38e8f396dd0d099124739e69a289ca1faa7ebc53768"
          .toBytes();

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
      throw Exception("Only Keccak256 hashed JSON urls are supported");
    }
    Uint8List jsonHash = lsp2JsonUrl.sublist(4, 36);
    String url = utf8.decode(lsp2JsonUrl.sublist(36));
    if (url.startsWith("ipfs://")) {
      url = "$ipfsGatewayUrl${url.substring(7)}";
    }

    if (kDebugMode) {
      print("URL $url");
    }

    Response response = await _httpClient.get(Uri.parse(url));
    String jsonStringified = utf8
        .decode(response.bodyBytes)
        .replaceAll(RegExp(r"\s+\b|\b\s|\s|\b"), "");
    Uint8List calculatedJsonHash = Digest('Keccak/256')
        .process(Uint8List.fromList(utf8.encode(jsonStringified)));

    if (jsonHash.toHexString() != calculatedJsonHash.toHexString()) {
      throw Exception("JSON hash validation failed");
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

  Future<MintResult> mint(Phygital phygital) async {
    BigInt? nonce = await _getNonceOfPhygital(phygital);
    if (nonce == null) return MintResult.fail;
    if (nonce.compareTo(BigInt.from(0)) != 0) return MintResult.alreadyMinted;

    if (!(await _isPhygitalInCollection(phygital))) {
      return MintResult.notPartOfCollection;
    }

    return MintResult.success;
  }
}

enum MintResult {
  success,
  alreadyMinted,
  notMintedYet,
  notPartOfCollection,
  fail
}
