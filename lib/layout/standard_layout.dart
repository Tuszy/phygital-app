import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';

import '../component/loading_backdrop.dart';
import '../model/layout_button_data.dart';

class StandardLayout extends StatefulWidget {
  const StandardLayout({
    super.key,
    required this.child,
    this.title,
    this.layoutButtonData,
  });

  final String? title;
  final Widget child;
  final LayoutButtonData? layoutButtonData;

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
            Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (BuildContext context,
                        BoxConstraints viewportConstraints) {
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
                ),
                if (widget.layoutButtonData != null)
                  Container(
                    decoration: BoxDecoration(
                      //color: Color(0x8800ffff),
                      border: const Border(
                        top: BorderSide(width: 2, color: Colors.white38),
                      ),
                      color: widget.layoutButtonData!.disabled
                          ? const Color(0x88555555)
                          : widget.layoutButtonData!.color,
                      boxShadow: [
                        BoxShadow(
                          color: widget.layoutButtonData!.disabled
                              ? const Color(0x88555555)
                              : widget.layoutButtonData!.color,
                          spreadRadius: 5,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: widget.layoutButtonData!.disabled
                              ? 10 : 3,
                          sigmaY: widget.layoutButtonData!.disabled
                              ? 10 : 3,
                        ),

                        /// Filter effect field
                        child: IgnorePointer(
                          ignoring: widget.layoutButtonData!.disabled,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: widget.layoutButtonData!.disabled
                                  ? const Color(0xaa999999)
                                  : const Color(0xcdffffff),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 24),
                              textStyle: const TextStyle(
                                letterSpacing: 3,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            onPressed: widget.layoutButtonData!.onClick,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [Text(widget.layoutButtonData!.text)],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const LoadingBackdrop()
          ],
        ),
      ),
    );
  }
}
