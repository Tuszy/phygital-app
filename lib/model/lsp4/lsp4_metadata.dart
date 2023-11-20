import 'dart:convert';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:phygital/model/lsp4/lsp4_image.dart';
import 'package:web3dart/credentials.dart';

import '../../service/ipfs_client.dart';
import '../../util/lsp2_utils.dart';
import 'lsp4_asset.dart';
import 'lsp4_attribute.dart';
import 'lsp4_link.dart';

class LSP4Metadata {
  LSP4Metadata({
    required this.name,
    this.symbol,
    required this.description,
    required this.links,
    required this.icons,
    required this.images,
    required this.backgroundImages,
    required this.assets,
    required this.attributes,
  });

  String name;
  String? symbol;
  String description;
  List<LSP4Link> links;
  List<LSP4Image> icons;
  List<List<LSP4Image>> images;
  List<LSP4Image> backgroundImages;
  List<LSP4Asset> assets;
  List<LSP4Attribute> attributes;

  LSP4Image? get icon => icons.elementAtOrNull(0);
  LSP4Image? get image => images.elementAtOrNull(0)?.elementAtOrNull(0);
  LSP4Image? get backgroundImage => backgroundImages.elementAtOrNull(0);

  Future<(String, String)?> uploadToIpfs({
    required String name,
    required String symbol,
    required EthereumAddress universalProfileAddress,
  }) async {
    try {
      String stringifiedMetadata = jsonEncode(this);
      String? cid = await IpfsClient().uploadJson(
          "PhygitalAsset:Metadata:$name:$symbol:${universalProfileAddress.hexEip55}",
          this);
      if (cid == null) return null;
      return (cid, LSP2Utils().createJsonUrl(cid, stringifiedMetadata));
    } catch (e) {
      if (kDebugMode) {
        print("Failed to upload LSP4 metadata to ipfs ($e)");
      }
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'LSP4Metadata': {
        'name': name,
        if (symbol != null) 'symbol': symbol,
        'description': description,
        'links': links,
        'icon': icons,
        'images': images,
        'backgroundImage': backgroundImages,
        'assets': assets,
        'attributes': attributes
      }
    };
  }

  factory LSP4Metadata.fromJson(final Map<String, dynamic> rawData) {
    Map<String, dynamic> data = rawData["LSP4Metadata"];
    String name = data["name"] ?? "";
    String? symbol = data["symbol"] ?? "";
    String description = data["description"] ?? "";
    List<LSP4Link> links = data.containsKey("links")
        ? (data["links"] as List<dynamic>)
            .map((e) => LSP4Link.fromJson(e))
            .toList()
        : [];
    List<List<LSP4Image>> images = data.containsKey("images")
        ? (data["images"] as List<dynamic>)
            .map((e) =>
                (e as List<dynamic>).map((e) => LSP4Image.fromJson(e)).toList())
            .toList()
        : [];
    List<LSP4Image> icon = data.containsKey("icon")
        ? (data["icon"] as List<dynamic>)
            .map((e) => LSP4Image.fromJson(e))
            .toList()
        : [];
    List<LSP4Image> backgroundImage = data.containsKey("backgroundImage")
        ? (data["backgroundImage"] as List<dynamic>)
            .map((e) => LSP4Image.fromJson(e))
            .toList()
        : [];
    List<LSP4Asset>? assets = data.containsKey("assets")
        ? (data["assets"] as List<dynamic>)
            .map((e) => LSP4Asset.fromJson(e))
            .toList()
        : [];
    List<LSP4Attribute>? attributes = data.containsKey("attributes")
        ? (data["attributes"] as List<dynamic>)
            .map((e) => LSP4Attribute.fromJson(e))
            .toList()
        : [];

    return LSP4Metadata(
      name: name,
      symbol: symbol,
      description: description,
      links: links,
      images: images,
      icons: icon,
      backgroundImages: backgroundImage,
      assets: assets,
      attributes: attributes,
    );
  }
}
