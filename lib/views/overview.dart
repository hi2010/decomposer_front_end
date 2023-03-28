import 'package:decomposer_front_end/provider/decompositionjob_provider.dart';
import 'package:decomposer_front_end/views/job_create_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _btnStyle = ButtonStyle(
  //backgroundColor: MaterialStatePropertyAll(Colors.lime[400]),
  backgroundColor: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.pressed)) {
      return Colors.lime;
    }
    return Colors.amber;
  }),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      side: BorderSide(
        color: Colors.amber,
        width: 2,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.circular(30),
    ),
  ),
);

final _btnTxtStyle = TextStyle(
  color: Colors.blue[900],
);

// not shure where to handle the state of this window
class Overview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FileView(),
      ],
    );
  }
}

class FileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () => openCreateJobView(context),
                child: Text(
                  "Add file",
                  style: _btnTxtStyle,
                ),
                style: _btnStyle,
              ),
              SizedBox(width: 10),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    "Remove file",
                    style: _btnTxtStyle,
                  ),
                  style: _btnStyle),
            ],
          ),
          JobView(),
        ],
      ),
    );
  }

  void openCreateJobView(BuildContext context) async {
    //var jobProvider = Provider.of<DecompositionjobProvider>(context, listen: false);
    // this system uses value to insert the provider -> the object does not change
    var jobProvider = Provider.of<DecompositionjobProvider>(context, listen: false);
    var jobResult = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => JobCreateView()));
      if (jobResult == null) {
        return;
      }
      jobProvider.createJob(jobResult);
  }
}

class JobView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var jobProvider = Provider.of<DecompositionjobProvider>(context);
    var openJobQueue = jobProvider.openJobs;
    var jobEntries = openJobQueue.map((job) => DataRow(cells: <DataCell>[
        DataCell(Text(job.status.toString())),
        DataCell(Text(job.decompProfile.profileName)),
        DataCell(Text(job.originFile.toString())),
      ])).toList();
      var completedJobs = jobProvider.completedJobs;
    var completedJobEntries = completedJobs.map((job) => DataRow(cells: <DataCell>[
        DataCell(Text(job.status.toString())),
        DataCell(Text(job.decompProfile.profileName)),
        DataCell(Text(job.originFile.toString())),
      ])).toList();
      jobEntries.addAll(completedJobEntries);
    return DataTable(columns: const <DataColumn>[
      DataColumn(
        label: Expanded(
          child: Text("Status"),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text("Profile"),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text("File"),
        ),
      ),
    ], rows: jobEntries,
    );
  }
}
