import 'package:flutter/cupertino.dart';

class LuksoClient extends ChangeNotifier {
  LuksoClient._sharedInstance();

  static final LuksoClient _shared = LuksoClient._sharedInstance()._init();

  factory LuksoClient() => _shared;

  LuksoClient _init() {


    return this;
  }
}
