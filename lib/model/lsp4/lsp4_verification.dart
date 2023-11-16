class LSP4Verification {
  static const String standardMethod = "keccak256(bytes)";

  LSP4Verification({this.method = standardMethod, required this.data});

  final String method;
  final String data;

  Map<String, dynamic> toJson() {
    return {'method': method, 'data': data};
  }
}
