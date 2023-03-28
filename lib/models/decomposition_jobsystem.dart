import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:decomposer_front_end/domain/application/decompositionjob.dart';
import 'package:decomposer_front_end/models/processrunner.dart';

class DecompositionJobsystem {
  void _log(String msg) {
    log(msg, name: "DecompositionJobsystem");
  }

  // for process runner status updates
  void Function(String) onMsgCallback = (p0) => 0;
  void Function(String) onErrCallback = (p0) => 0;
  void Function(String) onAnyMsgCallback = (p0) => 0;
  void Function(Decompositionjob) onJobCompletion = (p0) => 0;

  // fifo
  final openJobs = ListQueue<Decompositionjob>();
  final List<Decompositionjob> completedJobs = [];
  bool jobIsRunning = false;
  final Processrunner procrunner = Processrunner();
  File? executablePath;

  void addJob(Decompositionjob job) {
    openJobs.add(job);
  }

  bool removeJob(Decompositionjob job) {
    var isRemoved = openJobs.remove(job);
    if (isRemoved == false) {
      isRemoved = completedJobs.remove(job);
    }
    return isRemoved;
  }

  void assignProcessrunnerCallbacksToThis() {
    procrunner.onMsgCallback = onMsgCallback;
    procrunner.onErrCallback = onErrCallback;
    procrunner.onAnyMsgCallback = onAnyMsgCallback;
  }

  // may return status: success, failure, stuck, ...
  Future<int> processJob(Decompositionjob job) async {
    if (executablePath == null) {
      _log("no exec path");
      return -1;
    };
    var execPath = executablePath!;
    if (execPath.existsSync() == false) {
      _log("executable does not exist (${execPath})");
      return -2;
    };
    var jobArgs = job.decompProfile.toCommandStringList();
    jobArgs.add(job.originFile.absolute.path);
    jobArgs.add(job.targetPath.absolute.path + job.targetStemName);
    _log("will exec proc using: exec: ${execPath.absolute.path} args: $jobArgs");
    var jobResultCode = procrunner.execute(execPath.absolute.path, jobArgs);
    jobResultCode.then((value) => job.status = value);
    return jobResultCode;
  }

  /// not sure yet but the idea is to just start the processing of jobs and then process as long as there are jobs
  Future<int> run() async {
    if (openJobs.isEmpty) return Future(() => -1);
    if (jobIsRunning) {
      _log("run called but is already running");
      return 0;
    }
    jobIsRunning = true;
    while(!openJobs.isEmpty) {
      var nextJob = openJobs.first;
      _log("will process job: $nextJob");
      var res = await processJob(nextJob);
      completedJobs.add(openJobs.removeFirst());
      onJobCompletion(completedJobs.last);
    }
    jobIsRunning = false;
    return Future(() => 1);
  }

}