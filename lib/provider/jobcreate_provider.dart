import 'dart:developer';
import 'dart:io';

import 'package:decomposer_front_end/domain/decomposition/decompositionprofile.dart';
import 'package:decomposer_front_end/models/database_decompositionprofile.dart';
import 'package:decomposer_front_end/models/decomposition_jobsystem.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../domain/application/decompositionjob.dart';

class JobcreateProvider extends ChangeNotifier {
  File? selectedFile;
  Decompositionprofile? decompProfile;
  late DatabaseDecompositionprofile dbDecomp;
  List<Decompositionprofile> availableProfiles = [];

  JobcreateProvider(){
    DatabaseDecompositionprofile.create().then((_dbDecomp) {
      dbDecomp = _dbDecomp;
      _initVars();
      }
    );
  }

  void _initVars() async {
    availableProfiles = await dbDecomp.getAllProfiles();
    notifyListeners();
  }

  String? get selectedProfile {
    if (decompProfile == null) {
      return null;
    }
    return decompProfile!.profileName;
  }

  Future<dynamic?> selectFile() async {
    // TODO: make types dynamic
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return null;
    }
    result.files.single.path;
    File file = File(result.files.single.path!);
    selectedFile = file;
    notifyListeners();
    return result;
  }

  void selectDecompositionprofile(String? profileName) {
    if (profileName == null) {
      return;
    }
    decompProfile = availableProfiles.firstWhere((profile) => profile.profileName == profileName,);
    notifyListeners();
  }

  bool canCreateJob() {
    return decompProfile != null && selectedFile != null;
  }

  Decompositionjob? getJobObj() {
    if (decompProfile == null || selectedFile == null) {
      return null;
    }
    // TODO: change the path:
    var targetPath = selectedFile!.parent.absolute;
    var decoJ = Decompositionjob(
        decompProfile: decompProfile!, originFile: selectedFile!, targetPat: targetPath);
    return decoJ;
  }
}
