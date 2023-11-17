import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/component/custom_dialog.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/model/lsp4/lsp4_image.dart';
import 'package:phygital/model/lsp4/lsp4_link.dart';
import 'package:phygital/model/lsp4/lsp4_metadata.dart';
import 'package:phygital/model/lsp4/lsp4_verification.dart';
import 'package:phygital/service/blockchain/lukso_client.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

import '../component/button.dart';
import '../service/blockchain/result.dart';
import '../service/nfc.dart';
import '../component/logo.dart';
import '../model/phygital.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();

    NFC().init();
  }

  void read() async {
    try {
      Phygital? phygital = await NFC().scan();
      if (phygital != null) {
        showInfoDialog(
          title: "Phygital",
          text: phygital.toString(),
        );
      }
    } catch (e) {
      showInfoDialog(
        title: "Error",
        text: e.toString(),
      );
    }
  }

  void signUniversalProfileAddress() async {
    try {
      EthereumAddress universalProfileAddress =
          EthereumAddress("eDe44390389A98441ff2B9dDCe862fFAC9BeB0cd".toBytes());
      int nonce = 0;
      String? signature = await NFC()
          .signUniversalProfileAddress(universalProfileAddress, nonce);
      if (signature != null) {
        showInfoDialog(
          title: "Signature",
          text: signature,
        );
      }
    } catch (e) {
      showInfoDialog(
        title: "Error",
        text: e.toString(),
      );
    }
  }

  void setContractAddress() async {
    try {
      EthereumAddress contractAddress =
          EthereumAddress("eDe44390389A98441ff2B9dDCe862fFAC9BeB0cd".toBytes());
      if (await NFC().setContractAddress(contractAddress) != null) {
        showInfoDialog(
          title: "Contract Address",
          text: contractAddress.hexEip55,
        );
      }
    } catch (e) {
      showInfoDialog(
        title: "Error",
        text: e.toString(),
      );
    }
  }

  void mint() async {
    EthereumAddress universalProfileAddress =
        EthereumAddress("eDe44390389A98441ff2B9dDCe862fFAC9BeB0cd".toBytes());

    try {
      Phygital? phygital = await NFC().scan();
      if (phygital == null) throw "Invalid Phygital";

      // TODO Remove after tests
      // phygital.contractAddress = EthereumAddress("A9Cd64B15Cf96543332A38481C347378C843767D".toBytes()); // not part of collection
      // phygital.contractAddress = EthereumAddress("010bE908B3Ee4128c39528A077cD1a3cFA2Fe318".toBytes()); // already minted
      phygital.contractAddress = EthereumAddress(
          "48379c84548B32D4582ECBAb2BE704F6a5333222".toBytes()); // unminted

      Result result =
          await LuksoClient().mint(phygital, universalProfileAddress);
      showInfoDialog(
        title: "Minting Result",
        text: getMessageForResult(result),
      );
    } catch (e) {
      showInfoDialog(
        title: "Error",
        text: e.toString(),
      );
    }
  }

  void verifyOwnershipAfterTransfer() async {
    EthereumAddress universalProfileAddress =
        EthereumAddress("eDe44390389A98441ff2B9dDCe862fFAC9BeB0cd".toBytes());

    try {
      Phygital? phygital = await NFC().scan();
      if (phygital == null) throw "Invalid Phygital";

      sleep(const Duration(seconds: 5));

      // TODO Remove after tests
      // phygital.contractAddress = EthereumAddress("A9Cd64B15Cf96543332A38481C347378C843767D".toBytes()); // not part of collection
      // phygital.contractAddress = EthereumAddress("010bE908B3Ee4128c39528A077cD1a3cFA2Fe318".toBytes()); // already minted
      phygital.contractAddress = EthereumAddress(
          "48379c84548B32D4582ECBAb2BE704F6a5333222".toBytes()); // unminted

      Result result = await LuksoClient()
          .verifyOwnershipAfterTransfer(phygital, universalProfileAddress);
      showInfoDialog(
        title: "Ownership Verification Result",
        text: getMessageForResult(result),
      );
    } catch (e) {
      showInfoDialog(
        title: "Error",
        text: e.toString(),
      );
    }
  }

  void transfer() async {
    EthereumAddress fromUniversalProfileAddress =
        EthereumAddress("eDe44390389A98441ff2B9dDCe862fFAC9BeB0cd".toBytes());
    EthereumAddress toUniversalProfileAddress =
        EthereumAddress("1E9122dc5a7F6391d535cC3c59f20445585984db".toBytes());

    try {
      Phygital? phygital = await NFC().scan();
      if (phygital == null) throw "Invalid Phygital";

      sleep(const Duration(seconds: 5));

      // TODO Remove after tests
      // phygital.contractAddress = EthereumAddress("A9Cd64B15Cf96543332A38481C347378C843767D".toBytes()); // not part of collection
      // phygital.contractAddress = EthereumAddress("010bE908B3Ee4128c39528A077cD1a3cFA2Fe318".toBytes()); // already minted
      phygital.contractAddress = EthereumAddress(
          "48379c84548B32D4582ECBAb2BE704F6a5333222".toBytes()); // minted

      Result result = await LuksoClient().transfer(
          phygital, fromUniversalProfileAddress, toUniversalProfileAddress);
      showInfoDialog(
        title: "Transfer Result",
        text: getMessageForResult(result),
      );
    } catch (e) {
      showInfoDialog(
        title: "Error",
        text: e.toString(),
      );
    }
  }

  void create() async {
    EthereumAddress universalProfileAddress =
        EthereumAddress("eDe44390389A98441ff2B9dDCe862fFAC9BeB0cd".toBytes());
    String name = "Sneaker";
    String symbol = "SNKR";
    List<Phygital> phygitalCollection = [
      Phygital(
          address: EthereumAddress(
              "0A942309aEF13Ae9823AcfAaAb169Da8A942EC92".toBytes())),
      Phygital(
          address: EthereumAddress(
              "3C44CdDdB6a900fa2b585dd299e03d12FA4293BC".toBytes())),
      Phygital(
          address: EthereumAddress(
              "90F79bf6EB2c4f870365E785982E1f101E93b906".toBytes()))
    ];
    String baseUri = "ipfs://QmYFAK6UbQbAZS6HZKeVro4SerVpLmL7WY1C1h8QaV9Mci/";
    LSP4Image lsp4image = LSP4Image(
        width: 400,
        height: 400,
        url: "ifps://QmTCqXeST1vFBjUW15f9zXJMJKSz9JcG5gi7wajxs8MGwK",
        verification: LSP4Verification(
            data:
                "0x6b3a0632917e88438de44d42a32115f6104b58f1cc025e00738debf2e65d5acb"));
    LSP4Metadata metadata =
        LSP4Metadata(description: "Phygital Sneaker Collection", links: [
      LSP4Link(title: "Homepage", url: "https://phygital.tuszy.com")
    ], icon: [
      lsp4image
    ], images: [
      [lsp4image]
    ]);

    try {
      (Result, EthereumAddress?) result = await LuksoClient().create(
          universalProfileAddress,
          name,
          symbol,
          phygitalCollection,
          metadata,
          baseUri);
      showInfoDialog(
        title: "Creation Result",
        text: getMessageForResult(result.$1) +
            (result.$2 != null ? "\n${result.$2!.hexEip55}" : ""),
      );
    } catch (e) {
      showInfoDialog(
        title: "Error",
        text: e.toString(),
      );
    }
  }

  void scanQRCode() {
    CustomDialog.showQrScanner(
        context: context,
        title: "Universal Profile",
        onScanSuccess: (code) {
          setState(() {
            print(code);
          });
        });
  }

  void showQRCode() {
    CustomDialog.showQrCode(
      context: context,
      title: "Test",
      data:
          '0x6b3a0632917e88438de44d42a32115f6104b58f1cc025e00738debf2e65d5acb',
      onPressed: () {},
    );
  }

  Future<void> showInfoDialog(
      {required String title, required String text}) async {
    return CustomDialog.showInfo(title: title, text: text, onPressed: () {});
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                    text: "Scan QR Code",
                    onPressed: scanQRCode,
                  ),
                  Button(
                    text: "Show QR Code",
                    onPressed: showQRCode,
                  ),
                  if (nfc.isAvailable)
                    Button(
                      text: "Read",
                      onPressed: read,
                    ),
                  /*if (nfc.isAvailable)
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
