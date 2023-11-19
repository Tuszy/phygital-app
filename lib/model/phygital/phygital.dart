import 'package:flutter/foundation.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/model/lsp0/universal_profile.dart';
import 'package:phygital/model/lsp4/lsp4_metadata.dart';
import 'package:phygital/model/phygital/phygital_tag.dart';
import 'package:pointycastle/api.dart';
import 'package:web3dart/credentials.dart';

import '../../service/blockchain/lukso_client.dart';
import '../../service/global_state.dart';
import '../../service/nfc.dart';
import '../../service/result.dart';

class Phygital {
  Phygital({
    required this.tagId,
    required this.address,
    required this.contractAddress,
    required this.owner,
    required this.verifiedOwnership,
    required this.name,
    required this.symbol,
    required this.baseUri,
    required this.metadata,
    required this.creators,
  });

  final String tagId;
  final EthereumAddress address;
  EthereumAddress contractAddress;
  UniversalProfile? owner;
  bool verifiedOwnership;
  final String name;
  final String symbol;
  final String baseUri;
  final LSP4Metadata metadata;
  final List<UniversalProfile> creators;

  Future<Result> mint() async {
    UniversalProfile? universalProfile = GlobalState().universalProfile;
    if (universalProfile == null) return Result.mintFailed;

    if (owner != null) return Result.alreadyMinted;

    try {
      GlobalState().loadingWithText = "Minting";
      Result result = await LuksoClient().mint(
        phygitalTag: phygital,
        universalProfileAddress: GlobalState().universalProfile!.address,
      );

      if (Result.mintSucceeded == result) {
        owner = universalProfile;
        verifiedOwnership = true;
      }
      GlobalState().loadingWithText = null;
      return result;
    } catch (e) {
      if (kDebugMode) {
        print("Minting ${phygital.id} failed ($e)");
      }
      GlobalState().loadingWithText = null;
      return Result.mintFailed;
    }
  }

  Future<Result> verifyOwnership() async {
    UniversalProfile? universalProfile = GlobalState().universalProfile;
    if (universalProfile == null) return Result.ownershipVerificationFailed;

    if (owner == null) return Result.notMintedYet;
    if (owner!.address.hexEip55 != universalProfile.address.hexEip55) return Result.invalidOwnership;
    if (verifiedOwnership) return Result.alreadyVerifiedOwnership;

    try {
      GlobalState().loadingWithText = "Verifying Ownership";
      Result result = await LuksoClient().verifyOwnershipAfterTransfer(
        phygitalTag: phygital,
        universalProfileAddress: GlobalState().universalProfile!.address,
      );

      if (Result.ownershipVerificationSucceeded == result) {
        verifiedOwnership = true;
      }
      GlobalState().loadingWithText = null;
      return result;
    } catch (e) {
      if (kDebugMode) {
        print("Ownership verification of ${phygital.id} failed ($e)");
      }
      GlobalState().loadingWithText = null;
      return Result.ownershipVerificationFailed;
    }
  }

  Future<Result> setContractAddress(EthereumAddress newContractAddress) async {
    Result validationResult =
        await LuksoClient().validatePhygitalContract(newContractAddress);
    if (Result.success != validationResult) return validationResult;

    try {
      GlobalState().loadingWithText = "Assigning collection";
      EthereumAddress? setContractAddress = await NFC().setContractAddress(
        phygitalTag: phygital,
        contractAddress: newContractAddress,
      );
      if(setContractAddress != null) {
        contractAddress = newContractAddress;
      }else{
        return Result.assigningCollectionFailed;
      }
      GlobalState().loadingWithText = null;
      return Result.assigningCollectionSucceeded;
    } catch (e) {
      if (kDebugMode) {
        print("Setting contract address ${newContractAddress.hexEip55} to ${phygital.id} failed ($e)");
      }
      GlobalState().loadingWithText = null;
      return Result.assigningCollectionFailed;
    }
  }

  PhygitalTag get phygital => PhygitalTag(
        address: address,
        tagId: tagId,
        contractAddress: contractAddress,
      );

  Uint8List get id =>
      Digest('Keccak/256').process(address.hexNo0x.padLeft(64, '0').toBytes());
}
