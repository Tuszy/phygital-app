import 'package:flutter/material.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/model/phygital_with_data.dart';
import 'package:phygital/service/blockchain/lukso_client.dart';
import 'package:phygital/service/custom_dialog.dart';
import 'package:phygital/component/image_preview.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/model/lsp0/universal_profile.dart';
import 'package:phygital/service/qr_code.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';

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
  UniversalProfile? _universalProfile;

  @override
  void initState() {
    super.initState();
    NFC().init();
  }

  void readPhygital() async {
    try {
      Phygital? phygital = await NFC().scan();
      if(phygital == null) return;
      if (phygital.contractAddress == null) {
        showInfoDialog(
          title: "Unassigned Phygital",
          text: phygital.toString(),
        );
        return;
      }

      (Result, PhygitalWithData?) phygitalWithData = await LuksoClient().fetchPhygitalData(phygital);
      if(Result.success != phygitalWithData.$1){
        showInfoDialog(
          title: "Read Result",
          text: getMessageForResult(phygitalWithData.$1),
        );
        return;
      }

      // TODO OPEN PHYGITAL PAGE


    } catch (e) {
      showInfoDialog(
        title: "Error",
        text: e.toString(),
      );
    }
  }

  void scanQRCode() async {
    String? scannedCode = await CustomDialog.showQrScanner(
      context: context,
      title: "Universal Profile",
    );

    if (!mounted || scannedCode == null) return;

    (Result, UniversalProfile?)? result = await QRCode().getUniversalProfile(
      scannedCode: scannedCode,
      validatePermissions: true,
    );

    if (Result.success != result.$1) {
      showInfoDialog(
        title: "Scan Result",
        text: getMessageForResult(result.$1),
      );
    }

    setState(() {
      _universalProfile = result.$2;
    });
  }

  void showQRCode() {
    CustomDialog.showQrCode(
      context: context,
      title: "Test",
      data: 'ethereum:0x1E9122dc5a7F6391d535cC3c59f20445585984db@4201',
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
    NFC nfc = Provider.of<NFC>(context);

    return StandardLayout(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const LogoWidget(),
            if (_universalProfile != null &&
                _universalProfile!.profileImages != null &&
                _universalProfile!.profileImages!.isNotEmpty)
              ImagePreview(
                image: _universalProfile!.profileImages![0],
                width: 150,
                height: 150,
              ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                    text: "Read Phygital",
                    onPressed: readPhygital,
                  ),
                  Button(
                    text: "Scan QR Code",
                    onPressed: scanQRCode,
                  ),
                  /*Button(
                    text: "Show QR Code",
                    onPressed: showQRCode,
                  ),
                  if (nfc.isAvailable)
                    Button(
                      text: "Read",
                      onPressed: read,
                    ),
                  if (nfc.isAvailable)
                    Button(
                      text: "Mint",
                      onPressed: mint,
                    ),
                  if (nfc.isAvailable)
                    Button(
                      text: "Transfer",
                      onPressed: transfer,
                    ),
                  if (nfc.isAvailable)
                    Button(
                      text: "Verify Ownership",
                      onPressed: verifyOwnershipAfterTransfer,
                    ),
                  if (nfc.isAvailable)
                    Button(
                      text: "Create",
                      onPressed: create,
                    ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
