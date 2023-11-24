import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phygital/component/image_upload_section.dart';
import 'package:phygital/component/editable_link_list_section.dart';
import 'package:phygital/component/phygital_list_section.dart';
import 'package:phygital/component/text_input_section.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/model/lsp0/universal_profile.dart';
import 'package:phygital/model/lsp4/lsp4_link.dart';
import 'package:phygital/model/lsp4/lsp4_metadata.dart';
import 'package:phygital/page/add_phygital_page.dart';
import 'package:phygital/page/assign_collection_page.dart';
import 'package:phygital/page/edit_phygital_page.dart';
import 'package:phygital/service/blockchain/lukso_client.dart';
import 'package:phygital/service/global_state.dart';
import 'package:phygital/service/ipfs_client.dart';
import 'package:web3dart/credentials.dart';

import '../model/lsp4/lsp4_image.dart';
import '../model/phygital/phygital_tag.dart';
import '../model/phygital/phygital_tag_data.dart';
import '../service/custom_dialog.dart';
import '../service/nfc.dart';
import '../service/result.dart';

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
  File? _backgroundImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _symbolController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<LinkController> _links = <LinkController>[];
  final List<PhygitalTagData> _tags = <PhygitalTagData>[];

  bool triedToSubmit = false;
  bool disabled = false;

  @override
  void dispose() {
    for (LinkController link in _links) {
      link.dispose();
    }

    _nameController.dispose();
    _symbolController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  void _onIconChange(File? newIcon) => setState(() {
        _icon = newIcon;
      });

  void _onBackgroundImageChange(File? newBackgroundImage) => setState(() {
        _backgroundImage = newBackgroundImage;
      });

  String? _onValidate(String name, String? value) =>
      value == null || value.trim().isEmpty
          ? "The $name must not be empty"
          : null;

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

  Future<void> _onAddPhygitalTag() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      PhygitalTag phygitalTag = await NFC().read();
      if (!_tags.contains(phygitalTag) && mounted) {
        PhygitalTagData? phygitalTagData = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddPhygitalPage(
              number: _tags.length + 1,
              name: _nameController.text.trim(),
              phygitalTag: phygitalTag,
            ),
          ),
        );

        if (phygitalTagData != null) {
          setState(() {
            _tags.add(phygitalTagData);
          });
        }
      } else {
        showInfoDialog(
            title: "Attention", text: "This phygital has already been added");
      }
    } catch (e) {
      GlobalState().loadingWithText = null;
      showInfoDialog(
        title: "Result",
        text: e.toString(),
      );
    }
  }

  Future<void> _onEditPhygitalTag(PhygitalTagData phygitalTagData) async {
    if(!_tags.contains(phygitalTagData)) return;
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      PhygitalTagData? newPhygitalTagData = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPhygitalPage(
            phygitalTagData: phygitalTagData,
          ),
        ),
      );

      if (newPhygitalTagData != null) {
        setState(() {
          _tags[_tags.indexOf(phygitalTagData)] = newPhygitalTagData;
        });
      }
    } catch (e) {
      GlobalState().loadingWithText = null;
      showInfoDialog(
        title: "Result",
        text: e.toString(),
      );
    }
  }

  void _onRemovePhygitalTag(int index) {
    if (index < 0 || index >= _tags.length) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _tags.removeAt(index);
    });
  }

  Future<(LSP4Image, LSP4Image)?> _validateAndUploadImages() async {
    String? error;
    if (_icon == null) {
      error = "Please upload the icon";
    } else if (_backgroundImage == null) {
      error = "Please upload the background image";
    }

    if (error != null) {
      showInfoDialog(title: "Incomplete Form", text: error);
      return null;
    }

    String name = _nameController.text;
    String symbol = _symbolController.text;

    try {
      GlobalState().loadingWithText = "Uploading the icon to IPFS";
      LSP4Image? icon = await IpfsClient()
          .uploadImage("PhygitalAsset:Icon:$name:$symbol", _icon!);
      if (icon == null) {
        throw "Failed to upload the icon";
      }

      GlobalState().loadingWithText = "Uploading the background image to IPFS";
      LSP4Image? backgroundImage = await IpfsClient().uploadImage(
          "PhygitalAsset:BackgroundImage:$name:$symbol", _backgroundImage!);
      if (backgroundImage == null) {
        throw "Failed to upload the background image";
      }

      return (icon, backgroundImage);
    } catch (e) {
      if (kDebugMode) {
        print("Uploading images failed ($e)");
      }
      showInfoDialog(title: "Image upload failed", text: e.toString());
      GlobalState().loadingWithText = null;
      return null;
    }
  }

  Future<void> _onCreate() async {
    if (GlobalState().universalProfile == null) return;
    UniversalProfile universalProfile = GlobalState().universalProfile!;

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      triedToSubmit = true;
    });

    GlobalState().loadingWithText = "Validating Form";
    if (_formKey.currentState!.validate()) {
      GlobalState().loadingWithText = "Validating Phygital list";
      if (_tags.isEmpty) {
        GlobalState().loadingWithText = null;
        showInfoDialog(
            title: "Form Incomplete",
            text: "You must add atleast one phygital to the collection.");
        return;
      }

      (LSP4Image, LSP4Image)? images = await _validateAndUploadImages();
      if (images == null) {
        GlobalState().loadingWithText = null;
        return;
      }

      String name = _nameController.text;
      String symbol = _symbolController.text;
      String description = _descriptionController.text;

      LSP4Metadata metadata = LSP4Metadata(
        name: name,
        description: description,
        symbol: symbol,
        links: _links
            .map(
              (LinkController link) => LSP4Link(
                title: link.title,
                url: link.url,
              ),
            )
            .toList(),
        icons: [images.$1],
        images: [
          [images.$1]
        ],
        backgroundImages: [images.$2],
        assets: [],
        attributes: [],
      );

      GlobalState().loadingWithText = "Deploying the collection";
      try {
        (Result, EthereumAddress?) result = await LuksoClient().create(
          universalProfileAddress: universalProfile.address,
          name: name,
          symbol: symbol,
          phygitalCollection: _tags,
          metadata: metadata,
        );

        if (Result.createSucceeded == result.$1) {
          GlobalState().loadingWithText = null;
          await showInfoDialog(
            title: "Creation succeeded",
            text:
                "Successfully created the collection. Now you need to assign the collection to the Phygitals.",
          );
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => AssignCollectionPage(
                  contractAddress: result.$2!,
                  metadata: metadata,
                  tags: _tags.toList()),
            ),
            (var route) => route.settings.name == "menu",
          );
        } else {
          GlobalState().loadingWithText = null;
          showInfoDialog(
            title: "Creation failed",
            text: getMessageForResult(result.$1),
          );
          if (mounted && Result.authenticationSessionExpired == result.$1) {
            GlobalState().logout();
            Navigator.popUntil(context, (route) => route.isFirst);
            return;
          }
        }
      } catch (e) {
        GlobalState().loadingWithText = null;
        if (kDebugMode) {
          print("Deploying Phygital contract failed ($e)");
        }
        showInfoDialog(
          title: "Creation failed",
          text: e.toString(),
        );
      }
    }
    GlobalState().loadingWithText = null;
  }

  Future<void> showInfoDialog(
      {required String title, required String text}) async {
    return CustomDialog.showInfo(
        context: context, title: title, text: text, onPressed: () {});
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
              autovalidateMode: triedToSubmit
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
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
                  EditableLinkListSection(
                    name: "links",
                    label: "Links",
                    onAdd: _onAddLink,
                    onRemove: _onRemoveLink,
                    links: _links,
                  ),
                  PhygitalListSection(
                    name: "phygitals",
                    label: "Phygitals",
                    onAdd: _onAddPhygitalTag,
                    onRemove: _onRemovePhygitalTag,
                    onEdit: _onEditPhygitalTag,
                    phygitalTags: _tags,
                  )
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
