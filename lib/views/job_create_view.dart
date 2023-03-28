import 'dart:developer';
import 'dart:io';

import 'package:decomposer_front_end/domain/application/decompositionjob.dart';
import 'package:decomposer_front_end/domain/decomposition/decompositionprofile.dart';
import 'package:decomposer_front_end/provider/decompositionjob_provider.dart';
import 'package:decomposer_front_end/provider/jobcreate_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobCreateView extends StatelessWidget {
  JobcreateProvider jobcreateProvider;

  JobCreateView({super.key}) : jobcreateProvider = JobcreateProvider();

  String getNameFromJobprovider() {
    var fileName = "";
    if (jobcreateProvider.selectedFile != null) {
      fileName = jobcreateProvider.selectedFile!.path;
    }
    return fileName;
  }

  @override
  Widget build(BuildContext context) {
    var decompositionProfileItems = createDecompositionpofileItems();
    var createJob = () {
      var jobObj = jobcreateProvider.getJobObj();
      Navigator.pop(context, jobObj);
    };
    var cancelJobCreation = () => Navigator.pop(context, null);

    var cont = Container(
      child: Text("sdf"),
    );

    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: ChangeNotifierProvider<JobcreateProvider>.value(
            value: jobcreateProvider,
            builder: (context, child) {
              log("rebuilding");
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // select file button
                  TextButton(
                    child: Text("Select file"),
                    onPressed: Provider.of<JobcreateProvider>(context).selectFile,
                  ),
                  // display file name
                  Row(
                    children: [
                      const Text("selected file: "),
                      Text(getNameFromJobprovider()),
                    ],
                  ),
                  // select the decomposition profile
                  Row(
                    children: [
                      const Text("Decomposition profile:"),
                      DropdownButton(
                          items: createDecompositionpofileItems(), onChanged: (profileName) => jobcreateProvider.selectDecompositionprofile(profileName),
                          value: jobcreateProvider.selectedProfile,
                          ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      TextButton(
                        child: const Text("Create job"),
                        onPressed: jobcreateProvider.canCreateJob() ? createJob : null,
                      ),
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: cancelJobCreation,
                      ),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }

  List<DropdownMenuItem<String>> createDecompositionpofileItems() {
    List<DropdownMenuItem<String>> items = jobcreateProvider.availableProfiles.map((e) => DropdownMenuItem(value: e.profileName,child: Text(e.profileName),)).toList();
    return items;
  }

}
