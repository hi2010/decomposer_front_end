import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

// shell
import 'dart:io';
import 'dart:convert';

class ConsoleViewModel extends ChangeNotifier {

  bool enableLogging = true;

  List<String> consoleText = [];

  void appendConsoleText(String text) {
    consoleText.add(text);
  }

  void appendConsoleTextNotify(String text) {
    consoleText.add(text);
    notifyListeners();
  }

  Future<int> execute(String cmd, List<String> args) async {
    var proc = await Process.start(cmd, args, runInShell: true);
    String appendedText = "";
    proc.stdout.transform(utf8.decoder).forEach((element) {
      String resStr =
            DateTime.now().millisecondsSinceEpoch.toString() + ":info:\t" + element;
      enableLogging ? debugPrint(resStr) : null;
      appendedText = "\n" + resStr;
      appendConsoleText(appendedText);
      notifyListeners();
    });
    proc.stderr.transform(utf8.decoder).forEach(((element) {
      String resStr =
            DateTime.now().millisecondsSinceEpoch.toString() + ":err:\t" + element;
      //print(resStr);
      enableLogging ? log(resStr) : null;
      enableLogging ? debugPrint(resStr) : null;
      appendedText = "\n" + resStr;
      appendConsoleText(appendedText);
      notifyListeners();
    }));
    //notifyListeners();
    var exC = await proc.exitCode;
    return exC;
    //var exc = await proc.exitCode;
    //return exc;
    //proc.exitCode.then((value) {return value;});
    
  }

}
