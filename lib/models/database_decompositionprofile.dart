import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:decomposer_front_end/domain/decomposition/decompositionprofile.dart';
import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math.dart';

import '../domain/decomposition/printer_dimensions.dart';

class DatabaseDecompositionprofile {
  late Database database;
  static const dbName = "decomposition_profiles.db";
  static const tableName = "decompositionprofiles";
  static const uuid = Uuid();

  DatabaseDecompositionprofile._create();

  Future<void> dispose() async {
    await database.close();
    return;
  }

  static Future<DatabaseDecompositionprofile> create() async {
    // in theory the if is not needed as this is only a desktop app
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      // Initialize FFI
      sqfliteFfiInit();
      // Change the default factory for unit testing calls for SQFlite
      databaseFactory = databaseFactoryFfi;
    }
    var component = DatabaseDecompositionprofile._create();
    WidgetsFlutterBinding.ensureInitialized();

    var db = await component._openDb();
    component.database = db;
    assert(db.isOpen);
    return component;
  }

  Future<Database> _openDb() async {
    return openDatabase(
      join(await getDatabasesPath(), dbName),
      onCreate: ((db, version) {
        db.execute(getCreationString());
      }), /* on create */
      version: 1,
    );
  }

  String getCreationString() {
    var decompProfTypeJson = Decompositionprofile(profileName: "", printerDims: PrinterDimensions(boundingBox: Vector3(0,0,0))).toJson();
    return "CREATE TABLE $tableName(${DatabaseDecompositionprofile.jsonToSqlTypeString(decompProfTypeJson)})";
  } 

  static List<String> createTypeListFromJson(Map<String, dynamic> json) {
    List<String> typeList = [];
    String typeStr = "";
    json.forEach((key, value) {
      if (value is num) {
        typeStr = (value is int) ? "INTEGER" : "DOUBLE(64, 52)";
      } else if (value is String) {
        // for long texts replace this
        typeStr = "TEXT";
      } else if (value is bool) {
        typeStr = "BOOL";
      } else {
        // binary blob for all other types
        typeStr = "BLOB";
      }
      typeList.add(typeStr);
    });
    return typeList;
  }

  static String createKeyTypeListFromJson(Map<String, dynamic> json) {
    var resStr = "";
    var typeLst = createTypeListFromJson(json);
    int i = 0;
    json.forEach((key, value) {
      resStr = "$resStr$key ${typeLst[i]}, ";
      i = i +1;
    });
    // remove trailing ","
    return resStr.substring(0, resStr.length-2);
  }

  static String combineListsToCskv(List<String> keyNames, List<String> keyTypes) {
    if (keyNames.length != keyTypes.length) {
      throw FormatException("combineListsToCskv lists need to be of the same length not diff. keyNames len: ${keyNames.length} , keyTypes len: ${keyTypes.length}");
    }
    var resStr = "";
    for (int i = 0; i < keyNames.length; i++) {
      resStr = "$resStr${keyNames[i]} ${keyTypes[i]}, ";
    }
    return resStr.substring(0, resStr.length - 2);
  }

  static String jsonToSqlTypeString(Map<String, dynamic> json) {
    var typesList = DatabaseDecompositionprofile.createTypeListFromJson(json);
    // id -> now name
    typesList[0] = "${typesList[0]} PRIMARY KEY";
    // name
    //typesList[1] = "${typesList[1]} UNIQUE";
    return DatabaseDecompositionprofile.combineListsToCskv(json.keys.toList(), typesList);
  }

  Future<List<Decompositionprofile>> getAllProfiles() async{
    List<Map<String, dynamic>> profilesMap = await database.query(tableName);
    List<Decompositionprofile> lstOfProfiles = [];
    var profilesIter = profilesMap.iterator;
    // iter starts "one before" the first element so this is valid
    while (profilesIter.moveNext()) {
      lstOfProfiles.add(Decompositionprofile.fromJson(profilesIter.current));
    }
    if (lstOfProfiles.isEmpty) {
      // make this fct return after the profile got created
      await createDefaultProfile();
    }
    return lstOfProfiles;
  }

  Future<Decompositionprofile?> getProfileByName(String name) async {
    List<Map<String, dynamic>> res = await database.query(tableName, where: "profileName=?", whereArgs: [name]);
    if (res.isEmpty) {
      return null;
    }
    return Decompositionprofile.fromJson(res[0]);
  }

  // create if non existant
  Future<int> updateProfile(Decompositionprofile decompProf) async {
    //var dbEntry = await getDecompositionProfileByName(decompProf.profileName);
    print("trying update profile in db");
    return database.insert(tableName, decompProf.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void deleteProfileByName(String name) {
    database.delete(tableName, where: "profileName=?", whereArgs: ["$name"]);
  }

  Future<List<String>> getAllProfileNames() async {
    var res = await database.query(tableName, columns: ["profileName"]);
    List<String> resLst = [];
    for (var i = 0; i < res.length; i++) {
      resLst.add(res[i]["profileName"].toString());
    }
    return resLst;
  }

  // there should always be at least one profile so the user has a formular from which to create its own custom ones
  // returns the update profile status int
  Future<int> createDefaultProfile() async {
    var defaultProfile = Decompositionprofile(profileName: "default", printerDims: PrinterDimensions(boundingBox: Vector3(100, 100, 100)));
    var createStatus = updateProfile(defaultProfile);
    return createStatus;
  }
}