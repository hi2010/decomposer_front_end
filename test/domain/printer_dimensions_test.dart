// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:decomposer_front_end/domain/decomposition/printer_dimensions.dart';
import 'package:vector_math/vector_math.dart';


void main() {
  test("test the to string method", () {
    PrinterDimensions printDims = PrinterDimensions(boundingBox: Vector3(1.1, 2.2, 3.4));
    var js = printDims.toJson();
    print("js is: $js");
    var pd = PrinterDimensions.fromJson(js);
    var vecDiff = pd.boundingBox.relativeError(printDims.boundingBox).abs();
    print("vec diff is: $vecDiff");
    //print("is eq: ");
    //print(js[js.keys.elementAt(1)].runtimeType == double);
    //print(js[js.keys.elementAt(1)] is double);
    //print(js[js.keys.elementAt(1)] is num);
    expect(vecDiff < .1, true);
  });
}
