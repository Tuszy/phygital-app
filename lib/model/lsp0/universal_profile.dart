import 'package:web3dart/credentials.dart';
import '../lsp4/lsp4_link.dart';
import 'lsp_image.dart';

class UniversalProfile {
  UniversalProfile(
      {required this.address,
      this.name,
      this.description,
      this.links,
      this.tags,
      this.profileImages,
      this.backgroundImages});

  EthereumAddress address;
  String? name;
  String? description;
  List<LSP4Link>? links;
  List<String>? tags;
  List<LSPImage>? profileImages;
  List<LSPImage>? backgroundImages;

  factory UniversalProfile.fromJson(
      EthereumAddress address, final Map<String, dynamic> rawData) {
    Map<String, dynamic> data = rawData["LSP3Profile"];
    String? name = data["name"];
    String? description = data["description"];
    List<LSP4Link>? links = data.containsKey("links")
        ? (data["links"] as List<dynamic>)
            .map((e) => LSP4Link.fromJson(e))
            .toList()
        : null;
    List<String>? tags = data.containsKey("tags")
        ? (data["tags"] as List<dynamic>).map((e) => e.toString()).toList()
        : null;
    List<LSPImage>? profileImages = data.containsKey("profileImage")
        ? (data["profileImage"] as List<dynamic>)
            .map((e) => LSPImage.fromJson(e))
            .toList()
        : null;
    List<LSPImage>? backgroundImages = data.containsKey("backgroundImage")
        ? (data["backgroundImage"] as List<dynamic>)
            .map((e) => LSPImage.fromJson(e))
            .toList()
        : null;

    return UniversalProfile(
      address: address,
      name: name,
      description: description,
      links: links,
      tags: tags,
      profileImages: profileImages,
      backgroundImages: backgroundImages,
    );
  }
}
