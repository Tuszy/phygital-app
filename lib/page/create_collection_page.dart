import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phygital/component/image_upload_section.dart';
import 'package:phygital/component/text_input_section.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/model/layout_button_data.dart';

import '../component/image_upload.dart';

class CreateCollectionPage extends StatefulWidget {
  const CreateCollectionPage({
    super.key,
    this.layoutButtonData,
  });

  final LayoutButtonData? layoutButtonData;

  @override
  State<StatefulWidget> createState() => _CreateCollectionPageState();
}

typedef OnImageChangeCallback = void Function(File?);

class _CreateCollectionPageState extends State<CreateCollectionPage> {
  final _formKey = GlobalKey<FormState>();
  File? _icon;
  File? _image;
  File? _backgroundImage;

  void _onIconChange(File? newIcon) {
    setState(() {
      _icon = newIcon;
    });
  }

  void _onImageChange(File? newImage) {
    setState(() {
      _image = newImage;
    });
  }

  void _onBackgroundImageChange(File? newBackgroundImage) {
    setState(() {
      _backgroundImage = newBackgroundImage;
    });
  }

  void _onChange(String name, String value) {}

  String? _onValidate(String name, String? value) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StandardLayout(
      title: "Create Collection",
      layoutButtonData: widget.layoutButtonData,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0x22000000),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white38, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x7700ffff),
                  spreadRadius: 2,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ImageUploadSection(
                    name: "icon",
                    label: "Icon",
                    width: 200,
                    height: 200,
                    onImageChange: _onIconChange,
                    topBorder: false,
                  ),
                  ImageUploadSection(
                    name: "image",
                    label: "Image",
                    width: 250,
                    height: 250,
                    onImageChange: _onImageChange,
                  ),
                  ImageUploadSection(
                    name: "backgroundImage",
                    label: "Background Image",
                    width: 250,
                    height: 250,
                    onImageChange: _onBackgroundImageChange,
                  ),
                  TextInputSection(
                    name: "name",
                    label: "Name",
                    onChange: _onChange,
                    onValidate: _onValidate,
                  ),
                  TextInputSection(
                    name: "symbol",
                    label: "Symbol",
                    onChange: _onChange,
                    onValidate: _onValidate,
                  ),
                  TextInputSection(
                    name: "description",
                    label: "Description",
                    onChange: _onChange,
                    onValidate: _onValidate,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
