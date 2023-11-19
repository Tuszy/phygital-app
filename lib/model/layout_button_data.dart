import 'dart:ui';

class LayoutButtonData {
  LayoutButtonData({
    required this.onClick,
    this.text = "CONFIRM",
    this.disabled = false,
    this.color = const Color(0x7700ff00),
  });

  final VoidCallback onClick;
  final String text;
  final bool disabled;
  final Color color;
}
