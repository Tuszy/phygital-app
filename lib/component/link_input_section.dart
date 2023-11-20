import 'package:flutter/material.dart';

typedef OnAddCallback = void Function();
typedef OnRemoveCallback = void Function(int);

class LinkController {
  LinkController({String? title, String? url})
      : titleController = TextEditingController(text: title),
        urlController = TextEditingController(text: url);

  final TextEditingController titleController;
  final TextEditingController urlController;

  String get title => titleController.text;

  String get url => urlController.text;

  void dispose() {
    titleController.dispose();
    urlController.dispose();
  }
}

class LinkInputSection extends StatefulWidget {
  const LinkInputSection({
    super.key,
    required this.name,
    required this.label,
    required this.onAdd,
    required this.onRemove,
    required this.links,
    this.topBorder = true,
  });

  final String name;
  final String label;
  final OnAddCallback onAdd;
  final OnRemoveCallback onRemove;
  final List<LinkController> links;
  final bool topBorder;

  @override
  State<LinkInputSection> createState() => _LinkInputSectionState();
}

class _LinkInputSectionState extends State<LinkInputSection> {
  String? onValidate(String name, String? value) =>
      value == null || value.isEmpty ? "The $name must not be empty" : null;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 8),
      decoration: BoxDecoration(
        border: widget.topBorder
            ? const Border(
                top: BorderSide(width: 2, color: Colors.white38),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        widget.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _Button(
                      name: "ADD LINK",
                      onClick: widget.onAdd,
                    ),
                  ],
                ),
                ...widget.links.indexed.map(
                  ((int, LinkController) link) => Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0x22ffffff),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0x33ffffff),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "#${link.$1 + 1} Link",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            _Button(
                              name: "REMOVE LINK",
                              onClick: () => widget.onRemove(link.$1),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        _TextInput(
                          index: link.$1,
                          name: "Title",
                          onValidate: onValidate,
                          textEditingController: link.$2.titleController,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        _TextInput(
                          index: link.$1,
                          name: "URL",
                          onValidate: onValidate,
                          textEditingController: link.$2.urlController,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

typedef OnValidateCallback = String? Function(String, String?);

class _TextInput extends StatelessWidget {
  const _TextInput({
    required this.index,
    required this.name,
    required this.onValidate,
    required this.textEditingController,
  });

  final int index;
  final String name;
  final OnValidateCallback onValidate;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextFormField(
        maxLines: null,
        keyboardType: TextInputType.text,
        cursorColor: Colors.white70,
        decoration: InputDecoration(
          label: Text(
            name,
            style: const TextStyle(color: Colors.white70),
          ),
          isDense: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.white38,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.white38,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          hintText: "Enter the ${name.toLowerCase()}...",
          hintStyle: const TextStyle(color: Colors.white38),
        ),
        autocorrect: false,
        validator: (String? value) => onValidate(name, value),
        controller: textEditingController,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({required this.name, required this.onClick});

  final String name;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onClick,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white70,
        backgroundColor: const Color(0x20ffffff),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(
          letterSpacing: 3,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
        side: const BorderSide(color: Colors.white60, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}
