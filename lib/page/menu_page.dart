import 'package:flutter/material.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/model/layout_button_data.dart';
import 'package:phygital/page/create_collection_page.dart';
import 'package:phygital/page/phygital_page.dart';
import 'package:phygital/page/universal_profile_page.dart';
import 'package:phygital/service/custom_dialog.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/service/blockchain/lukso_client.dart';
import 'package:phygital/service/global_state.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/credentials.dart';

import '../component/button.dart';
import '../model/lsp0/universal_profile.dart';
import '../model/phygital/phygital.dart';
import '../service/qr_code.dart';
import '../service/result.dart';
import '../service/nfc.dart';
import '../model/phygital/phygital_tag.dart';

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
      GlobalState().loadingWithText = "Fetching Phygital Data";
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
        title: "Result",
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
                text: phygital.owner != null ? "ALREADY MINTED" : "MINT",
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
                text: (phygital.owner == null
                    ? "NOT MINTED YET"
                    : (phygital.owner!.address.hexEip55 !=
                            GlobalState().universalProfile!.address.hexEip55)
                        ? "OTHER OWNER"
                        : (phygital.verifiedOwnership
                            ? "ALREADY VERIFIED"
                            : "VERIFY OWNERSHIP")),
                disabled: phygital.owner == null ||
                    phygital.owner!.address.hexEip55 !=
                        GlobalState().universalProfile!.address.hexEip55 ||
                    phygital.verifiedOwnership,
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

  Future<UniversalProfile?> scanUniversalProfile() async {
    String? scannedCode = await CustomDialog.showQrScanner(
      context: context,
      title: "To Universal Profile",
    );

    if (!mounted || scannedCode == null) return null;

    GlobalState().loadingWithText = "Fetching Recipient Data...";
    (Result, UniversalProfile?)? result = await QRCode().getUniversalProfile(
      scannedCode: scannedCode,
    );
    if (Result.success != result.$1) {
      showInfoDialog(
        title: "Result",
        text: getMessageForResult(result.$1),
      );
      return null;
    } else if (null == result.$2) {
      showInfoDialog(
        title: "Result",
        text: "Invalid Universal Profile.",
      );
      return null;
    }

    GlobalState().loadingWithText = null;
    return result.$2;
  }

  Future<void> transfer() async {
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
                    : !phygital.verifiedOwnership
                        ? "UNVERIFIED OWNER"
                        : "TRANSFER",
                disabled: phygital.owner == null || !phygital.verifiedOwnership,
                onClick: () async {
                  UniversalProfile? toUniversalProfile =
                      await scanUniversalProfile();

                  if (toUniversalProfile == null) return;
                  if (toUniversalProfile.address.hexEip55 ==
                      GlobalState().universalProfile!.address.hexEip55) {
                    await showInfoDialog(
                      title: "Result",
                      text:
                          getMessageForResult(Result.mustNotTransferToYourself),
                    );
                    return;
                  }
                  if (!mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UniversalProfilePage(
                        layoutButtonData: LayoutButtonData(
                          onClick: () async {
                            Result result =
                                await phygital.transfer(toUniversalProfile);
                            await showInfoDialog(
                              title: "Result",
                              text: getMessageForResult(result),
                            );
                            if (Result.transferSucceeded != result) return;
                            if (!mounted) return;
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhygitalPage(
                                  phygital: phygital,
                                ),
                              ),
                              (var route) => route.settings.name == "menu",
                            );
                          },
                        ),
                        universalProfile: toUniversalProfile,
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

  Future<void> create() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateCollectionPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StandardLayout(
      title: "Menu",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Button(
            text: "Read",
            onPressed: read,
          ),
          Button(
            text: "Mint",
            onPressed: mint,
          ),
          Button(
            text: "Verify Ownership After Transfer",
            onPressed: verifyOwnershipAfterTransfer,
          ),
          Button(
            text: "Transfer",
            onPressed: transfer,
          ),
          Button(
            text: "Create Collection",
            onPressed: create,
          ),
        ],
      ),
    );
  }
}
