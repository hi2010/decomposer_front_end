import 'dart:math';

import 'package:flutter/material.dart';
// shell
import 'dart:io';
import 'dart:convert';

class ConsoleView extends StatefulWidget {
  @override
  State<ConsoleView> createState() {
    thisState = _ConsoleViewState();
    return thisState!;
  }

  _ConsoleViewState? thisState;

  void startProc() {
    thisState!.startProc();
  }
}

class _ConsoleViewState extends State<ConsoleView> {
  _ConsoleViewState() : thisScrollController = ScrollController();

  String consoleText = "";
  final ScrollController thisScrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.grey[800],
      width: double.infinity,
      //height: 150,
      height: MediaQuery.of(context).size.height * .3,
      child: SingleChildScrollView(
        controller: thisScrollController,
        child: Container(
          child: Text(
            consoleText,
            style: TextStyle(
              color: Colors.lightGreenAccent[400],
            ),
          ),
        ),
      ),
    );
  }

  // this should theoretically be in another thread and just be linked as a sort of update this to keep
  // some separation bewenn the view and the logic
  void startProc() async {
    try {
      // TODO: this needs an on check to select the right command
      var proc = await Process.start('cmd', ['/k', 'tracert', 'www.google.de']);
      proc.stdout.transform(utf8.decoder).forEach((element) {
        String resStr =
            DateTime.now().millisecondsSinceEpoch.toString() + ":\t" + element;
        print(resStr);
        String appendedText = "\n" + resStr;
        setState(() {
          consoleText = consoleText + appendedText;
        });

        thisScrollController.animateTo(max(consoleText.length.toDouble() - 1, 0), curve: Curves.ease, duration: const Duration(microseconds: 500));
      });
    } on ProcessException catch (err, stackTrace) {
      print(err.toString() + stackTrace.toString());
      print("got proc err");
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

}
