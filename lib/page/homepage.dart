import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/layout/standard_layout.dart';
import 'package:phygital/service/lukso_client.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

import '../component/button.dart';
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
      String universalProfileAddress =
          "0xeDe44390389A98441ff2B9dDCe862fFAC9BeB0cd";
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
      String contractAddress = "0xeDe44390389A98441ff2B9dDCe862fFAC9BeB0cd";
      if (await NFC().setContractAddress(contractAddress) != null) {
        showInfoDialog(
            title: "Contract Address", text: contractAddress, buttonText: "OK");
      }
    } catch (e) {
      showInfoDialog(title: "Error", text: e.toString(), buttonText: "Ok");
    }
  }

  void mint() async {
    try {
      Phygital? phygital = await NFC().scan();
      if (phygital == null) throw Exception("Invalid Phygital");

      if(phygital.contractAddress == null) {
        showInfoDialog(
            title: "Minting",
            text: "Failed to mint the Phygital because it is not part of any collection.",
            buttonText: "Ok");
        return;
      }

      // TODO Remove after tests
      //phygital.contractAddress = EthereumAddress("A9Cd64B15Cf96543332A38481C347378C843767D".toBytes()); // not part of collection
      //phygital.contractAddress = EthereumAddress("010bE908B3Ee4128c39528A077cD1a3cFA2Fe318".toBytes()); // already minted
      phygital.contractAddress = EthereumAddress("48379c84548B32D4582ECBAb2BE704F6a5333222".toBytes()); // unminted

      MintResult result = await LuksoClient().mint(phygital);
      if (MintResult.success == result) {
        showInfoDialog(
            title: "Minting",
            text: "Successfully minted the Phygital",
            buttonText: "Ok");
      } else {
        showInfoDialog(
            title: "Minting",
            text: "Failed to mint the Phygital ($result)",
            buttonText: "Ok");
      }
    } catch (e) {
      showInfoDialog(title: "Error", text: e.toString(), buttonText: "Ok");
    }
  }

  void verifyOwnership() async {
    showInfoDialog(title: "Verify Ownership", text: "", buttonText: "OK");
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
                      onPressed: verifyOwnership,
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
