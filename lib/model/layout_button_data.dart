import 'dart:ui';

class LayoutButtonData {
  LayoutButtonData({required this.onClick, this.text = "CONFIRM", this.disabled = false});
  final VoidCallback onClick;
  final String text;
  final bool disabled;
}