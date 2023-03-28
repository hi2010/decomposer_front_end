import 'dart:math';

import 'package:flutter/material.dart';


class ConsoleViewMVVM extends StatelessWidget {
  var maxConsoleLines = 10000;

  ConsoleViewMVVM( {
    super.key,
    consoleText="",
  } ) : _consoleText=consoleText {
    // after build method
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToEnd();
    });
  }
  
  final List<String> _consoleText;

  /*void set consoleText(String value) {
    _consoleText = value;
  }
  */

  List<String> get consoleText {
    return _consoleText;
  }

  static final ScrollController scrolCtrl = ScrollController();

  List<TextSpan> getConsoleTextAsSpans() {
    List<TextSpan> lstSpan = [];

    var startIdx = _consoleText.length > maxConsoleLines ? _consoleText.length-maxConsoleLines : 0;
    var endIdx = _consoleText.length-1;

    for (var i = startIdx; i < endIdx; i++) {
      var itm = _consoleText[i];
      TextStyle ts;
      if (itm.toLowerCase().contains("err:")) {
        // isss err
        ts = TextStyle(
          color: Colors.red,
        );
      } else {
        ts = TextStyle(
          color: Colors.lightGreenAccent[400],
        );
      }
      lstSpan.add(
        TextSpan(text: itm, style: ts)
      );
    }
    return lstSpan;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.grey[800],
      width: double.infinity,
      //height: 150,
      child: SingleChildScrollView(
        controller: scrolCtrl,
        child:RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: getConsoleTextAsSpans(),
        ),
      ),
    ));
  }

  void scrollToEnd() async {
    if (scrolCtrl.hasClients) {
      scrolCtrl.animateTo(scrolCtrl.position.maxScrollExtent, curve: Curves.ease, duration: const Duration(microseconds: 500));
    }
  }
}
