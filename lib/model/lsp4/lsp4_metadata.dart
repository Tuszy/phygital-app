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
  LSP4Metadata(
      {required this.description,
      required this.links,
      required this.icon,
      required this.images,
      this.assets,
      this.attributes});

  String description;
  List<LSP4Link> links;
  List<LSP4Image> icon;
  List<List<LSP4Image>> images;
  List<LSP4Asset>? assets;
  List<LSP4Attribute>? attributes;

  Future<String?> uploadToIpfs(
      {required String name,
      required String symbol,
      required EthereumAddress universalProfileAddress}) async {
    try {
      String stringifiedMetadata = jsonEncode(this);
      String? cid = await IpfsClient().uploadJson(
          "PhygitalAsset:Metadata:$name:$symbol:${universalProfileAddress.hexEip55}",
          this);
      if (cid == null) return null;
      return LSP2Utils().createJsonUrl(cid, stringifiedMetadata);
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
        'description': description,
        'links': links,
        'icon': icon,
        'images': images,
        if (assets != null) 'assets': assets,
        if (attributes != null) 'attributes': attributes
      }
    };
  }
}
