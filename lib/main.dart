import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:logging/logging.dart';
import 'package:phygital/Phygital.dart';
import 'logo.dart';

import 'package:ndef/ndef.dart' as ndef;

void main() {
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phygital',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
        useMaterial3: true,
      ),
      home: const Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  NFCAvailability _availability = NFCAvailability.not_supported;

  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    NFCAvailability availability;
    try {
      availability = await FlutterNfcKit.nfcAvailability;
    } on PlatformException {
      availability = NFCAvailability.not_supported;
    }

    if (!mounted) return;

    setState(() {
      _availability = availability;
    });
  }

  Future<void> _showMyDialog(
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

  Future<Phygital?> validateScannedTag(NFCTag tag) async {
    if (NFCTagType.iso15693 != tag.type ||
        "ISO 15693" != tag.standard ||
        !(tag.ndefAvailable ?? false)) return null;

    var ndefRecords = await FlutterNfcKit.readNDEFRecords();
    if (ndefRecords.length != 2 && ndefRecords.length != 3) return null;
    if (ndefRecords[0].decodedType != "U" ||
        ndefRecords[1].decodedType != "T" ||
        (ndefRecords.length == 3 && ndefRecords[2].decodedType != "T")) {
      return null;
    }

    String uri = String.fromCharCodes(ndefRecords[0].payload!.sublist(1));
    if (Phygital.uri != uri) return null;

    String address = String.fromCharCodes(ndefRecords[1].payload!.sublist(3));
    String? contractAddress = ndefRecords.length == 3
        ? String.fromCharCodes(ndefRecords[2].payload!.sublist(3))
        : null;

    return Phygital(address: address, contractAddress: contractAddress);
  }

  Future<void> scanTag() async {
    try {
      NFCTag tag = await FlutterNfcKit.poll(
          iosAlertMessage: "Hold your iPhone near the Phygital");
      await FlutterNfcKit.setIosAlertMessage("Reading Phygital");
      Phygital? phygital = await validateScannedTag(tag);

      if (phygital == null) {
        _showMyDialog(
            title: "Error", text: "This is not a Phygital", buttonText: "OK");
      } else {
        _showMyDialog(
            title: "Data", text: phygital.toString(), buttonText: "OK");
      }
    } catch (e) {
      _showMyDialog(title: "Error", text: e.toString(), buttonText: "OK");
    }

    sleep(const Duration(seconds: 1)); // Energy harvesting
    await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xffa00661),
              Color(0xff3a0838),
            ],
          ),
        ),
        child: Stack(
          children: [
            IgnorePointer(
              ignoring: true,
              child: AnimatedBackground(
                  behaviour:
                      SpaceBehaviour(backgroundColor: Colors.transparent),
                  vsync: this,
                  child: const ColoredBox(color: Colors.transparent)),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const LogoWidget(),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (NFCAvailability.available == _availability)
                            ElevatedButton(
                              onPressed: scanTag,
                              child: const Text('Scan Phygital'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
