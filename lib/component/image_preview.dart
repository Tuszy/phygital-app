import 'package:flutter/material.dart';
import 'package:phygital/model/lsp0/lsp_image.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({
    super.key,
    required this.image,
    required this.width,
    required this.height,
  });

  final LSPImage image;
  final double width;
  final double height;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  late double _width;
  late double _height;

  final List<Color> _backgroundGradientColors = <Color>[
    const Color(0xffa00661),
    const Color(0xffaa0838),
    const Color(0xffaa4838),
  ];

  @override
  initState() {
    super.initState();

    _width = widget.image.width.toDouble();
    _height = widget.image.height.toDouble();

    if (_height > widget.width ||
        _height > widget.height ||
        _width > widget.width ||
        _width > widget.height) {
      if (_width > _height) {
        _height = widget.height * (_height / _width) + 2;
      } else if (_width < _height) {
        _width = widget.width * (_width / _height) + 2;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          margin: const EdgeInsets.all(8),
          child: Center(
            child: Container(
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x7700ffff),
                    spreadRadius: 2,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white38, width: 5),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _backgroundGradientColors,
                  ),
                ),
                child: Center(
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(26)),
                    child: Image.network(
                      widget.image.gatewayUrl,
                      width: _width,
                      height: _height,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
