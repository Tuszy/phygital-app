import 'package:flutter/material.dart';
import 'package:phygital/component/image_upload.dart';
import 'package:provider/provider.dart';
import 'page/homepage.dart';
import 'service/nfc.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<NFC>(create: (_) => NFC()),
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  static const String appName = 'Phygital';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
        useMaterial3: true,
      ),
      home: const Homepage(),
    );
  }
}
