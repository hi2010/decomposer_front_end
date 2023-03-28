import 'package:decomposer_front_end/provider/applicationsettings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplicationsettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<ApplicationsettingsProvider>(context);
    var decompositionExecPath = settingsProvider.decompositionExecPath;

    return Column(
      children: [
        Row(
          children: [
            const Text("Decomposition path:"),
            IconButton(
              onPressed: () => settingsProvider.selectDecompositionExecPath(), 
              icon: Icon(Icons.arrow_forward_ios)),
            Text(decompositionExecPath.toString()),
          ],
        )
      ],
    );
  }

}