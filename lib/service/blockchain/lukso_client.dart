import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/model/lsp4/lsp4_metadata.dart';
import 'package:phygital/model/phygital_with_data.dart';
import 'dart:convert';
import 'package:phygital/service/backend_client.dart';
import 'package:phygital/service/blockchain/contracts/LSP0ERC725Account.g.dart';
import 'package:phygital/service/result.dart';
import 'package:phygital/service/ipfs_client.dart';
import 'package:phygital/util/lsp2_utils.dart';
import 'package:web3dart/web3dart.dart';

import '../../model/phygital.dart';
import '../../model/lsp0/universal_profile.dart';
import '../nfc.dart';
import 'contracts/PhygitalAsset.g.dart';

class LuksoClient extends ChangeNotifier {
  static const String rpcUrl = "https://rpc.testnet.lukso.gateway.fm";
  static const int chainId = 4201;

  static final universalProfileInterfaceId = "24871b3d".toBytes();
  static final lsp6KeyManagerInterfaceId = "23f34c62".toBytes();
  static final phygitalAssetInterfaceId = "f6021190".toBytes();
  static final phygitalAssetCollectionUriKey =
      "4eff76d745d12fd5e5f7b38e8f396dd0d099124739e69a289ca1faa7ebc53768"
          .toBytes();
  static final universalProfileDataKey =
      "5ef83ad9559033e6e941db7d7c495acdce616347d28e90c7ce47cbfcfcad3bc5"
          .toBytes();
  static final phygitalAssetMetadataKey =
      "9afb95cacc9f95858ec44aa8c3b685511002e30ae54415823f406128b85b238e"
          .toBytes();
  static final phygitalAssetBaseUriKey =
      "1a7628600c3bac7101f53697f48df381ddc36b9015e7d7c9c5633d1252aa2843"
          .toBytes();
  static final phygitalAssetNameKey =
      "deba1e292f8ba88238e10ab3c7f88bd4be4fac56cad5194b6ecceaf653468af1"
          .toBytes();
  static final phygitalAssetSymbolKey =
      "2f0a68ab07768e01943a599e73362a0e17a63a72e94dd2e384d2c1d4db932756"
          .toBytes();
  static final phygitalAssetCreatorsArrayKey =
      "114bd03b3a46d48759680d81ebb2b414fda7d030a7105a851867accf1c2352e7"
          .toBytes();
  static final phygitalAssetCreatorsMapPrefixKey =
      "6de85eaf5d982b4e5da00000".toBytes();

  static final controllerKey =
      EthereumAddress("Ac11803507C05A21daAF9D354F7100B1dC9CD590".toBytes());
  static final List<Uint8List> necessaryPermissionKeys = [
    "4b80742de2bf82acb3630000ac11803507c05a21daaf9d354f7100b1dc9cd590"
        .toBytes(),
    // Call & SetData
    "4b80742de2bf393a64c70000ac11803507c05a21daaf9d354f7100b1dc9cd590"
        .toBytes(),
    // Call Phygital Asset Functions: mint, verifyOwnershipAfterTransfer and transfer
    "4b80742de2bf866c29110000ac11803507c05a21daaf9d354f7100b1dc9cd590"
        .toBytes(),
    // SetData LSP12IssuedAssets array and map
  ];
  static final List<Uint8List> necessaryPermissionValues = [
    // assign permissions to controller key
    "0000000000000000000000000000000000000000000000000000000000040800"
        .toBytes(),
    "002000000002fffffffffffffffffffffffffffffffffffffffff602119031646613002000000002fffffffffffffffffffffffffffffffffffffffff602119041b3d513002000000002fffffffffffffffffffffffffffffffffffffffff6021190511b6952"
        .toBytes(),
    "00107c8c3416d6cda87cd42c71ea1843df28000c74ac2555c10b9349e78f0000"
        .toBytes(),
  ];

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

  Future<List<EthereumAddress>> _fetchCollection(Uint8List lsp2JsonUrl) async {
    String json = await LSP2Utils().fetchJsonUrl(lsp2JsonUrl);
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
      if (lsp2JsonUrl.isEmpty) return false;
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

  Future<Result> validatePhygitalContract(EthereumAddress? address) async {
    if (!_initialized) return Result.notInitialized;

    if (address != null) {
      try {
        PhygitalAsset contract =
            PhygitalAsset(address: address, client: _web3client!);
        if (await contract.supportsInterface(phygitalAssetInterfaceId)) {
          return Result.success;
        }
      } catch (e) {
        if (kDebugMode) {
          print(
              "Failed to check if the address ${address.hexEip55} is a valid PhygitalAsset ($e)");
        }
      }
    }

    return Result.invalidPhygitalAssetContractAddress;
  }

  Future<Result> validateUniversalProfileContract(
      EthereumAddress? address) async {
    if (!_initialized) return Result.notInitialized;

    if (address != null) {
      try {
        LSP0ERC725Account contract =
            LSP0ERC725Account(address: address, client: _web3client!);
        if (await contract.supportsInterface(universalProfileInterfaceId)) {
          return Result.success;
        }
      } catch (e) {
        if (kDebugMode) {
          print(
              "Failed to check if the address ${address.hexEip55} is a valid Universal Profile ($e)");
        }
      }
    }

    return Result.invalidUniversalProfileAddress;
  }

  Future<Result> validateUniversalProfilePermissions(
      EthereumAddress? address) async {
    if (!_initialized) return Result.notInitialized;
    Result universalProfileValidationResult =
        await validateUniversalProfileContract(address);
    if (Result.success != universalProfileValidationResult) {
      return universalProfileValidationResult;
    }

    if (address != null) {
      try {
        LSP0ERC725Account contract =
            LSP0ERC725Account(address: address, client: _web3client!);
        List<Uint8List> permissions =
            await contract.getDataBatch(necessaryPermissionKeys);

        if (permissions.indexed.every((indexedPermission) =>
            indexedPermission.$2.toHexString() ==
            necessaryPermissionValues[indexedPermission.$1].toHexString())) {
          return Result.success;
        }
      } catch (e) {
        if (kDebugMode) {
          print(
              "Failed to check if the Universal Profile ${address.hexEip55} has set the necessary permissions ($e)");
        }
      }
    }

    return Result.necessaryPermissionsNotSet;
  }

  Future<Result> validatePhygitalOwnership(
      Phygital phygital, EthereumAddress universalProfileAddress) async {
    if (!_initialized) return Result.notInitialized;
    Result phygitalContractValidationResult =
        await validatePhygitalContract(phygital.contractAddress);
    if (Result.success != phygitalContractValidationResult) {
      return phygitalContractValidationResult;
    }

    if (phygital.contractAddress != null) {
      try {
        PhygitalAsset contract = PhygitalAsset(
            address: phygital.contractAddress!, client: _web3client!);
        EthereumAddress address = await contract.tokenOwnerOf(phygital.id);
        if (address == universalProfileAddress) {
          return Result.success;
        }
      } catch (e) {
        if (kDebugMode) {
          print(
              "Failed to check if the universal profile ${universalProfileAddress.hexEip55} is the owner of ${phygital.id} ($e)");
        }
      }
    }

    return Result.invalidOwnership;
  }

  Future<Result> validatePhygitalOwnershipExpectedVerificationStatus(
      Phygital phygital, bool expectedVerificationStatus) async {
    if (!_initialized) return Result.notInitialized;
    Result phygitalContractValidationResult =
        await validatePhygitalContract(phygital.contractAddress);
    if (Result.success != phygitalContractValidationResult) {
      return phygitalContractValidationResult;
    }

    if (phygital.contractAddress != null) {
      try {
        PhygitalAsset contract = PhygitalAsset(
            address: phygital.contractAddress!, client: _web3client!);
        bool verificationStatus = await contract.verifiedOwnership(phygital.id);
        print("VERIFICATION STATUS $verificationStatus");
        if (expectedVerificationStatus == verificationStatus) {
          return Result.success;
        }
      } catch (e) {
        if (kDebugMode) {
          print(
              "Failed to check if the the phygital ${phygital.id} is $expectedVerificationStatus ($e)");
        }
      }
    }

    return expectedVerificationStatus
        ? Result.unverifiedOwnership
        : Result.alreadyVerifiedOwnership;
  }

  Future<Result> validatePhygitalContractAndUniversalProfilePermissions(
      Phygital phygital, EthereumAddress universalProfileAddress) async {
    if (!_initialized) return Result.notInitialized;

    if (phygital.contractAddress == null) return Result.notPartOfAnyCollection;

    Result phygitalContractValidationResult =
        await validatePhygitalContract(phygital.contractAddress);
    if (Result.success != phygitalContractValidationResult) {
      return phygitalContractValidationResult;
    }

    Result universalProfilePermissionsValidationResult =
        await validateUniversalProfilePermissions(universalProfileAddress);
    if (Result.success != universalProfilePermissionsValidationResult) {
      return universalProfilePermissionsValidationResult;
    }

    return Result.success;
  }

  Future<Result> mint(
      Phygital phygital, EthereumAddress universalProfileAddress) async {
    Result validationResult =
        await validatePhygitalContractAndUniversalProfilePermissions(
            phygital, universalProfileAddress);
    if (Result.success != validationResult) return validationResult;

    BigInt? nonce = await _getNonceOfPhygital(phygital);
    if (nonce == null) return Result.mintFailed;
    if (nonce.compareTo(BigInt.from(0)) != 0) return Result.alreadyMinted;

    if (!(await _isPhygitalInCollection(phygital))) {
      return Result.notPartOfCollection;
    }

    String? phygitalSignature = await NFC()
        .signUniversalProfileAddress(universalProfileAddress, nonce.toInt());
    if (phygitalSignature == null) return Result.signingFailed;

    return await BackendClient().mint(
        universalProfileAddress: universalProfileAddress,
        phygitalSignature: phygitalSignature,
        phygital: phygital);
  }

  Future<Result> verifyOwnershipAfterTransfer(
      Phygital phygital, EthereumAddress universalProfileAddress) async {
    Result validationResult =
        await validatePhygitalContractAndUniversalProfilePermissions(
            phygital, universalProfileAddress);
    if (Result.success != validationResult) return validationResult;

    BigInt? nonce = await _getNonceOfPhygital(phygital);
    if (nonce == null) return Result.ownershipVerificationFailed;
    if (nonce.compareTo(BigInt.from(0)) == 0) return Result.notMintedYet;

    Result ownershipValidationResult =
        await validatePhygitalOwnership(phygital, universalProfileAddress);
    if (Result.success != ownershipValidationResult) {
      return ownershipValidationResult;
    }

    Result ownershipVerificationStatusValidationResult =
        await validatePhygitalOwnershipExpectedVerificationStatus(
            phygital, false);
    if (Result.success != ownershipVerificationStatusValidationResult) {
      return ownershipVerificationStatusValidationResult;
    }

    String? phygitalSignature = await NFC()
        .signUniversalProfileAddress(universalProfileAddress, nonce.toInt());
    if (phygitalSignature == null) return Result.signingFailed;

    return await BackendClient().verifyOwnershipAfterTransfer(
        universalProfileAddress: universalProfileAddress,
        phygitalSignature: phygitalSignature,
        phygital: phygital);
  }

  Future<Result> transfer(
      Phygital phygital,
      EthereumAddress universalProfileAddress,
      EthereumAddress toUniversalProfileAddress) async {
    Result validationResult =
        await validatePhygitalContractAndUniversalProfilePermissions(
            phygital, universalProfileAddress);
    if (Result.success != validationResult) return validationResult;

    Result toUniversalProfileValidationResult =
        await validateUniversalProfileContract(toUniversalProfileAddress);
    if (Result.success != toUniversalProfileValidationResult) {
      return Result.invalidReceivingUniversalProfileAddress;
    }

    BigInt? nonce = await _getNonceOfPhygital(phygital);
    if (nonce == null) return Result.ownershipVerificationFailed;
    if (nonce.compareTo(BigInt.from(0)) == 0) return Result.notMintedYet;

    Result ownershipValidationResult =
        await validatePhygitalOwnership(phygital, universalProfileAddress);
    if (Result.success != ownershipValidationResult) {
      return ownershipValidationResult;
    }

    Result ownershipVerificationStatusValidationResult =
        await validatePhygitalOwnershipExpectedVerificationStatus(
            phygital, true);
    if (Result.success != ownershipVerificationStatusValidationResult) {
      return ownershipVerificationStatusValidationResult;
    }

    String? phygitalSignature = await NFC()
        .signUniversalProfileAddress(toUniversalProfileAddress, nonce.toInt());
    if (phygitalSignature == null) return Result.signingFailed;

    return await BackendClient().transfer(
        toUniversalProfileAddress: toUniversalProfileAddress,
        universalProfileAddress: universalProfileAddress,
        phygitalSignature: phygitalSignature,
        phygital: phygital);
  }

  Future<(Result, EthereumAddress?)> create(
      EthereumAddress universalProfileAddress,
      String name,
      String symbol,
      List<Phygital> phygitalCollection,
      LSP4Metadata metadata,
      String baseUri) async {
    Result validationResult =
        await validateUniversalProfilePermissions(universalProfileAddress);
    if (Result.success != validationResult) return (validationResult, null);

    if (phygitalCollection.isEmpty) {
      return (Result.collectionMustNotBeEmpty, null);
    }
    if (name.isEmpty) return (Result.nameMustNotBeEmpty, null);
    if (symbol.isEmpty) return (Result.symbolMustNotBeEmpty, null);
    if (baseUri.isEmpty ||
        !baseUri.startsWith(IpfsClient.protocolPrefix) ||
        !baseUri.endsWith("/")) return (Result.invalidBaseUri, null);

    return await BackendClient().create(
        universalProfileAddress: universalProfileAddress,
        name: name,
        symbol: symbol,
        phygitalCollection: phygitalCollection,
        metadata: metadata,
        baseUri: baseUri);
  }

  Future<UniversalProfile?> fetchUniversalProfile(
      EthereumAddress universalProfileAddress) async {
    Result validationResult =
        await validateUniversalProfileContract(universalProfileAddress);
    if (validationResult != Result.success) return null;

    LSP0ERC725Account contract = LSP0ERC725Account(
        address: universalProfileAddress, client: _web3client!);
    Uint8List lsp2JsonUrl = await contract.getData(universalProfileDataKey);
    if (lsp2JsonUrl.isEmpty) return null;

    String json = await LSP2Utils().fetchJsonUrl(lsp2JsonUrl);
    Map<String, dynamic> universalProfileData = jsonDecode(json);
    return UniversalProfile.fromJson(
        universalProfileAddress, universalProfileData);
  }

  Future<(Result, PhygitalWithData?)> fetchPhygitalData(
      Phygital phygital) async {
    Result validationResult =
        await validatePhygitalContract(phygital.contractAddress);
    if (validationResult != Result.success) return (validationResult, null);

    PhygitalAsset contract =
        PhygitalAsset(address: phygital.contractAddress!, client: _web3client!);

    UniversalProfile? owner;
    try {
      EthereumAddress ownerAddress = await contract.tokenOwnerOf(phygital.id);
      owner = await fetchUniversalProfile(ownerAddress);
    } catch (e) {
      /*Not minted yet*/
    }

    List<Uint8List> data = await contract.getDataBatch([
      phygitalAssetMetadataKey,
      phygitalAssetBaseUriKey,
      phygitalAssetNameKey,
      phygitalAssetSymbolKey,
      phygitalAssetCreatorsArrayKey
    ]);

    Uint8List metadataJsonUrl = data[0];
    if (metadataJsonUrl.isEmpty) {
      return (Result.invalidPhygitalCollectionData, null);
    }

    String baseUri = utf8.decode(data[1].sublist(4));
    if (baseUri.isEmpty) return (Result.invalidBaseUri, null);

    String name = utf8.decode(data[2]);
    if (name.isEmpty) return (Result.nameMustNotBeEmpty, null);

    String symbol = utf8.decode(data[3]);
    if (symbol.isEmpty) return (Result.symbolMustNotBeEmpty, null);

    int creatorsLength =
        ByteUtils.bytesToBigInt(data[4], endianness: Endianness.Little).toInt();

    List<Uint8List> creatorsIndexKeys = [];
    for (int i = 0; i < creatorsLength; i++) {
      creatorsIndexKeys.add(
        LSP2Utils().getArrayIndexKey(
          phygitalAssetCreatorsArrayKey,
          i,
        ),
      );
    }

    List<Uint8List> creatorsData = creatorsIndexKeys.isNotEmpty
        ? await contract.getDataBatch(creatorsIndexKeys)
        : [];
    List<EthereumAddress> creatorAddresses = creatorsData
        .map((creatorAddress) => EthereumAddress(creatorAddress))
        .toList();
    List<UniversalProfile> creators = [];
    for (int i = 0; i < creatorAddresses.length; i++) {
      UniversalProfile? creatorUniversalProfile =
          await fetchUniversalProfile(creatorAddresses[i]);
      if (creatorUniversalProfile != null) {
        creators.add(creatorUniversalProfile);
      }
    }

    String json =
        await LSP2Utils().fetchJson("$baseUri${phygital.id.toHexString()}");
    if (json.isEmpty) return (Result.invalidPhygitalData, null);
    Map<String, dynamic> rawData = jsonDecode(json);
    return (
      Result.success,
      PhygitalWithData(
        address: phygital.address,
        contractAddress: phygital.contractAddress!,
        owner: owner,
        name: name,
        symbol: symbol,
        baseUri: baseUri,
        metadata: LSP4Metadata.fromJson(rawData),
        creators: creators,
      ),
    );
  }
}
