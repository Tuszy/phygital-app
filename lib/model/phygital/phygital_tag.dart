import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:ndef/utilities.dart';
import 'package:pointycastle/api.dart';
import 'package:web3dart/credentials.dart';

import '../../service/global_state.dart';
import '../../service/nfc.dart';
import '../../service/result.dart';

class PhygitalTag {
  PhygitalTag(
      {required this.address, required this.tagId, this.contractAddress});

  final String tagId;
  final EthereumAddress address;
  EthereumAddress? contractAddress;

  Uint8List get id =>
      Digest('Keccak/256').process(address.hexNo0x.padLeft(64, '0').toBytes());

  Future<Result> setContractAddress(EthereumAddress newContractAddress) async {
    /*Result validationResult =
        await LuksoClient().validatePhygitalContract(newContractAddress);
    if (Result.success != validationResult) return validationResult;*/

    try {
      GlobalState().loadingWithText = "Assigning collection";
      PhygitalTag? phygitalTag = await NFC().setContractAddress(
        phygitalTags: {this},
        contractAddress: newContractAddress,
      );
      if (phygitalTag != null) {
        contractAddress = newContractAddress;
      } else {
        return Result.assigningCollectionFailed;
      }
      GlobalState().loadingWithText = null;
      return Result.assigningCollectionSucceeded;
    } catch (e) {
      if (kDebugMode) {
        print(
            "Setting contract address ${newContractAddress.hexEip55} to ${id} failed ($e)");
      }
      GlobalState().loadingWithText = null;
      return Result.assigningCollectionFailed;
    }
  }

  @override
  String toString() {
    return "Tag Id: $tagId\nPhygital Address: ${address.hexEip55}\n${contractAddress != null ? "Contract Address: ${contractAddress!.hexEip55}" : ""}";
  }

  @override
  bool operator ==(Object other) {
    return other is PhygitalTag && tagId.hashCode == other.tagId.hashCode;
  }

  @override
  int get hashCode => tagId.hashCode;
}
