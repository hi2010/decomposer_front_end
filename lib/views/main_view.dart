import 'dart:developer';
import 'dart:io';

import 'package:decomposer_front_end/console_widget_mvvm/console_view_mvvm.dart';
import 'package:decomposer_front_end/domain/decomposition/decompositionprofile.dart';
import 'package:decomposer_front_end/domain/decomposition/printer_dimensions.dart';
import 'package:decomposer_front_end/models/database_decompositionprofile.dart';
import 'package:decomposer_front_end/models/decomposition_jobsystem.dart';
import 'package:decomposer_front_end/provider/applicationsettings_provider.dart';
import 'package:decomposer_front_end/provider/decompositionjob_provider.dart';
import 'package:decomposer_front_end/provider/decompositionprofile_provider.dart';
import 'package:decomposer_front_end/views/applicationsettings_view.dart';
import 'package:decomposer_front_end/views/optimization_settings_view.dart';
import 'package:flutter/material.dart';
import 'package:decomposer_front_end/views/overview.dart';
import 'package:decomposer_front_end/views/console_view.dart';
import 'package:decomposer_front_end/console_widget_mvvm/console_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math.dart' as vectorMath;

import '../domain/application/constants.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  @override
  Widget build(BuildContext context) {
    var cvmInst = ConsoleViewModel();
    var decompDb = DatabaseDecompositionprofile.create();

    var decompProvider = DecompositionprofileProvider();

    var decompJobSys = DecompositionJobsystem();
    var prefsFuture = SharedPreferences.getInstance();
    prefsFuture.then((prefs) => decompJobSys.executablePath =
        File(prefs.getString(PATH_DECOMPOSITION_EXEC)!));
    var jobProvider = DecompositionjobProvider(jobsystem: decompJobSys);

    decompJobSys.onAnyMsgCallback = cvmInst.appendConsoleTextNotify;
    decompJobSys.assignProcessrunnerCallbacksToThis();

    var appSettingsProvider = ApplicationsettingsProvider();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: [
              Tab(text: "Overview"),
              Tab(text: "Opt. settings"),
              Tab(text: "Path settings"),
              Tab(text: "Imp. settings"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            TopContent(
              child: ChangeNotifierProvider<DecompositionjobProvider>.value(
                value: jobProvider,
                builder: (context, child) {
                  return Overview();
                },
              ),
            ),

            TopContent(
              child: ChangeNotifierProvider<DecompositionprofileProvider>.value(
                value: decompProvider,
                builder: (context, child) {
                  return OptimizationSettingsView();
                },
              ),
            ),

            //OptimizationSettingsView(profileNames: ["1", "2"]),
            TopContent(
              child: ChangeNotifierProvider<ApplicationsettingsProvider>.value(
                value: appSettingsProvider,
                builder: (context, child) {
                  return ApplicationsettingsView();
                },
              ),
            ),
            Text("Tabpage3"),
          ],
        ),
        // the console
        //bottomSheet: cv,
        bottomSheet: FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: .3,
          child: ChangeNotifierProvider<ConsoleViewModel>.value(
            value: cvmInst,
            builder: (context, child) {
              log("rebuild");
              return ConsoleViewMVVM(
                consoleText: Provider.of<ConsoleViewModel>(context).consoleText,
              );
            },
          ),
        ),
      ),
    );
  }
}

class TopContent extends StatelessWidget {
  Widget child;
  TopContent({required this.child});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: .68,
      alignment: Alignment.topCenter,
      child: child,
    );
  }
}

class Some extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var listener = Provider.of<ConsoleViewModel>(context);
    return Text(listener.consoleText.toString());
  }
}

// composition is easier than copying the whil constructor args and passing them ...
class TabButton extends StatefulWidget {
  TabButton({super.key, required this.textCont}) : orgTextCont = textCont;

  String textCont;
  String orgTextCont;
  bool _active = false;

  void beforeChangeCallback() {
    //textCont = orgTextCont + (_active ? "active" : "inactive");
  }

  @override
  State<StatefulWidget> createState() => _TabButtonState();
}

typedef SomeFunc = void Function();

class _TabButtonState extends State<TabButton> {
  void onPressed() {
    widget.beforeChangeCallback();
    setState(() {
      widget._active = !widget._active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            if (widget._active) {
              return Colors.green;
            }
            return Colors.yellow;
          }
          if (widget._active) {
            return Colors.green;
          }
          return Colors.orange;
        }),
        textStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return TextStyle(color: Colors.blue);
          }
          if (widget._active) {
            return TextStyle(color: const Color(0xff000000));
          }
          return TextStyle(color: Colors.red);
        }),
        /*_active
                ? const MaterialStateProperty.
                ? const Color(0xffff0500)
                : const Color(0xff00A221),*/
      ),
      child: Text(
        widget.textCont,
        style: widget._active
            ? TextStyle(color: const Color(0xff000000))
            : TextStyle(color: Colors.blue),
      ),
    );
  }
}
