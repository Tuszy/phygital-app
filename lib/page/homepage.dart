import 'package:flutter/material.dart';
import 'package:phygital/model/phygital_with_data.dart';
import 'package:phygital/page/phygital/phygital_data_page.dart';
import 'package:phygital/service/blockchain/lukso_client.dart';
import 'package:phygital/service/custom_dialog.dart';
import 'package:phygital/component/image_preview.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/model/lsp0/universal_profile.dart';
import 'package:phygital/service/global_state.dart';
import 'package:phygital/service/qr_code.dart';
import 'package:provider/provider.dart';

import '../component/button.dart';
import '../service/result.dart';
import '../service/nfc.dart';
import '../component/logo.dart';
import '../model/phygital.dart';

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

  void scanPhygital() async {
    try {
      Phygital? phygital = await NFC().scan();
      if (phygital == null) return;
      if (phygital.contractAddress == null) {
        showInfoDialog(
          title: "Unassigned Phygital",
          text: phygital.toString(),
        );
        return;
      }

      (Result, PhygitalWithData?) result =
          await LuksoClient().fetchPhygitalData(phygital);
      if (Result.success != result.$1) {
        showInfoDialog(
          title: "Read Result",
          text: getMessageForResult(result.$1),
        );
        return;
      }

      if (result.$2 == null) {
        showInfoDialog(
          title: "Read Result",
          text: getMessageForResult(Result.invalidPhygitalData),
        );
        return;
      }

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhygitalDataPage(phygitalWithData: result.$2!),
        ),
      );
    } catch (e) {
      showInfoDialog(
        title: "Error",
        text: e.toString(),
      );
    }
  }

  void loginWithUniversalProfile() async {

    String? scannedCode = await CustomDialog.showQrScanner(
      context: context,
      title: "Universal Profile",
    );

    if (!mounted || scannedCode == null) return;

    GlobalState().loading = true;
    (Result, UniversalProfile?)? result = await QRCode().getUniversalProfile(
      scannedCode: scannedCode,
      validatePermissions: true,
    );
    if (Result.necessaryPermissionsNotSet == result.$1) {
      showQRCode(
          "Missing permissions.\nSet them on: $frontendUrl", frontendUrl);
    } else if (Result.success != result.$1) {
      showInfoDialog(
        title: "Scan Result",
        text: getMessageForResult(result.$1),
      );
    }

    GlobalState().universalProfile = result.$2;
    GlobalState().loading = false;
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

  @override
  Widget build(BuildContext context) {
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
            if (universalProfile != null &&
                universalProfile.profileImage != null)
              ImagePreview(
                image: universalProfile.profileImage!,
                width: 150,
                height: 150,
              ),
            Expanded(
              child: globalState.initialized
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                          text: "Scan Phygital",
                          onPressed: scanPhygital,
                        ),
                        if (universalProfile == null)
                          Button(
                            text: "Login with Universal Profile",
                            onPressed: loginWithUniversalProfile,
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
