import 'dart:developer';

import 'package:decomposer_front_end/console_widget_mvvm/console_viewmodel.dart';
//import 'package:test/test.dart';
// -> //
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("console view should execute some task successfull", (WidgetTester tester) async {
    print("");
  //test("console view should execute some task", () async {
    final cvm = ConsoleViewModel();
    cvm.enableLogging = true;
    //var appTxt = await tester.runAsync(() => cvm.execute("tracert", ["www.google.de"]));
    int? returnCode = await tester.runAsync(() => cvm.execute("echo", ["hello from subscript"]));
    //var appTxt = await cvm.execute("");
    log("logMsg:consoleText: {$cvm.consoleText}");
    log("logMsg:returnCode: $returnCode ");
    expect(returnCode, 0);
    //appTxt.then((value) => print(value));
    // expect(value, value);
  });
  testWidgets("console view should execute some task and fail returning return code -1 on win", (WidgetTester tester) async {
    print("");
    final cvm = ConsoleViewModel();
    cvm.enableLogging = true;
    int? returnCode = await tester.runAsync(() => cvm.execute("ezo", ["jallo"]));
    log("logMsg:consoleText: {$cvm.consoleText}");
    log("logMsg:returnCode: $returnCode ");
    expect(returnCode != 0, true);
  });
}