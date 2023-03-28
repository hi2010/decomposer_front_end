import 'dart:developer';

import 'dart:async';

// shell
import 'dart:io';
import 'dart:convert';

// TODO: create a way to insert notifying structures for ui

class Processrunner {
  void _log(String msg) {
    log(msg, name: "Processrunner");
  }

  bool enableLogging = false;

  List<String> consoleText = [];

  // just call em instead of always checking
  // maybe not best performance but this way the coder is cleaner and shorter
  static final _nop = (p0) => 0;
  void Function(String) onMsgCallback = _nop;
  void Function(String) onErrCallback = _nop;
  void Function(String) onAnyMsgCallback = _nop;

  void executeNoArg() {
    execute("dir", []);
    execute("dire", []);
  }

  void appendConsoleText(String text) {
    consoleText.add(text);
  }

  Future<int> execute(String cmd, List<String> args) async {
    // TODO: add isStuck detection
    _log("will execute: cmd: $cmd args: $args");
    var proc = await Process.start(cmd, args, runInShell: true);
    String appendedText = "";
    addMsg(String textCont) {
      String resStr =
            DateTime.now().millisecondsSinceEpoch.toString() + textCont;
      appendedText = "\n$resStr";
      appendConsoleText(appendedText);
    }
    
    proc.stdout.transform(utf8.decoder).forEach((element) {
      addMsg(":info:\t$element");
      onMsgCallback(element);
      onAnyMsgCallback(element);
      if (enableLogging)
        _log(":info:\t$element");
    });
    proc.stderr.transform(utf8.decoder).forEach(((element) {
      addMsg(":err:\t$element");
      onErrCallback(element);
      onAnyMsgCallback(element);
      if (enableLogging)
        _log(":err:\t$element");
    }));
    var exC = await proc.exitCode;
    return exC;
  }

}
