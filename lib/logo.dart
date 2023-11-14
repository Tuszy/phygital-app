import 'package:flutter/cupertino.dart';

import 'custom_drop_shadow.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: const CustomDropShadow(
        offset: Offset(0, 0),
        blurRadius: 15,
        color: Color(0x7700ffff),
        child: Image(
          image: AssetImage("images/logo.png"),
        ),
      ),
    );
  }
}
