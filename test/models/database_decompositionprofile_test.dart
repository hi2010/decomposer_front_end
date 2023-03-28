// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:decomposer_front_end/domain/decomposition/decompositionprofile.dart';
import 'package:decomposer_front_end/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vector_math/vector_math.dart';

import 'package:decomposer_front_end/domain/decomposition/printer_dimensions.dart';
import 'package:decomposer_front_end/domain/decomposition/optimization_settings.dart';

import 'package:decomposer_front_end/models/database_decompositionprofile.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  late Database database;
  late DatabaseDecompositionprofile dbDecomp;
  // Setup sqflite_common_ffi for flutter test
  setUpAll(() {
    return Future(() async {
      var dbC =  await DatabaseDecompositionprofile.create();
      dbDecomp = dbC;
      database = dbDecomp.database;
    });
  });
  testWidgets("test the type string gen", (WidgetTester tester) async {
    // this won't be tested except by vision because writing a test would make the automatic table creation useless -> more work
    print("creationString: ${dbDecomp.getCreationString()}");
    print("db path: $database.path");
    expect(database.isOpen, true);
  });
  testWidgets("test insert data", (WidgetTester tester) async {
    // this won't be tested except by vision because writing a test would make the automatic table creation useless -> more work
    var printDims = PrinterDimensions(boundingBox: Vector3(100,110,100));
    var decompEntr = Decompositionprofile(profileName: "prof0", printerDims: printDims);
    var res = await tester.runAsync(() async {
      return await dbDecomp.updateProfile(decompEntr);
    });
    //var res = await dbDecomp.updateProfile(decompEntr);
    print("res: $res");
  });
  testWidgets("testGetProfiles", (WidgetTester tester) async {
    await tester.runAsync(() async {
      var profilesLst = await dbDecomp.getAllProfiles();
      for (var i = 0; i < profilesLst.length; i++) {
        print("profile name: ${profilesLst[i].profileName}");
      }
      var oneProfile = await dbDecomp.getProfileByName("prof0");
      print("get one profile by name: prof0 result: ${oneProfile} ${oneProfile!.profileName}");
      expect(oneProfile != null, true);
      expect(profilesLst.length > 0, true);
    });
  });
  testWidgets("test delete profile", (WidgetTester tester) async{
    await tester.runAsync(() async {
      dbDecomp.deleteProfileByName("prof0");
      var oneProfile = await dbDecomp.getProfileByName("prof0");
      print("get one profile by name after delete: prof0 result: ${oneProfile}");
      expect(oneProfile, null);
    });
  });

  testWidgets("test uri", (WidgetTester tester) async {
    var dir = Directory("D:\Programme\flutterApp0\my_app\images");
    print(dir.path);
    print(dir.absolute);
  });

  tearDownAll((){
    database.close();
  }); 
}
