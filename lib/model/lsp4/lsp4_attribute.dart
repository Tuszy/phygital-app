class LSP4Attribute {
  LSP4Attribute({required this.key, required this.value, required this.type});

  final String key;
  final dynamic value;
  final String type;

  Map<String, dynamic> toJson() {
    return {'key': key, 'value': value, 'type': type};
  }
}
