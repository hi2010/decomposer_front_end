import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/application/constants.dart';

class ApplicationsettingsProvider extends ChangeNotifier {
  bool isInit = false;
  late SharedPreferences prefs;
  String? decompositionExecPath;

  ApplicationsettingsProvider() {
    _initVars();
  }

  void _initVars() async {
    prefs = await SharedPreferences.getInstance();
    decompositionExecPath = prefs.getString(PATH_DECOMPOSITION_EXEC);
    isInit = true;
    notifyListeners();
  }

  void selectDecompositionExecPath() async {
    // open file chooser
    // ...
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return null;
    }
    if (result.files[0].extension != "bat") {
      log("not a script");
    }

    decompositionExecPath = result.files[0].path.toString();
    prefs.setString(PATH_DECOMPOSITION_EXEC, decompositionExecPath!);
    // obtain shared preferences

    // set value
    //await prefs.setInt('counter', counter);
    // Try reading data from the counter key. If it doesn't exist, return 0.
    //final counter = prefs.getInt('counter') ?? 0;
    notifyListeners();
  }
  
}