import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ButtonDialog extends StatelessWidget {
  List<String> dialogOptions;
  String dialogText;

  ButtonDialog(
      {super.key,
      required this.dialogOptions,
      required this.dialogText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(dialogText),
      actions: createButtons(context),
    );
  }

  List<TextButton> createButtons(BuildContext context) {
    List<TextButton> btnLst = dialogOptions
        .map((e) =>
            TextButton(onPressed: () => btnAction(context, e), child: Text(e)))
        .toList();
    return btnLst;
  }

  void btnAction(BuildContext context, String btnValue) {
    Navigator.of(context).pop(btnValue);
  }

  static Future<dynamic> showMe(BuildContext context, ButtonDialog theMsg) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return theMsg;
      },
    );
  }
}
