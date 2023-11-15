import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:logging/logging.dart';
import 'package:ndef/utilities.dart';
import 'package:phygital/Phygital.dart';
import 'package:pointycastle/api.dart';
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

  Future<bool> writeContractAddress(String contractAddress) async {
    Uint8List writeContractAddressCommand = Uint8List.fromList("02aa022A01".toBytes()+utf8.encode(contractAddress));
    if(kDebugMode) {
      print("Writing contract address $contractAddress:");
      print(writeContractAddressCommand);
    }
    var value = await FlutterNfcKit.transceive(writeContractAddressCommand);
    if(kDebugMode) {
      print("Response: ${value.toHexString()}");
    }

    return value[0] == 0;
  }

  Future<int?> getMessageLength() async {
    Uint8List readMessageLengthCommand = "02ab02".toBytes();
    if(kDebugMode) {
      print("Reading message length:");
      print(readMessageLengthCommand);
    }
    var value = await FlutterNfcKit.transceive(readMessageLengthCommand);
    if(kDebugMode) {
      print("Response: ${value.toHexString()}");
    }

    return value[0] == 0 ? value[1] + 1 : null;
  }

  Future<bool> isMessageAvailable() async {
    Uint8List readMessageBoxStateCommand = "02ad020d".toBytes();
    if(kDebugMode) {
      print("Reading message state:");
      print(readMessageBoxStateCommand);
    }
    var value = await FlutterNfcKit.transceive(readMessageBoxStateCommand);
    if(kDebugMode) {
      print("Response: ${value.toHexString()} ${value[1].toRadixString(2)}");
    }

    return value[0] == 0 && (value[1] & 0x02) == 0x02;
  }

  Future<Uint8List?> readMessage() async {
    Uint8List readMessageCommand = "02ac020000".toBytes();
    if(kDebugMode) {
      print("Reading message:");
      print(readMessageCommand);
    }
    var value = await FlutterNfcKit.transceive(readMessageCommand);
    if(kDebugMode) {
      print("Response: ${value.toHexString()}");
    }

    return value[0] == 0 ? value.sublist(1) : null;
  }

  Future<bool> sendMessageToSign(Uint8List message, int nonce) async {
    Uint8List hashedMessage = hashMessageWithNonce(message, nonce);
    Uint8List signMessageCommand = Uint8List.fromList("02aa022000".toBytes()+hashedMessage);
    if(kDebugMode) {
      print("Sending message to sign (${hashedMessage.toHexString()}):");
      print(signMessageCommand);
    }
    var value = await FlutterNfcKit.transceive(signMessageCommand);
    if(kDebugMode) {
      print("Response: ${value.toHexString()}");
    }

    return value[0] == 0;
  }

  Uint8List hashMessageWithNonce(Uint8List message, int nonce) {
    Uint8List messageConcatenatedWithNonce = Uint8List.fromList(message+(nonce.toRadixString(16).padLeft(64, '0')).toBytes());
    final hashedMessage = Digest('Keccak/256').process(messageConcatenatedWithNonce);
    return hashedMessage;
  }

  Future<String?> signUniversalProfileAddress(String universalProfileAddress, int nonce) async {
    if(universalProfileAddress.length != 42) return null;

    bool isSent = false;
    for(var i=0;i<20 && !isSent;i++) {
      sleep(const Duration(milliseconds: 500));
      isSent = await sendMessageToSign(universalProfileAddress.substring(2).toBytes(), nonce);
    }
    if(!isSent) return null;

    bool isAvailable = false;
    for(var i=0;i<20 && !isAvailable;i++) {
      sleep(const Duration(milliseconds: 500));
      isAvailable = await isMessageAvailable();
    }

    if(isAvailable) {
      var message = await readMessage();
      if(message != null) {
        String signature = message.sublist(1).toHexString();
        if(kDebugMode) {
          print("Signature $signature");
        }
        return signature;
      }
    }

    return null;
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
        sleep(const Duration(seconds: 2)); // Energy harvesting

        //await writeContractAddress("0xfA3eF87642507BBE31373FC838350F75B8542734");

        String? signature = await signUniversalProfileAddress("0xeDe44390389A98441ff2B9dDCe862fFAC9BeB0cd", 0);
        if(signature != null){
          _showMyDialog(
              title: "Signature", text: signature, buttonText: "OK");
        }else{
          _showMyDialog(title: "Error", text: "Failed to sign the given universal profile address", buttonText: "OK");
        }
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
