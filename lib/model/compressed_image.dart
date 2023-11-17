import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';

class CompressedImage {
  CompressedImage(
      {required this.bytes,
      required this.width,
      required this.height,
      required this.mediaType,
      required this.hash});

  final Uint8List bytes;
  final int width;
  final int height;
  final Uint8List hash;
  final MediaType mediaType;
}
