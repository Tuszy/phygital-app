class IpfsUploadWrapper {
  IpfsUploadWrapper(
      {required this.content, required this.name});

  String name;
  dynamic content;

  Map<String, dynamic> toJson() {
    return {
      'pinataContent': content,
      'pinataMetadata': {
        "name": name,
      },
      'pinataOptions': {
        "cidVersion": 0,
      }
    };
  }
}