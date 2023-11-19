import 'dart:typed_data';

import 'package:ndef/utilities.dart';
import 'package:pointycastle/api.dart';
import 'package:web3dart/credentials.dart';

class PhygitalTag {
  PhygitalTag({required this.address, required this.tagId, this.contractAddress});

  final String tagId;
  final EthereumAddress address;
  EthereumAddress? contractAddress;

  Uint8List get id =>
      Digest('Keccak/256').process(address.hexNo0x.padLeft(64, '0').toBytes());

  @override
  String toString() {
    return "Phygital Address: ${address.hexEip55}\n\n${contractAddress != null ? "Contract Address: ${contractAddress!.hexEip55}\n" : ""}";
  }
}