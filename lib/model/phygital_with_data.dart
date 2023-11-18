import 'dart:typed_data';

import 'package:ndef/utilities.dart';
import 'package:phygital/model/lsp0/lsp_image.dart';
import 'package:phygital/model/lsp4/lsp4_metadata.dart';
import 'package:phygital/model/phygital.dart';
import 'package:pointycastle/api.dart';
import 'package:web3dart/credentials.dart';

class PhygitalWithData {
  PhygitalWithData({
    required this.address,
    required this.contractAddress,
    required this.owner,
    required this.name,
    required this.symbol,
    required this.baseUri,
    required this.metadata,
    required this.creators
  });

  final EthereumAddress address;
  final EthereumAddress contractAddress;
  final EthereumAddress? owner;
  final String name;
  final String symbol;
  final String baseUri;
  final LSP4Metadata metadata;
  final List<EthereumAddress> creators;

  Uint8List get id =>
      Digest('Keccak/256').process(address.hexNo0x.padLeft(64, '0').toBytes());
}
