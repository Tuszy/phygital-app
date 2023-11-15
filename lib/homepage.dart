import 'package:flutter/material.dart';
import 'package:phygital/standard_page.dart';
import 'package:provider/provider.dart';

import 'button.dart';
import 'nfc.dart';
import 'logo.dart';
import 'phygital.dart';

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
    showInfoDialog(title: "Mint", text: "", buttonText: "OK");
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

    return StandardPage(
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
