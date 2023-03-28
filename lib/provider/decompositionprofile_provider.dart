import 'dart:convert';
import 'dart:developer';

import 'package:decomposer_front_end/domain/decomposition/decompositionprofile.dart';
import 'package:decomposer_front_end/domain/decomposition/printer_dimensions.dart';
import 'package:decomposer_front_end/models/database_decompositionprofile.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart';

class DecompositionprofileProvider extends ChangeNotifier {

  // for debug
  bool isAlive = true;

  void _log(String text) {
    log(text, name: "DecompositionprofileProvider");
  }
  
  late DatabaseDecompositionprofile dbDecomppro;
  Future<DatabaseDecompositionprofile> dbCreator;

  String selection = "";
  late List<String> profileNames;
  late Decompositionprofile currentProfile;

  DecompositionprofileProvider() : dbCreator = DatabaseDecompositionprofile.create() {
    dbCreator.then(_initVars);
  }

  @override
  void dispose() async {
    _log("dispose called");
    isAlive = false;
    // TODO: implement dispose
    await dbDecomppro.dispose();
    super.dispose();
  }

  void _initVars(DatabaseDecompositionprofile dbp) async {
    dbDecomppro = dbp;
    await dbp.getAllProfiles();
    profileNames = await dbp.getAllProfileNames();
    selection = profileNames[0];
    currentProfile = await getCurrentDecompositionProfile();
    // is init
    notifyListeners();
  }

  Future<List<String>> reloadProfileNames() async {
    profileNames = await dbDecomppro.getAllProfileNames();
    // check that profile still exists:
    if (! profileNames.contains(selection) ) {
      selection = profileNames[0];
      await getCurrentDecompositionProfile();
    }
    return profileNames;
  }

  Future<bool> reloadProfileNamesAndCurrent() async {
    profileNames = await reloadProfileNames();
    await getCurrentDecompositionProfile();
    return true;
  }

  void selectionChanged(String newSelection) async {
    _log("new selec");
    if (newSelection == selection) {
      return;
    }
    selection = newSelection;
    _log("new selection: $selection");
    await getCurrentDecompositionProfile();
    _log("updated profile to: ${currentProfile.toJson()}");
    notifyListeners();
  }

  Future<Decompositionprofile> getCurrentDecompositionProfile() async {
    var curDecompprof = await dbDecomppro.getProfileByName(selection);
    currentProfile = curDecompprof!;
    return currentProfile;
  }

  // only checks by name
  Future<bool> hasProfile(Map<String, dynamic> profileJson) async {
    var res = await dbDecomppro.getProfileByName(profileJson["profileName"]);
    return res != null;
  }

  void addJsonProfile(Map<String, dynamic> profileJson) async {
    _log("user wants to add profile: ${profileJson["profileName"]} with: $profileJson");
    var hasProfile = await dbDecomppro.getProfileByName(profileJson["profileName"]);
    if (hasProfile != null) {
      _log("profile already exists!");
      //return;
    }
    var decompPro = Decompositionprofile.fromJson(profileJson);
    await dbDecomppro.updateProfile(decompPro);
    selection = profileJson["profileName"];
    await reloadProfileNamesAndCurrent();
    notifyListeners();
  }

  void deleteJsonProfile(Map<String, dynamic> profileJson) async {
    dbDecomppro.deleteProfileByName(profileJson["profileName"]);
    await reloadProfileNamesAndCurrent();
    notifyListeners();
  }
}