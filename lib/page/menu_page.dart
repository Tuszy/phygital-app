import 'package:flutter/material.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/model/layout_button_data.dart';
import 'package:phygital/page/phygital/phygital_page.dart';
import 'package:phygital/service/custom_dialog.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/service/blockchain/lukso_client.dart';
import 'package:phygital/service/global_state.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';

import '../component/button.dart';
import '../model/phygital.dart';
import '../service/result.dart';
import '../service/nfc.dart';
import '../model/phygital_tag.dart';

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

  void scan(
      {bool mustHaveValidPhygitalData = true,
      required Function(Phygital) onSuccess}) async {
    try {
      PhygitalTag phygitalTag = await NFC().read(mustHaveContractAddress: true);
      GlobalState().loadingWithText = "Fetching Phygital Data...";
      (Result, Phygital?) result =
          await LuksoClient().fetchPhygitalData(phygitalTag: phygitalTag);
      GlobalState().loadingWithText = null;
      if (Result.success != result.$1) {
        throw getMessageForResult(result.$1);
      } else if (result.$2 == null) {
        throw getMessageForResult(Result.invalidPhygitalData);
      }

      if (!mounted) return;

      await onSuccess(result.$2!);
    } catch (e) {
      GlobalState().loadingWithText = null;
      showInfoDialog(
        title: "Scan Result",
        text: e.toString(),
      );
    }
  }

  void read() async {
    scan(
      onSuccess: (Phygital? phygital) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhygitalPage(
              phygital: phygital!,
            ),
          ),
        );
      },
    );
  }

  Future<void> mint() async {
    if (GlobalState().universalProfile == null) return;

    scan(
      onSuccess: (Phygital phygital) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhygitalPage(
              layoutButtonData: LayoutButtonData(
                text:
                    phygital.owner != null ? "ALREADY MINTED" : "MINT",
                disabled: phygital.owner != null,
                onClick: () async {
                  Result result = await phygital.mint();
                  await showInfoDialog(
                    title: "Result",
                    text: getMessageForResult(result),
                  );
                  if (Result.mintSucceeded != result) return;
                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhygitalPage(
                        phygital: phygital,
                      ),
                    ),
                  );
                },
              ),
              phygital: phygital,
            ),
          ),
        );
      },
    );
  }

  Future<void> verifyOwnershipAfterTransfer() async {
    if (GlobalState().universalProfile == null) return;

    scan(
      onSuccess: (Phygital phygital) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhygitalPage(
              layoutButtonData: LayoutButtonData(
                text: phygital.owner == null
                    ? "NOT MINTED YET"
                    : phygital.verifiedOwnership
                        ? "ALREADY VERIFIED"
                        : "VERIFY OWNERSHIP",
                disabled: phygital.owner == null || phygital.verifiedOwnership,
                onClick: () async {
                  Result result = await phygital.verifyOwnership();
                  await showInfoDialog(
                    title: "Result",
                    text: getMessageForResult(result),
                  );
                  if (Result.ownershipVerificationSucceeded != result) return;
                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhygitalPage(
                        phygital: phygital,
                      ),
                    ),
                  );
                },
              ),
              phygital: phygital,
            ),
          ),
        );
      },
    );
  }

  Future<void> transfer() async {}

  Future<void> create() async {}

  Future<void> setContractAddress() async {
    EthereumAddress newContractAddress =
        EthereumAddress("61b882aa41B88DD6e9b196aF55E0A48889f23cF5".toBytes());
    scan(
      onSuccess: (Phygital phygital) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhygitalPage(
              layoutButtonData: LayoutButtonData(
                text: "Assign Collection",
                onClick: () async {
                  Result result = await phygital
                      .setContractAddress(newContractAddress);
                  await showInfoDialog(
                    title: "Result",
                    text: getMessageForResult(result),
                  );
                  if (Result.assigningCollectionSucceeded != result) return;
                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhygitalPage(
                        phygital: phygital,
                      ),
                    ),
                  );
                },
              ),
              phygital: phygital,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    NFC nfc = Provider.of<NFC>(context);

    return StandardLayout(
      title: "Menu",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Button(
            disabled: !nfc.isAvailable,
            text: "Read",
            onPressed: read,
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
          Button(
            disabled: !nfc.isAvailable,
            text: "Assign Collection",
            onPressed: setContractAddress,
          ),
        ],
      ),
    );
  }
}
