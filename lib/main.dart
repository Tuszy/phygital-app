import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:logging/logging.dart';
import 'package:phygital/Phygital.dart';
import 'package:provider/provider.dart';
import 'NFC.dart';
import 'logo.dart';

void main() {
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<NFC>(create: (_) => NFC()),
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

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
  @override
  void initState() {
    super.initState();

    NFC().init();
  }

  void scan() async {
    try {
      Phygital phygital = await NFC().scan();
      showInfoDialog(title: "Phygital", text: phygital.toString(), buttonText: "OK");
    } catch (e) {
      showInfoDialog(title: "Error", text: e.toString(), buttonText: "Ok");
    }
  }

  void signUniversalProfileAddress() async {
    try {
      String universalProfileAddress =
          "0xeDe44390389A98441ff2B9dDCe862fFAC9BeB0cd";
      int nonce = 0;
      String signature = await NFC().signUniversalProfileAddress(
          universalProfileAddress, nonce);
      showInfoDialog(title: "Signature", text: signature, buttonText: "OK");
    } catch (e) {
      showInfoDialog(title: "Error", text: e.toString(), buttonText: "Ok");
    }
  }

  void setContractAddress() async {
    try {
      String contractAddress = "0xeDe44390389A98441ff2B9dDCe862fFAC9BeB0cd";
      contractAddress = await NFC().setContractAddress(contractAddress);
      showInfoDialog(
          title: "Contract Address", text: contractAddress, buttonText: "OK");
    } catch (e) {
      showInfoDialog(title: "Error", text: e.toString(), buttonText: "Ok");
    }
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
                          if (nfc.isAvailable)
                            ElevatedButton(
                                onPressed: scan,
                                child: const Text('Scan')),
                          if (nfc.isAvailable)
                            ElevatedButton(
                              onPressed: signUniversalProfileAddress,
                              child: const Text('Sign UP Address'),
                            ),
                          if (nfc.isAvailable)
                            ElevatedButton(
                              onPressed: setContractAddress,
                              child: const Text('Set Contract Address'),
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
