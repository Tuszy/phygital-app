class Phygital {
  Phygital({required this.address, required this.contractAddress});

  final String address;
  final String? contractAddress;

  @override
  String toString() {
    return "Phygital Address: $address\n\n${contractAddress != null ? "Contract Address: $contractAddress\n" : ""}";
  }
}
