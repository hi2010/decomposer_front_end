import 'dart:developer';

import 'package:decomposer_front_end/domain/decomposition/decompositionprofile.dart';
import 'package:decomposer_front_end/models/json_form_adapter.dart';
import 'package:decomposer_front_end/provider/decompositionprofile_provider.dart';
import 'package:decomposer_front_end/views/button_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OptimizationSettingsView extends StatelessWidget {
  OptimizationSettingsView({super.key});


  void _log(String text) {
    log(text, name: "OptimizationSettingsView");
  }

  @override
  Widget build(BuildContext context) {
    _log("accessing providers");
    var decompProviderCaller = Provider.of<DecompositionprofileProvider>(context, listen: false);
    var decompProviderReceiver = Provider.of<DecompositionprofileProvider>(context);

    _log("got providers glob");
    _log("got providers");
    var items = buildItems(decompProviderReceiver.profileNames);
    var itmNms = items.map((e) => e.value);
    if (items.isEmpty) {
      return const Text("component data not yet loaded");
    }
    var currentProfile = decompProviderReceiver.currentProfile;

    if (currentProfile == null) {
      var dbIsInit = decompProviderReceiver.isInit;
      var generalMsg = "current profile is null\nmeaning: either the database connection does not work or loading is not complete\n";
      var textMightBeMissingDll = dbIsInit ? "" : "if you see this you might miss the needed sqlite3.dll for sqflite ffi. See: https://pub.dev/packages/sqflite_common_ffi";
      return Text(generalMsg+"dbConnectionIsInit: $dbIsInit"+textMightBeMissingDll);
    }

    _log("got items: $items $itmNms selection: $currentProfile ${currentProfile.profileName}");

    
    //var formFields = buildFormFields(widget.currentProfile);
    var formAdapter = JsonFormAdapter();
    var formFields = Form(child: KeyValueView(keyWidgets: [],textFormWidgets: [],typeStrings: [],));
    if (decompProviderReceiver.currentProfile != null) {
      formFields = formAdapter.buildFormFields(decompProviderReceiver.currentProfile!.toJson());
    }

    var kvv = formFields.child as KeyValueView;
    // TODO: on save clicked, -> parse the fields to the types and add type checking
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // select profile menu
              Expanded(
                child: DropdownButton<String>(
                  value: currentProfile?.profileName,
                  items: items,
                  onChanged: (newSelection) => decompProviderCaller.selectionChanged(newSelection!),
                ),
              ),
              // TODO: check the from form to data fct
              // the save with same name icon
              // save profile -> if exists ask for overwrite
              IconButton(
                onPressed: () {
                    // then needed to await the result / finish execution before unmounting widget
                    addProfile(context, kvv.toJson(), decompProviderCaller).then((value) => null);
                },
                icon: const Icon(Icons.save_alt),
              ),
              IconButton(
                onPressed: (() {
                  // then needed to await the result / finish execution before unmounting widget
                  deleteProfile(context, kvv.toJson(), decompProviderCaller).then((value) => null);
                }), 
                icon: const Icon(Icons.delete_forever_outlined),
              ),
            ],
          ),
          Expanded(
            child: Form(
              child: formFields,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> addProfile(BuildContext context, Map<String, dynamic> profileJson, DecompositionprofileProvider decompProviderCaller) async {

    log("add profile called");
    if (await decompProviderCaller.hasProfile(profileJson)) {
      log("profile alread exists");
      var overwriteProfile = await createAndShowProfileAlreadyExistsDialog(context);
      if (overwriteProfile) {
        log("profile overwrite called");
        decompProviderCaller.addJsonProfile(profileJson);
      } else {
        return false;
      }
    } else {
      log("profile is new");
      decompProviderCaller.addJsonProfile(profileJson);
    }
    return true;
  }

  Future<bool> createAndShowProfileAlreadyExistsDialog(BuildContext context) async {
    var btnDial = ButtonDialog(dialogOptions: ["yes", "no"], 
                  dialogText: "Profile already exists. Do you want to overwrite it?",);
    var res = await ButtonDialog.showMe(context, btnDial);
    var resStr = res as String;
    if (resStr == "yes") {
      return true;
    }
    return false;
  }

  Future<bool> deleteProfile(BuildContext context, Map<String, dynamic> profileJson, DecompositionprofileProvider decompProviderCaller) async {
    log("delete profile called for ${profileJson['profileName']}");
    var deleteProfile = await createAndShowDeleteProfileDialog(context);
    if (deleteProfile) {
      log("will delete profile ${profileJson['profileName']}");
      decompProviderCaller.deleteJsonProfile(profileJson);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createAndShowDeleteProfileDialog(BuildContext context) async {
    var btnDial = ButtonDialog(dialogOptions: ["yes", "no"], 
                  dialogText: "Do you really want to delete this profile?",);
    var res = await ButtonDialog.showMe(context, btnDial);
    var resStr = res as String;
    if (resStr == "yes") {
      return true;
    }
    return false;
  }

  List<DropdownMenuItem<String>> buildItems(List<String> profileNames) {
    return profileNames.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem(
        value: value,
        child: Text(value),
      );
    }).toList();
  }
}
