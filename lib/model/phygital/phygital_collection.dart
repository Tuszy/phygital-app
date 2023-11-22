import 'package:phygital/model/lsp0/universal_profile.dart';
import 'package:phygital/model/lsp4/lsp4_metadata.dart';
import 'package:web3dart/credentials.dart';

class PhygitalCollection {
  PhygitalCollection({
    required this.contractAddress,
    required this.name,
    required this.symbol,
    required this.metadata,
    required this.creators,
    required this.totalSupply,
  });

  final EthereumAddress contractAddress;
  final String name;
  final String symbol;
  final LSP4Metadata metadata;
  final List<UniversalProfile> creators;
  final int totalSupply;
}
