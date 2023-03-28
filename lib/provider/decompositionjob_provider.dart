import 'dart:collection';
import 'dart:io';

import 'package:decomposer_front_end/domain/application/decompositionjob.dart';
import 'package:decomposer_front_end/models/decomposition_jobsystem.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DecompositionjobProvider extends ChangeNotifier {
  DecompositionJobsystem jobsystem;
  File? selectedFile;

  DecompositionjobProvider({required this.jobsystem}) {
    this.jobsystem.onJobCompletion = (job) => notifyListeners();
  }

  Future<dynamic?> selectFile() async {
    // TODO: make types dynamic
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result == null) {
      return null;
    }
    result.files.single.path;
    File file = File(result.files.single.path!);
    selectedFile = file;
    notifyListeners();
    return result;
  }

  void createJob(Decompositionjob job) {
    jobsystem.addJob(job);
    jobsystem.run();
    notifyListeners();
  }

  ListQueue<Decompositionjob> get openJobs {
    return jobsystem.openJobs;
  }
  List<Decompositionjob> get completedJobs {
    return jobsystem.completedJobs;
  }
}