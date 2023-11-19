import 'package:flutter/material.dart';

typedef OnChangeCallback = void Function(String key, String value);
typedef OnValidateCallback = String? Function(String key, String? value);

class TextInputSection extends StatelessWidget {
  const TextInputSection({
    super.key,
    required this.name,
    required this.label,
    required this.onChange,
    required this.onValidate,
    this.topBorder = true,
  });

  final String name;
  final String label;
  final OnChangeCallback onChange;
  final OnValidateCallback onValidate;
  final bool topBorder;

  void _onChange(String value) => onChange(name, value);

  String? _onValidate(String? value) => onValidate(name, value);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 8),
      decoration: BoxDecoration(
        border: topBorder
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
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.white70,
                    decoration: InputDecoration(
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
                      hintText: "Enter the $name...",
                      hintStyle: const TextStyle(color: Colors.white38),
                    ),
                    onChanged: _onChange,
                    autocorrect: false,
                    // The validator receives the text that the user has entered.
                    validator: _onValidate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
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
