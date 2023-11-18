import 'dart:typed_data';

import 'package:ndef/utilities.dart';
import 'package:phygital/model/lsp0/universal_profile.dart';
import 'package:phygital/model/lsp4/lsp4_metadata.dart';
import 'package:phygital/model/phygital.dart';
import 'package:pointycastle/api.dart';
import 'package:web3dart/credentials.dart';

class PhygitalWithData {
  PhygitalWithData({
    required this.tagId,
    required this.address,
    required this.contractAddress,
    required this.owner,
    required this.name,
    required this.symbol,
    required this.baseUri,
    required this.metadata,
    required this.creators,
  });

  final String tagId;
  final EthereumAddress address;
  final EthereumAddress contractAddress;
  final UniversalProfile? owner;
  final String name;
  final String symbol;
  final String baseUri;
  final LSP4Metadata metadata;
  final List<UniversalProfile> creators;

  Phygital get phygital => Phygital(address: address, tagId: tagId, contractAddress: contractAddress);

  Uint8List get id =>
      Digest('Keccak/256').process(address.hexNo0x.padLeft(64, '0').toBytes());
}
