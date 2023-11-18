import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';

import '../component/loading_backdrop.dart';

class StandardLayout extends StatefulWidget {
  const StandardLayout({super.key, required this.child, this.title});

  final String? title;
  final Widget child;

  @override
  State<StandardLayout> createState() => _StandardLayoutState();
}

class _StandardLayoutState extends State<StandardLayout>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: widget.title != null
          ? AppBar(
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              title: Text(
                widget.title!,
              ),
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
              backgroundColor: const Color(0x8800ffff),
              shadowColor: const Color(0x8800ffff),
              elevation: 6,
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 28,
              ),
            )
          : null,
      body: Container(
        padding: widget.title != null ? const EdgeInsets.only(top: 16) : null,
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
            LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: SafeArea(
                        child: widget.child,
                      ),
                    ),
                  ),
                );
              },
            ),
            const LoadingBackdrop()
          ],
        ),
      ),
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: widget.title != null
          ? AppBar(
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              title: Text(
                widget.title!,
              ),
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
              backgroundColor: const Color(0x8800ffff),
              shadowColor: const Color(0x8800ffff),
              elevation: 6,
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 28,
              ),
            )
          : null,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Container(
                  padding: widget.title != null ? const EdgeInsets.only(top: 16) : null,
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
                        child: widget.child,
                      ),
                      const LoadingBackdrop()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
   */
}
