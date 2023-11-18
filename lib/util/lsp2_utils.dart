import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:ndef/utilities.dart';
import 'package:phygital/service/ipfs_client.dart';
import 'package:pointycastle/api.dart';
import 'package:http/http.dart';

class LSP2Utils {
  LSP2Utils._sharedInstance();

  static final LSP2Utils _shared = LSP2Utils._sharedInstance();

  factory LSP2Utils() => _shared;

  final Client _httpClient = Client();

  static final keccak256HashValue = "6f357c6a".toBytes();

  Uint8List hashBytes(Uint8List bytes) {
    return Digest('Keccak/256').process(bytes);
  }

  Future<Uint8List> hashFile(File file) async {
    return hashBytes(await file.readAsBytes());
  }

  Uint8List hashJson(Uint8List json) {
    String jsonStringified = jsonEncode(jsonDecode(utf8.decode(json)));

    return Digest('Keccak/256')
        .process(Uint8List.fromList(utf8.encode(jsonStringified)));
  }

  Uint8List hashStringifiedJson(String jsonStringified) {
    jsonStringified = jsonEncode(jsonDecode(jsonStringified));
    return Digest('Keccak/256')
        .process(Uint8List.fromList(utf8.encode(jsonStringified)));
  }

  String createJsonUrl(String url, String jsonStringified) {
    return "0x${Uint8List.fromList(keccak256HashValue + hashStringifiedJson(jsonStringified) + utf8.encode(url)).toHexString()}";
  }

  String createJsonUrlForIpfs(String cid, String jsonStringified) {
    return createJsonUrl("${IpfsClient.protocolPrefix}$cid", jsonStringified);
  }

  Future<String> fetchJsonUrl(Uint8List lsp2JsonUrl) async {
    // bytes4 hash func + bytes32 hashed json value (+ bytes7 'ipfs://')
    Uint8List hashFunc = lsp2JsonUrl.sublist(0, 4);
    if (hashFunc.toHexString() != keccak256HashValue.toHexString()) {
      throw "Only Keccak256 hashed JSON urls are supported";
    }
    Uint8List jsonHash = lsp2JsonUrl.sublist(4, 36);
    String url = utf8.decode(lsp2JsonUrl.sublist(36));

    if (url.startsWith("ipfs://")) {
      url = "${IpfsClient.gatewayUrl}${url.substring(7)}";
    }

    Response response = await _httpClient.get(Uri.parse(url));
    String jsonStringified = utf8.decode(response.bodyBytes);
    Uint8List calculatedJsonHash = hashJson(response.bodyBytes);

    if (jsonHash.toHexString() != calculatedJsonHash.toHexString()) {
      throw "JSON hash validation failed";
    }

    return jsonStringified;
  }

  Future<String> fetchJson(String url) async {
    if (url.startsWith("ipfs://")) {
      url = "${IpfsClient.gatewayUrl}${url.substring(7)}";
    }

    Response response = await _httpClient.get(Uri.parse(url));
    return utf8.decode(response.bodyBytes);
  }

  Uint8List getArrayIndexKey(Uint8List arrayKey, int index) {
    return Uint8List.fromList(
      arrayKey.sublist(0, 16) +
          Uint8List.fromList(Uint8List.fromList([index])
              .toHexString()
              .padLeft(32, '0')
              .toBytes()),
    );
  }
}
