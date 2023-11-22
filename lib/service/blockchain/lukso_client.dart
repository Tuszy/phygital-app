import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/model/lsp4/lsp4_metadata.dart';
import 'package:phygital/model/phygital/phygital.dart';
import 'package:phygital/model/phygital/phygital_tag_data.dart';
import 'dart:convert';
import 'package:phygital/service/backend_client.dart';
import 'package:phygital/service/blockchain/contracts/LSP0ERC725Account.g.dart';
import 'package:phygital/service/result.dart';
import 'package:phygital/service/ipfs_client.dart';
import 'package:phygital/util/lsp2_utils.dart';
import 'package:web3dart/web3dart.dart';

import '../../model/phygital/phygital_tag.dart';
import '../../model/lsp0/universal_profile.dart';
import '../nfc.dart';
import 'contracts/PhygitalAsset.g.dart';

class LuksoClient extends ChangeNotifier {
  static const String rpcUrl = "https://rpc.testnet.lukso.gateway.fm";
  static const int chainId = 4201;

  static final universalProfileInterfaceId = "24871b3d".toBytes();
  static final lsp6KeyManagerInterfaceId = "23f34c62".toBytes();
  static final phygitalAssetInterfaceId = "ae8205e1".toBytes();
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
    "0000000000000000000000000000000000000000000000000000000000440800"
        .toBytes(),
    "002000000002ffffffffffffffffffffffffffffffffffffffffae8205e131646613002000000002ffffffffffffffffffffffffffffffffffffffffae8205e141b3d513002000000002ffffffffffffffffffffffffffffffffffffffffae8205e1511b6952"
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

  Future<BigInt?> _getNonceOfPhygital(PhygitalTag phygitalTag) async {
    if (!_initialized || phygitalTag.contractAddress == null) return null;

    try {
      PhygitalAsset contract = PhygitalAsset(
          address: phygitalTag.contractAddress!, client: _web3client!);
      return await contract.nonce(phygitalTag.id);
    } catch (e) {
      if (kDebugMode) {
        print(
            "Failed to get nonce for the phygital ${phygitalTag.address.hexEip55} ($e)");
      }
      return null;
    }
  }

  Future<bool> _isPhygitalInCollection(PhygitalTag phygitalTag) async {
    if (!_initialized || phygitalTag.contractAddress == null) return false;

    try {
      PhygitalAsset contract = PhygitalAsset(
          address: phygitalTag.contractAddress!, client: _web3client!);
      Uint8List lsp2JsonUrl =
          await contract.getData(phygitalAssetCollectionUriKey);
      if (lsp2JsonUrl.isEmpty) return false;
      List<EthereumAddress> collection = await _fetchCollection(lsp2JsonUrl);
      return collection.contains(phygitalTag.address);
    } catch (e) {
      if (kDebugMode) {
        print(
            "Failed to check if the phygital ${phygitalTag.address.hexEip55} is part of the collection ${phygitalTag.contractAddress!.hexEip55} ($e)");
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

  Future<Result> validateUniversalProfileContract({
    required EthereumAddress? address,
  }) async {
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

  Future<Result> validateUniversalProfilePermissions({
    required EthereumAddress? address,
  }) async {
    if (!_initialized) return Result.notInitialized;
    Result universalProfileValidationResult =
        await validateUniversalProfileContract(address: address);
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

  Future<Result> validatePhygitalOwnership({
    required PhygitalTag phygitalTag,
    required EthereumAddress universalProfileAddress,
  }) async {
    if (!_initialized) return Result.notInitialized;
    Result phygitalContractValidationResult =
        await validatePhygitalContract(phygitalTag.contractAddress);
    if (Result.success != phygitalContractValidationResult) {
      return phygitalContractValidationResult;
    }

    if (phygitalTag.contractAddress != null) {
      try {
        PhygitalAsset contract = PhygitalAsset(
            address: phygitalTag.contractAddress!, client: _web3client!);
        EthereumAddress address = await contract.tokenOwnerOf(phygitalTag.id);
        if (address == universalProfileAddress) {
          return Result.success;
        }
      } catch (e) {
        if (kDebugMode) {
          print(
              "Failed to check if the universal profile ${universalProfileAddress.hexEip55} is the owner of ${phygitalTag.id} ($e)");
        }
      }
    }

    return Result.invalidOwnership;
  }

  Future<Result> validatePhygitalOwnershipExpectedVerificationStatus({
    required PhygitalTag phygitalTag,
    required bool expectedVerificationStatus,
  }) async {
    if (!_initialized) return Result.notInitialized;
    Result phygitalContractValidationResult =
        await validatePhygitalContract(phygitalTag.contractAddress);
    if (Result.success != phygitalContractValidationResult) {
      return phygitalContractValidationResult;
    }

    if (phygitalTag.contractAddress != null) {
      try {
        PhygitalAsset contract = PhygitalAsset(
            address: phygitalTag.contractAddress!, client: _web3client!);
        bool verificationStatus =
            await contract.verifiedOwnership(phygitalTag.id);
        if (expectedVerificationStatus == verificationStatus) {
          return Result.success;
        }
      } catch (e) {
        if (kDebugMode) {
          print(
              "Failed to check if the the phygital ${phygitalTag.id} is $expectedVerificationStatus ($e)");
        }
      }
    }

    return expectedVerificationStatus
        ? Result.unverifiedOwnership
        : Result.alreadyVerifiedOwnership;
  }

  Future<Result> validatePhygitalContractAndUniversalProfilePermissions({
    required PhygitalTag phygitalTag,
    required EthereumAddress universalProfileAddress,
  }) async {
    if (!_initialized) return Result.notInitialized;

    if (phygitalTag.contractAddress == null)
      return Result.notPartOfAnyCollection;

    Result phygitalContractValidationResult =
        await validatePhygitalContract(phygitalTag.contractAddress);
    if (Result.success != phygitalContractValidationResult) {
      return phygitalContractValidationResult;
    }

    Result universalProfilePermissionsValidationResult =
        await validateUniversalProfilePermissions(
      address: universalProfileAddress,
    );
    if (Result.success != universalProfilePermissionsValidationResult) {
      return universalProfilePermissionsValidationResult;
    }

    return Result.success;
  }

  Future<Result> mint({
    required PhygitalTag phygitalTag,
    required EthereumAddress universalProfileAddress,
  }) async {
    Result validationResult =
        await validatePhygitalContractAndUniversalProfilePermissions(
      phygitalTag: phygitalTag,
      universalProfileAddress: universalProfileAddress,
    );
    if (Result.success != validationResult) return validationResult;

    BigInt? nonce = await _getNonceOfPhygital(phygitalTag);
    if (nonce == null) return Result.mintFailed;
    if (nonce.compareTo(BigInt.from(0)) != 0) return Result.alreadyMinted;

    if (!(await _isPhygitalInCollection(phygitalTag))) {
      return Result.notPartOfCollection;
    }

    String? phygitalSignature = await NFC().signUniversalProfileAddress(
      message: "Minting Phygital",
      phygitalTag: phygitalTag,
      universalProfileAddress: universalProfileAddress,
      nonce: nonce.toInt(),
    );
    if (phygitalSignature == null) return Result.signingFailed;

    return await BackendClient().mint(
      universalProfileAddress: universalProfileAddress,
      phygitalSignature: phygitalSignature,
      phygitalTag: phygitalTag,
    );
  }

  Future<Result> verifyOwnershipAfterTransfer({
    required PhygitalTag phygitalTag,
    required EthereumAddress universalProfileAddress,
  }) async {
    Result validationResult =
        await validatePhygitalContractAndUniversalProfilePermissions(
      phygitalTag: phygitalTag,
      universalProfileAddress: universalProfileAddress,
    );
    if (Result.success != validationResult) return validationResult;

    BigInt? nonce = await _getNonceOfPhygital(phygitalTag);
    if (nonce == null) return Result.ownershipVerificationFailed;
    if (nonce.compareTo(BigInt.from(0)) == 0) return Result.notMintedYet;

    Result ownershipValidationResult = await validatePhygitalOwnership(
      phygitalTag: phygitalTag,
      universalProfileAddress: universalProfileAddress,
    );
    if (Result.success != ownershipValidationResult) {
      return ownershipValidationResult;
    }

    Result ownershipVerificationStatusValidationResult =
        await validatePhygitalOwnershipExpectedVerificationStatus(
      phygitalTag: phygitalTag,
      expectedVerificationStatus: false,
    );
    if (Result.success != ownershipVerificationStatusValidationResult) {
      return ownershipVerificationStatusValidationResult;
    }

    String? phygitalSignature = await NFC().signUniversalProfileAddress(
      message: "Verifying Ownership Of Phygital",
      phygitalTag: phygitalTag,
      universalProfileAddress: universalProfileAddress,
      nonce: nonce.toInt(),
    );
    if (phygitalSignature == null) return Result.signingFailed;

    return await BackendClient().verifyOwnershipAfterTransfer(
      universalProfileAddress: universalProfileAddress,
      phygitalSignature: phygitalSignature,
      phygitalTag: phygitalTag,
    );
  }

  Future<Result> transfer({
    required PhygitalTag phygitalTag,
    required EthereumAddress universalProfileAddress,
    required EthereumAddress toUniversalProfileAddress,
  }) async {
    Result validationResult =
        await validatePhygitalContractAndUniversalProfilePermissions(
      phygitalTag: phygitalTag,
      universalProfileAddress: universalProfileAddress,
    );
    if (Result.success != validationResult) return validationResult;

    Result toUniversalProfileValidationResult =
        await validateUniversalProfileContract(
      address: toUniversalProfileAddress,
    );
    if (Result.success != toUniversalProfileValidationResult) {
      return Result.invalidReceivingUniversalProfileAddress;
    }

    BigInt? nonce = await _getNonceOfPhygital(phygitalTag);
    if (nonce == null) return Result.ownershipVerificationFailed;
    if (nonce.compareTo(BigInt.from(0)) == 0) return Result.notMintedYet;

    Result ownershipValidationResult = await validatePhygitalOwnership(
      phygitalTag: phygitalTag,
      universalProfileAddress: universalProfileAddress,
    );
    if (Result.success != ownershipValidationResult) {
      return ownershipValidationResult;
    }

    Result ownershipVerificationStatusValidationResult =
        await validatePhygitalOwnershipExpectedVerificationStatus(
      phygitalTag: phygitalTag,
      expectedVerificationStatus: true,
    );
    if (Result.success != ownershipVerificationStatusValidationResult) {
      return ownershipVerificationStatusValidationResult;
    }

    String? phygitalSignature = await NFC().signUniversalProfileAddress(
      message: "Transferring Phygital",
      phygitalTag: phygitalTag,
      universalProfileAddress: toUniversalProfileAddress,
      nonce: nonce.toInt(),
    );
    if (phygitalSignature == null) return Result.signingFailed;

    return await BackendClient().transfer(
      toUniversalProfileAddress: toUniversalProfileAddress,
      universalProfileAddress: universalProfileAddress,
      phygitalSignature: phygitalSignature,
      phygitalTag: phygitalTag,
    );
  }

  Future<(Result, EthereumAddress?)> create({
    required EthereumAddress universalProfileAddress,
    required String name,
    required String symbol,
    required List<PhygitalTagData> phygitalCollection,
    required LSP4Metadata metadata,
  }) async {
    Result validationResult = await validateUniversalProfilePermissions(
      address: universalProfileAddress,
    );
    if (Result.success != validationResult) return (validationResult, null);

    if (phygitalCollection.isEmpty) {
      return (Result.collectionMustNotBeEmpty, null);
    }
    if (name.isEmpty) return (Result.nameMustNotBeEmpty, null);
    if (symbol.isEmpty) return (Result.symbolMustNotBeEmpty, null);

    return await BackendClient().create(
      universalProfileAddress: universalProfileAddress,
      name: name,
      symbol: symbol,
      phygitalCollection: phygitalCollection,
      metadata: metadata,
    );
  }

  Future<UniversalProfile?> fetchUniversalProfile({
    required EthereumAddress universalProfileAddress,
  }) async {
    Result validationResult = await validateUniversalProfileContract(
      address: universalProfileAddress,
    );
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

  Future<(Result, Phygital?)> fetchPhygitalData({
    required PhygitalTag phygitalTag,
  }) async {
    Result validationResult =
        await validatePhygitalContract(phygitalTag.contractAddress);
    if (validationResult != Result.success) return (validationResult, null);

    PhygitalAsset contract = PhygitalAsset(
        address: phygitalTag.contractAddress!, client: _web3client!);

    UniversalProfile? owner;
    try {
      EthereumAddress ownerAddress =
          await contract.tokenOwnerOf(phygitalTag.id);
      owner = await fetchUniversalProfile(
        universalProfileAddress: ownerAddress,
      );
    } catch (e) {
      /*Not minted yet*/
    }
    bool verifiedOwnership = owner == null
        ? false
        : await contract.verifiedOwnership(phygitalTag.id);

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
      UniversalProfile? creatorUniversalProfile = await fetchUniversalProfile(
        universalProfileAddress: creatorAddresses[i],
      );
      if (creatorUniversalProfile != null) {
        creators.add(creatorUniversalProfile);
      }
    }

    String json =
        await LSP2Utils().fetchJson("$baseUri${phygitalTag.id.toHexString()}");
    if (json.isEmpty) return (Result.invalidPhygitalData, null);
    Map<String, dynamic> rawData = jsonDecode(json);
    return (
      Result.success,
      Phygital(
        tagId: phygitalTag.tagId,
        address: phygitalTag.address,
        contractAddress: phygitalTag.contractAddress!,
        owner: owner,
        verifiedOwnership: verifiedOwnership,
        name: name,
        symbol: symbol,
        baseUri: baseUri,
        metadata: LSP4Metadata.fromJson(rawData),
        creators: creators,
      ),
    );
  }
}
