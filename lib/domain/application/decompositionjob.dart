import 'dart:io';

import 'package:decomposer_front_end/domain/decomposition/decompositionprofile.dart';
import 'package:uuid/uuid.dart';

class Decompositionjob {
  String uuid = const Uuid().v1();
  Decompositionprofile decompProfile;
  File originFile;
  Directory? _targetPath;
  // the result is multiple files. These files have a stem name and a result specific appendence:
  // e.g: myStem_ -> myStem_orires.3mf
  String targetStemName = "";
  DateTime creationDate = DateTime.now();
  int status = 0;

  Decompositionjob({required this.decompProfile, required this.originFile, targetPat}) {
    // setter with eval
    targetPath = targetPat;
  }

  // this way so one could also null check
  Directory get targetPath {
    if (_targetPath != null) {
      return _targetPath!;
    }
    var fullFileName = originFile.uri.pathSegments.last;
    var dotPos = fullFileName.lastIndexOf(".");
    var fileName = fullFileName.substring(0, dotPos);
    //var fileExt = fullFileName.substring(dotPos+1);
    var pathSegs = originFile.uri.pathSegments;
    var targetPatStr = "";
    for (int i = 0; i < pathSegs.length - 1; i++) {
      targetPatStr += pathSegs[i] + "/";
    }
    targetPatStr += fileName + "/";
    _targetPath = Directory(originFile.path);

    return _targetPath!;
  }

  set targetPath(Directory pat) {
    // checks exists and if right type
    if (! pat.existsSync()) {
      throw new FormatException("decomposition job set path got invalid directory: ${pat.absolute}");
    }
    _targetPath = pat;
  }
}