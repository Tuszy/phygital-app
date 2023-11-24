import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

class FileImagePreview extends StatefulWidget {
  const FileImagePreview({
    super.key,
    required this.image,
    required this.width,
    required this.height,
    this.keepContainerSize = true,
  });

  final File image;
  final double width;
  final double height;
  final bool keepContainerSize;

  @override
  State<FileImagePreview> createState() => _FileImagePreviewState();
}

class _FileImagePreviewState extends State<FileImagePreview> {
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

    Size size = ImageSizeGetter.getSize(FileInput(widget.image));

    _width = size.needRotate ? size.height.toDouble() : size.width.toDouble();
    _height = size.needRotate ? size.width.toDouble() : size.height.toDouble();
    print(size);

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
    return Container(
      width: widget.keepContainerSize ? widget.width : null,
      height: widget.keepContainerSize ? widget.height : null,
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
                child: Image.file(
                  widget.image,
                  width: _width,
                  height: _height,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
