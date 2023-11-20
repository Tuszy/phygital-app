import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:phygital/component/image_upload_section.dart';
import 'package:phygital/component/link_input_section.dart';
import 'package:phygital/component/text_input_section.dart';
import 'package:phygital/layout/standard_layout.dart';

class CreateCollectionPage extends StatefulWidget {
  const CreateCollectionPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CreateCollectionPageState();
}

typedef OnImageChangeCallback = void Function(File?);

class _CreateCollectionPageState extends State<CreateCollectionPage> {
  final _formKey = GlobalKey<FormState>();
  File? _icon;
  File? _image;
  File? _backgroundImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _symbolController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<LinkController> _links = <LinkController>[];

  bool disabled = false;

  @override
  void dispose() {
    for(LinkController link in _links) {
      link.dispose();
    }

    _nameController.dispose();
    _symbolController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

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

  String? _onValidate(String name, String? value) =>
      value == null || value.isEmpty ? "The $name must not be empty" : null;

  void _onAddLink() {
    setState(() {
      _links.add(LinkController());
    });
  }

  void _onRemoveLink(int index) {
    if (index < 0 || index >= _links.length) return;
    _links[index].dispose();
    setState(() {
      _links.removeAt(index);
    });
  }

  void _onCreate() {
    if (_formKey.currentState!.validate()) {
      print("SUCCESS");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StandardLayout(
      title: "Create Collection",
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    textEditingController: _nameController,
                    onValidate: _onValidate,
                  ),
                  TextInputSection(
                    name: "symbol",
                    label: "Symbol",
                    textEditingController: _symbolController,
                    onValidate: _onValidate,
                  ),
                  TextInputSection(
                    name: "description",
                    label: "Description",
                    textEditingController: _descriptionController,
                    onValidate: _onValidate,
                  ),
                  LinkInputSection(
                    name: "links",
                    label: "Links",
                    onAdd: _onAddLink,
                    onRemove: _onRemoveLink,
                    links: _links,
                  ),
                ],
              ),
            ),
          ),
          _SubmitButton(
            disabled: false,
            onSubmit: _onCreate,
          )
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.disabled, required this.onSubmit});

  final bool disabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        //color: Color(0x8800ffff),
        border: Border.all(
          width: 2,
          color: Colors.white38,
        ),
        color: disabled ? const Color(0x88555555) : const Color(0x7700ff00),
        boxShadow: [
          BoxShadow(
            color: disabled ? const Color(0x88555555) : const Color(0x7700ff00),
            spreadRadius: 5,
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: disabled ? 10 : 3,
            sigmaY: disabled ? 10 : 3,
          ),

          /// Filter effect field
          child: IgnorePointer(
            ignoring: disabled,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: disabled
                    ? const Color(0xaa999999)
                    : const Color(0xcdffffff),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                textStyle: const TextStyle(
                  letterSpacing: 3,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: onSubmit,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [Text("Create")],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
