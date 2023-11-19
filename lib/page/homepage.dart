import 'package:flutter/material.dart';
import 'package:phygital/component/universal_profile_light_preview.dart';
import 'package:phygital/model/phygital/phygital.dart';
import 'package:phygital/page/menu_page.dart';
import 'package:phygital/page/phygital_page.dart';
import 'package:phygital/page/universal_profile_page.dart';
import 'package:phygital/service/blockchain/lukso_client.dart';
import 'package:phygital/service/custom_dialog.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/model/lsp0/universal_profile.dart';
import 'package:phygital/service/global_state.dart';
import 'package:phygital/service/qr_code.dart';
import 'package:provider/provider.dart';

import '../component/button.dart';
import '../service/result.dart';
import '../service/nfc.dart';
import '../component/logo.dart';
import '../model/phygital/phygital_tag.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static const String frontendUrl = "www.phygital.tuszy.com";

  @override
  void initState() {
    super.initState();
    GlobalState().init();
    NFC().init();
  }

  void read() async {
    try {
      PhygitalTag phygitalTag = await NFC().read(mustHaveContractAddress: true);

      (Result, Phygital?) result =
          await LuksoClient().fetchPhygitalData(phygitalTag: phygitalTag);
      if (Result.success != result.$1) {
        throw getMessageForResult(result.$1);
      } else if (result.$2 == null) {
        throw getMessageForResult(Result.invalidPhygitalData);
      }

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhygitalPage(phygital: result.$2!),
        ),
      );
    } catch (e) {
      showInfoDialog(
        title: "Result",
        text: e.toString(),
      );
    }
  }

  void openMenu() {
    if (GlobalState().universalProfile == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: "menu"),
        builder: (context) => const MenuPage(),
      ),
    );
  }

  void loginWithUniversalProfile() async {
    String? scannedCode = await CustomDialog.showQrScanner(
      context: context,
      title: "Universal Profile",
    );

    if (!mounted || scannedCode == null) return;

    GlobalState().loadingWithText = "Login...";
    (Result, UniversalProfile?)? result = await QRCode().getUniversalProfile(
      scannedCode: scannedCode,
      validatePermissions: true,
    );
    if (Result.necessaryPermissionsNotSet == result.$1) {
      showQRCode(
          "Missing permissions.\nSet them on: $frontendUrl", frontendUrl);
    } else if (Result.success != result.$1) {
      showInfoDialog(
        title: "Result",
        text: getMessageForResult(result.$1),
      );
    }

    GlobalState().universalProfile = result.$2;
    GlobalState().loadingWithText = null;
  }

  void logout() => GlobalState().universalProfile = null;

  void showQRCode(String title, String data) {
    CustomDialog.showQrCode(
      context: context,
      title: title,
      data: data,
      onPressed: () {},
    );
  }

  Future<void> showInfoDialog(
      {required String title, required String text}) async {
    return CustomDialog.showInfo(
        context: context, title: title, text: text, onPressed: () {});
  }

  void showLoggedInUniversalProfile() {
    UniversalProfile? universalProfile = GlobalState().universalProfile;
    if (universalProfile == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UniversalProfilePage(universalProfile: universalProfile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    NFC nfc = Provider.of<NFC>(context);
    GlobalState globalState = Provider.of<GlobalState>(context);
    UniversalProfile? universalProfile = globalState.universalProfile;

    return StandardLayout(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const LogoWidget(),
            if (universalProfile != null)
              GestureDetector(
                onTap: showLoggedInUniversalProfile,
                child: UniversalProfileLightPreview(
                  universalProfile: universalProfile,
                ),
              ),
            Expanded(
              child: globalState.initialized
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (universalProfile == null)
                          Button(
                            text: "Scan Phygital",
                            onPressed: read,
                          ),
                        if (universalProfile == null)
                          Button(
                            text: "Login with Universal Profile",
                            onPressed: loginWithUniversalProfile,
                          ),
                        if (universalProfile != null)
                          Button(
                            text: "Menu",
                            onPressed: openMenu,
                          ),
                        if (universalProfile != null)
                          Button(
                            text: "Logout",
                            onPressed: logout,
                          ),
                      ],
                    )
                  : Center(
                      child: Transform.scale(
                        scale: 2,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Color(0x7700ffff)),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
