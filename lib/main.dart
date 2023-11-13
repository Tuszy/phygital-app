import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'custom_drop_shadow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phygital',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Test"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  void _incrementCounter() {
    setState(() {});
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
                  behaviour: SpaceBehaviour(backgroundColor: Colors.transparent),
                  vsync: this,
                  child: const Positioned.fill(
                    child: ColoredBox(color: Colors.transparent),
                  )),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: const CustomDropShadow(
                        offset: Offset(0, 0),
                        blurRadius: 15,
                        color: Color(0x7700ffff),
                        child: Image(
                          image: AssetImage("images/logo.png"),
                        ),
                      ),
                    )
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
