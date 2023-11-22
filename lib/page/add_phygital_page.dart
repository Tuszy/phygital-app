import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/component/attribute_list_section.dart';
import 'package:phygital/component/image_upload_section.dart';
import 'package:phygital/component/editable_link_list_section.dart';
import 'package:phygital/component/phygital_list_section.dart';
import 'package:phygital/component/text_input_section.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/model/lsp0/universal_profile.dart';
import 'package:phygital/model/lsp4/lsp4_attribute.dart';
import 'package:phygital/model/lsp4/lsp4_link.dart';
import 'package:phygital/model/lsp4/lsp4_metadata.dart';
import 'package:phygital/model/phygital/phygital.dart';
import 'package:phygital/page/assign_collection_page.dart';
import 'package:phygital/service/blockchain/lukso_client.dart';
import 'package:phygital/service/global_state.dart';
import 'package:phygital/service/ipfs_client.dart';
import 'package:web3dart/credentials.dart';

import '../model/lsp4/lsp4_image.dart';
import '../model/phygital/phygital_tag.dart';
import '../model/phygital/phygital_tag_data.dart';
import '../service/custom_dialog.dart';

class AddPhygitalPage extends StatefulWidget {
  const AddPhygitalPage({super.key, required this.phygitalTag, required this.number, required this.name});

  final int number;
  final String name;
  final PhygitalTag phygitalTag;

  @override
  State<StatefulWidget> createState() => _AddPhygitalPageState();
}

typedef OnImageChangeCallback = void Function(File?);

class _AddPhygitalPageState extends State<AddPhygitalPage> {
  final _formKey = GlobalKey<FormState>();
  File? _phygitalImage;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  final List<LinkController> _links = <LinkController>[];
  late final List<AttributeController> _attributes;

  bool triedToSubmit = false;
  bool disabled = false;

  @override
  void initState() {
    _nameController = TextEditingController(text: "${widget.name} #${widget.number}");
    _descriptionController = TextEditingController(text: "${widget.name} #${widget.number}");
    _attributes = <AttributeController>[AttributeController(key: "Number", value: widget.number)];

    super.initState();
  }

  @override
  void dispose() {
    for (LinkController link in _links) {
      link.dispose();
    }

    for (AttributeController attribute in _attributes) {
      attribute.dispose();
    }

    _nameController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  void _onImageChange(File? newImage) => setState(() {
        _phygitalImage = newImage;
      });

  String? _onValidate(String name, String? value) =>
      value == null || value.isEmpty ? "The $name must not be empty" : null;

  void _onAddLink() {
    FocusManager.instance.primaryFocus?.unfocus();
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

  void _onAddAttribute() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _attributes.add(AttributeController());
    });
  }

  void _onRemoveAttribute(int index) {
    if (index < 0 || index >= _attributes.length) return;
    _attributes[index].dispose();
    setState(() {
      _attributes.removeAt(index);
    });
  }

  Future<void> _onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      triedToSubmit = true;
    });

    if (_formKey.currentState!.validate()) {
      if (_phygitalImage == null) {
        showInfoDialog(
            title: "Incomplete Form", text: "Please upload the phygital image");
        GlobalState().loadingWithText = null;
        return;
      }

      String name = _nameController.text;
      String description = _descriptionController.text;

      PhygitalTagData phygitalTagData = PhygitalTagData(
        phygitalTag: widget.phygitalTag,
        phygitalImage: _phygitalImage!,
        name: name,
        description: description,
        links: _links
            .map(
              (LinkController link) => LSP4Link(
                title: link.title,
                url: link.url,
              ),
            )
            .toList(),
        attributes: _attributes
            .map(
              (AttributeController attribute) => LSP4Attribute(
                key: attribute.key,
                value: attribute.value,
                type: attribute.type,
              ),
            )
            .toList(),
      );

      Navigator.pop(context, phygitalTagData);
    }
  }

  Future<void> showInfoDialog(
      {required String title, required String text}) async {
    return CustomDialog.showInfo(
        context: context, title: title, text: text, onPressed: () {});
  }

  @override
  Widget build(BuildContext context) {
    return StandardLayout(
      title: "Add Phygital",
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
              autovalidateMode: triedToSubmit
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ImageUploadSection(
                    topBorder: false,
                    name: "phygital image",
                    label: "Phygital Image",
                    width: 250,
                    height: 250,
                    onImageChange: _onImageChange,
                  ),
                  TextInputSection(
                    name: "name",
                    label: "Name",
                    textEditingController: _nameController,
                    onValidate: _onValidate,
                  ),
                  TextInputSection(
                    name: "description",
                    label: "Description",
                    textEditingController: _descriptionController,
                    onValidate: _onValidate,
                  ),
                  EditableLinkListSection(
                    name: "links",
                    label: "Links",
                    onAdd: _onAddLink,
                    onRemove: _onRemoveLink,
                    links: _links,
                  ),
                  AttributeListSection(
                    name: "attributes",
                    label: "Attributes",
                    onAdd: _onAddAttribute,
                    onRemove: _onRemoveAttribute,
                    attributes: _attributes,
                  ),
                ],
              ),
            ),
          ),
          _SubmitButton(
            disabled: false,
            onSubmit: _onSubmit,
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
