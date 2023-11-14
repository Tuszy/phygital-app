class Phygital {
  static const uri = "phygital.tuszy.com";

  Phygital({required this.address, required this.contractAddress});

  final String address;
  final String? contractAddress;

  @override
  String toString() {
    return "Phygital Address: $address\n" +
        (contractAddress != null ? "Contract Address: $contractAddress\n" : "");
  }
}
