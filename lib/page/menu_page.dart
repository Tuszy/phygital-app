import 'package:flutter/material.dart';
import 'package:phygital/page/phygital/phygital_data_page.dart';
import 'package:phygital/service/custom_dialog.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/service/blockchain/lukso_client.dart';
import 'package:provider/provider.dart';

import '../component/button.dart';
import '../model/phygital_with_data.dart';
import '../service/result.dart';
import '../service/nfc.dart';
import '../model/phygital.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    NFC().init();
  }

  Future<void> showInfoDialog(
      {required String title, required String text}) async {
    return CustomDialog.showInfo(
        context: context, title: title, text: text, onPressed: () {});
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
          title: "Scan Result",
          text: getMessageForResult(result.$1),
        );
        return;
      }

      if (result.$2 == null) {
        showInfoDialog(
          title: "Scan Result",
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

  Future<void> mint() async {}

  Future<void> verifyOwnershipAfterTransfer() async {}

  Future<void> transfer() async {}

  Future<void> create() async {}

  @override
  Widget build(BuildContext context) {
    NFC nfc = Provider.of<NFC>(context);

    return StandardLayout(
      title: "Menu",
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                    disabled: !nfc.isAvailable,
                    text: "Read",
                    onPressed: scanPhygital,
                  ),
                  Button(
                    disabled: !nfc.isAvailable,
                    text: "Mint",
                    onPressed: mint,
                  ),
                  Button(
                    disabled: !nfc.isAvailable,
                    text: "Verify Ownership After Transfer",
                    onPressed: verifyOwnershipAfterTransfer,
                  ),
                  Button(
                    disabled: !nfc.isAvailable,
                    text: "Transfer",
                    onPressed: transfer,
                  ),
                  Button(
                    disabled: !nfc.isAvailable,
                    text: "Create Collection",
                    onPressed: create,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
