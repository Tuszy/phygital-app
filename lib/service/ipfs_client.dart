import 'dart:async';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:ndef/utilities.dart';
import 'dart:io';
import 'dart:convert';

import 'package:phygital/model/IpfsUploadWrapper.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:phygital/model/image.dart';
import 'package:phygital/model/lsp4/lsp4_image.dart';
import 'package:mime/mime.dart';
import 'package:phygital/model/lsp4/lsp4_metadata.dart';

import '../model/phygital/phygital_tag.dart';
import '../util/lsp2_utils.dart';

class IpfsClient extends ChangeNotifier {
  static const String protocolPrefix = "ipfs://";
  static const String gatewayUrl = "https://2eff.lukso.dev/ipfs/";

  static const String apiUrl = "https://api.pinata.cloud";
  static const String apiKey = "e29a6447fab35e5";
  static const String apiSecret =
      "7a99e975a1dac46ecaaa9ad2f6163cb1499a71633fd8e6228a9fc9757c5cc0fb";
  static const String jwt =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySW5mb3JtYXRpb24iOnsiaWQiOiJkNjQ4YTk4MC1lNTBlLTRjMjktOTJiMS00YjgzMzdlMmEzYmUiLCJlbWFpbCI6ImRlbm5pcm9AZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInBpbl9wb2xpY3kiOnsicmVnaW9ucyI6W3siaWQiOiJGUkExIiwiZGVzaXJlZFJlcGxpY2F0aW9uQ291bnQiOjF9LHsiaWQiOiJOWUMxIiwiZGVzaXJlZFJlcGxpY2F0aW9uQ291bnQiOjF9XSwidmVyc2lvbiI6MX0sIm1mYV9lbmFibGVkIjpmYWxzZSwic3RhdHVzIjoiQUNUSVZFIn0sImF1dGhlbnRpY2F0aW9uVHlwZSI6InNjb3BlZEtleSIsInNjb3BlZEtleUtleSI6IjY2NjVlZTI5YTY0NDdmYWIzNWU1Iiwic2NvcGVkS2V5U2VjcmV0IjoiN2E5OWU5NzVhMWRhYzQ2ZWNhYWE5YWQyZjYxNjNjYjE0OTlhNzE2MzNmZDhlNjIyOGE5ZmM5NzU3YzVjYzBmYiIsImlhdCI6MTcwMDE2MTYwOH0.JBDOe7zusReMKgkWtBss4RKVEcOqqFj52q9FUqr6d4U";

  static const String ipfsHashKey = "IpfsHash";

  static const contentTypeApplicationJson = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer $jwt"
  };

  static const contentTypeMultipartFormData = {
    "Content-Type": "multipart/form-data",
    "Accept": "application/json",
    "Authorization": "Bearer $jwt"
  };

  static final pinFileEndpoint = Uri.parse("$apiUrl/pinning/pinFileToIPFS");
  static final pinJsonEndpoint = Uri.parse("$apiUrl/pinning/pinJSONToIPFS");

  IpfsClient._sharedInstance();

  static final IpfsClient _shared = IpfsClient._sharedInstance();

  factory IpfsClient() => _shared;

  final Client _httpClient = Client();

  Future<String?> uploadLSP4MetadataForPhygitals(LSP4Metadata lsp4metadata, List<PhygitalTag> phygitalTags) async {
    MultipartRequest request = MultipartRequest("POST", pinFileEndpoint);
    request.headers.addAll(contentTypeMultipartFormData);

    List<int> metadataJson = utf8.encode(jsonEncode(lsp4metadata));
    for(PhygitalTag phygitalTag in phygitalTags){
      request.files.add(
        MultipartFile.fromBytes(
            "file",
            metadataJson,
            contentType: MediaType.parse("application/json"),
            filename: "/baseuri/${phygitalTag.id.toHexString()}"
        ),
      );
    }

    StreamedResponse response = await _httpClient.send(request);
    Uint8List responseBodyBytes = await response.stream.toBytes();

    String jsonResponseStringified = utf8.decode(responseBodyBytes);
    try {
      Map<String, dynamic> jsonObject = json.decode(jsonResponseStringified);
      if (kDebugMode) {
        print(
            "Upload LSP4 token id metadata for phygitals to ipfs response: $jsonObject");
      }
      if (response.statusCode == 200 && jsonObject.containsKey(ipfsHashKey)) {
        return "$protocolPrefix${jsonObject[ipfsHashKey] as String}/";
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            "Error while parsing LSP4 token id metadata upload for phygitals ipfs response: $e");
      }
    }

    return null;
  }

  Future<LSP4Image?> uploadImage(String name, File file) async {
    String? mimeType = lookupMimeType(file.path);
    MediaType? contentType =
        mimeType != null ? MediaType.parse(mimeType) : null;
    if (contentType == null) return null;
    Uint8List bytes = await file.readAsBytes();
    Size size = ImageSizeGetter.getSize(FileInput(file));
    Uint8List hash = LSP2Utils().hashBytes(bytes);

    MultipartFile multipartFile = MultipartFile.fromBytes("file", bytes,
        filename: name, contentType: contentType);

    MultipartRequest request = MultipartRequest("POST", pinFileEndpoint);
    request.headers.addAll(contentTypeMultipartFormData);
    request.files.add(multipartFile);

    StreamedResponse response = await _httpClient.send(request);
    Uint8List responseBodyBytes = await response.stream.toBytes();

    String jsonResponseStringified = utf8.decode(responseBodyBytes);
    try {
      Map<String, dynamic> jsonObject = json.decode(jsonResponseStringified);
      if (kDebugMode) {
        print("Upload image to ipfs response: $jsonObject");
      }
      if (response.statusCode == 200 && jsonObject.containsKey(ipfsHashKey)) {
        String cid = jsonObject[ipfsHashKey] as String;
        return LSP4Image.fromImage(
            "$protocolPrefix$cid",
            Image(
                bytes: bytes,
                width: size.width,
                height: size.height,
                mediaType: contentType,
                hash: hash));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error while parsing upload image to ipfs response: $e");
      }
    }

    return null;
  }

  Future<String?> uploadJson(String name, dynamic content) async {
    IpfsUploadWrapper ipfsUploadWrapper =
        IpfsUploadWrapper(content: content, name: name);
    String jsonRequestStringified = json.encode(ipfsUploadWrapper);

    Response response = await _httpClient.post(pinJsonEndpoint,
        headers: contentTypeApplicationJson, body: jsonRequestStringified);
    String jsonResponseStringified = utf8.decode(response.bodyBytes);
    try {
      Map<String, dynamic> jsonObject = json.decode(jsonResponseStringified);
      if (kDebugMode) {
        print("Upload json to ipfs response: $jsonObject");
      }
      if (response.statusCode == 200 && jsonObject.containsKey(ipfsHashKey)) {
        String cid = jsonObject[ipfsHashKey] as String;
        return "$protocolPrefix$cid";
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error while parsing upload json to ipfs response: $e");
      }
    }

    return null;
  }
}
