import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/layout/standard_layout.dart';
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
            title: "Phygital", text: phygital.toString(), buttonText: "OK");
      }
    } catch (e) {
      showInfoDialog(title: "Error", text: e.toString(), buttonText: "Ok");
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
        showInfoDialog(title: "Signature", text: signature, buttonText: "OK");
      }
    } catch (e) {
      showInfoDialog(title: "Error", text: e.toString(), buttonText: "Ok");
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
            buttonText: "OK");
      }
    } catch (e) {
      showInfoDialog(title: "Error", text: e.toString(), buttonText: "Ok");
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
      phygital.contractAddress = EthereumAddress("48379c84548B32D4582ECBAb2BE704F6a5333222".toBytes()); // unminted

      Result result =
          await LuksoClient().mint(phygital, universalProfileAddress);
      showInfoDialog(
          title: "Minting Result",
          text: getMessageForResult(result),
          buttonText: "Ok");
    } catch (e) {
      showInfoDialog(title: "Error", text: e.toString(), buttonText: "Ok");
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
      phygital.contractAddress = EthereumAddress("010bE908B3Ee4128c39528A077cD1a3cFA2Fe318".toBytes()); // already minted
      // phygital.contractAddress = EthereumAddress("48379c84548B32D4582ECBAb2BE704F6a5333222".toBytes()); // unminted

      Result result =
      await LuksoClient().verifyOwnershipAfterTransfer(phygital, universalProfileAddress);
      showInfoDialog(
          title: "Ownership Verification Result",
          text: getMessageForResult(result),
          buttonText: "Ok");
    } catch (e) {
      showInfoDialog(title: "Error", text: e.toString(), buttonText: "Ok");
    }
  }

  void create() async {
    showInfoDialog(title: "Create", text: "", buttonText: "OK");
  }

  Future<void> showInfoDialog(
      {required String title,
      required String text,
      required String buttonText}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(buttonText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                      text: "Verify Ownership",
                      onPressed: verifyOwnershipAfterTransfer,
                    ),
                  if (nfc.isAvailable)
                    Button(
                      text: "Create",
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
