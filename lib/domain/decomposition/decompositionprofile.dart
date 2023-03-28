import 'package:json_annotation/json_annotation.dart';

import 'optimization_settings.dart';
import 'optimization_weights.dart';
import 'printer_dimensions.dart';
// build: pub run build_runner build
part 'decompositionprofile.g.dart';


class Decompositionprofile {
  // unique key -> in db comp
  String profileName;
  //int id = 0;

  Decompositionprofile({
    required this.profileName,
    required this.printerDims,
  });

  OptimizationSettings optSettings = OptimizationSettings();
  OptimizationWeights optWeights = OptimizationWeights();
  PrinterDimensions printerDims;

  Map<String, dynamic> toJson() {
    //Map<String, dynamic> combinedMap = {"id": id, "profileName": profileName};
    Map<String, dynamic> combinedMap = {"profileName": profileName};
    combinedMap.addAll(optSettings.toJson());
    combinedMap.addAll(optWeights.toJson());
    combinedMap.addAll(printerDims.toJson());
    return combinedMap;
  }

  factory Decompositionprofile.fromJson(Map<String, dynamic> json) {
    var printDims = PrinterDimensions.fromJson(json);
    var decompProf = Decompositionprofile(profileName: json["profileName"].toString(), printerDims: printDims);
    decompProf.optSettings = OptimizationSettings.fromJson(json);
    decompProf.optWeights = OptimizationWeights.fromJson(json);
    return decompProf;
  }

  // creates a cmd str lst from the map adding -- to the key -> [--key, value, --key, value, ...]
  List<String> toCommandStringList() {
    var cmdStrLst = optSettings.toCommandStringList();
    cmdStrLst.addAll(optWeights.toCommandStringList());
    cmdStrLst.addAll(printerDims.toCommandStringList());
    return cmdStrLst;
  }
}

