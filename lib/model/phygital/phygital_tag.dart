import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:ndef/utilities.dart';
import 'package:pointycastle/api.dart';
import 'package:web3dart/credentials.dart';

import '../../service/blockchain/lukso_client.dart';
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
    Result validationResult =
        await LuksoClient().validatePhygitalContract(newContractAddress);
    if (Result.success != validationResult) return validationResult;

    try {
      GlobalState().loadingWithText = "Assigning collection";
      EthereumAddress? setContractAddress = await NFC().setContractAddress(
        phygitalTag: this,
        contractAddress: newContractAddress,
      );
      if (setContractAddress != null) {
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
    return "Phygital Address: ${address.hexEip55}\n\n${contractAddress != null ? "Contract Address: ${contractAddress!.hexEip55}\n" : ""}";
  }

  @override
  bool operator ==(Object other) {
    return other is PhygitalTag && address.hexEip55 == other.address.hexEip55;
  }

  @override
  int get hashCode => address.hexEip55.hashCode;
}
