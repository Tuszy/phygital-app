import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:phygital/component/custom_icon_button.dart';

typedef OnImageChangeCallback = void Function(File?);

class ImageUpload extends StatefulWidget {
  const ImageUpload(
      {super.key,
      required this.width,
      required this.height,
      required this.onChange});

  final double width;
  final double height;
  final OnImageChangeCallback onChange;

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  XFile? _image;
  double? _width;
  double? _height;
  bool? _rotate;

  dynamic _pickImageError;

  String? _retrieveDataError;

  final double minImageWidth = 150;

  final double maxImageHeight = 1000;
  final double maxImageWidth = 1000;
  final int imageQuality = 100;

  final ImagePicker _picker = ImagePicker();

  final List<Color> _backgroundGradientColors = <Color>[
    const Color(0xffa00661),
    const Color(0xffaa0838),
    const Color(0xffaa4838),
  ];

  final TextStyle _textStyle = const TextStyle(
      color: Colors.white60, fontSize: 24, fontWeight: FontWeight.w500);

  Future<void> _onImageButtonPressed(ImageSource source,
      {required BuildContext context}) async {
    if (context.mounted) {
      try {
        final XFile? pickedImage = await _picker.pickImage(
            source: source,
            maxHeight: maxImageHeight,
            maxWidth: maxImageWidth,
            imageQuality: imageQuality);
        widget.onChange(pickedImage != null ? File(pickedImage.path) : null);

        double? width;
        double? height;
        if (pickedImage != null) {
          Size size =
              ImageSizeGetter.getSize(FileInput(File(pickedImage.path)));
          _rotate = size.needRotate;

          if (size.height > widget.width ||
              size.height > widget.height ||
              size.width > widget.width ||
              size.width > widget.height) {
            if (size.width > size.height) {
              height = widget.height * ((size.height) / (size.width)) + 2;
            } else if (size.width < size.height) {
              width = widget.width * ((size.width) / (size.height)) + 2;
            }
          } else {
            width = size.width.toDouble();
            height = size.height.toDouble();
          }

          if (_rotate as bool) {
            double? temp = height;
            height = width;
            width = temp;
          }

          if (width != null && width < minImageWidth) {
            width = minImageWidth;
          }
        }

        setState(() {
          _image = pickedImage;
          _width = width;
          _height = height;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }

  Widget _previewImage() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_image != null) {
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(26)),
        child: Image.file(
          File(_image!.path),
          width: _width ?? widget.width,
          height: _height ?? widget.height,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            return Text('Image type is not supported', style: _textStyle);
          },
        ),
      );
    } else if (_pickImageError != null) {
      return Text('Pick image error: $_pickImageError', style: _textStyle);
    } else {
      return Text('No image picked.', style: _textStyle);
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) return;
    if (response.file != null) {
      setState(() {
        _image = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          margin: const EdgeInsets.all(8),
          child: Center(
            child: Container(
              width: _width ?? widget.width,
              height: _height ?? widget.height,
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
              child: Stack(
                children: [
                  Container(
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
                      child: defaultTargetPlatform == TargetPlatform.android
                          ? FutureBuilder<void>(
                              future: retrieveLostData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<void> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                  case ConnectionState.active:
                                    return Text('No image picked.',
                                        style: _textStyle);
                                  case ConnectionState.done:
                                    return _previewImage();
                                }
                              },
                            )
                          : _previewImage(),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomIconButton(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(32),
                                bottomLeft: Radius.circular(32)),
                            gradientColors: _backgroundGradientColors,
                            onPressed: () {
                              _onImageButtonPressed(ImageSource.gallery,
                                  context: context);
                            },
                            icon: Icons.photo),
                        if (_picker.supportsImageSource(ImageSource.camera))
                          CustomIconButton(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  bottomRight: Radius.circular(32)),
                              gradientColors: _backgroundGradientColors,
                              onPressed: () {
                                _onImageButtonPressed(ImageSource.camera,
                                    context: context);
                              },
                              icon: Icons.camera_alt),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}
