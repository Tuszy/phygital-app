class LSP4Attribute {
  LSP4Attribute({required this.key, required this.value, required this.type});

  final String key;
  final dynamic value;
  final String type;

  String get formattedValue {
    if (type == "number") {
      return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
    } else if (type == "boolean") {
      return value as bool ? "true" : "false";
    }
    return value.toString();
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'value': value, 'type': type};
  }

  factory LSP4Attribute.fromJson(final Map<String, dynamic> data) {
    return LSP4Attribute(
        key: data["key"], value: data["value"], type: data["type"]);
  }
}
