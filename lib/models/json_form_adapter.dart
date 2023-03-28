import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// What to do:
/// json (map<String, dynamic>) to flutter form fields -> type checker and key
/// flutter form to json
/// 
/// therefore: check type of dynamic

class KeyValueView extends StatelessWidget{
  List<Text> keyWidgets;
  List<TextFormField> textFormWidgets;
  List<String> typeStrings;


  KeyValueView({super.key, required this.keyWidgets, required this.textFormWidgets, required this.typeStrings}) {
    assert(keyWidgets.length == textFormWidgets.length);
    assert(keyWidgets.length == typeStrings.length);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> childs = [];
    for (var i = 0; i < textFormWidgets.length; i++) {
      childs.add(keyWidgets[i]);
      childs.add(textFormWidgets[i]);
    }
    
    return ListView(children: childs,);
  }

  dynamic parseType(String typeString, String textVal) {
    dynamic typedValue;
    if (typeString == "int") {
      // int inpType
      typedValue = int.parse(textVal);
    } else if (typeString == "double") {
      // double inpType -> allows 1.2, 1, 1e-2, 1e2
      //inpType = FilteringTextInputinpType(RegExp(r"\d+\.{0,1}\d*e{0,1}-{0,1}\d*"), allow: true);
      typedValue = double.parse(textVal);
    } else if (typeString is String) {
      // string inpType
      typedValue = textVal;
    } else if (typeString == "bool") {
      // string inpType
      typedValue = (textVal.toLowerCase() == "true" || textVal == "1");
    } else {
      typedValue = textVal;
    }
    return typedValue;
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> formJson = {};
    for (var i = 0; i < keyWidgets.length; i++) {
      var keyVal = keyWidgets[i].data;
      var textVal = textFormWidgets[i].controller!.text.toString();
      var typeStr = typeStrings[i];
      var typedVal = parseType(typeStr, textVal);
      formJson.update(keyVal!, (value) => typedVal, ifAbsent: () => typedVal);
    }
    return formJson;
  }

}

class JsonFormAdapter {
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

  TextInputFormatter getFormatterForValue(dynamic value) {
    TextInputFormatter formatter;
    if (value is int) {
      // int formatter
      formatter = FilteringTextInputFormatter.digitsOnly;
    } else if (value is double) {
      // double formatter -> allows 1.2, 1, 1e-2, 1e2
      formatter = FilteringTextInputFormatter(RegExp(r"\d+\.{0,1}\d*(e-{0,1}\d*){0,1}"), allow: true);
    } else if (value is String) {
      // string formatter
      formatter = FilteringTextInputFormatter.deny("");
    } else if (value is bool) {
      // string formatter
      formatter = FilteringTextInputFormatter.allow("(true|false|1|0)");
    } else {
      formatter = FilteringTextInputFormatter.deny("");
    }
    return formatter;
  }

  TextInputType getTextInputTypeForValue(dynamic value) {
    TextInputType inpType;
    if (value is int) {
      // int inpType
      inpType = TextInputType.number;
    } else if (value is double) {
      // double inpType -> allows 1.2, 1, 1e-2, 1e2
      //inpType = FilteringTextInputinpType(RegExp(r"\d+\.{0,1}\d*e{0,1}-{0,1}\d*"), allow: true);
      inpType = const TextInputType.numberWithOptions(signed: true, decimal: true);
    } else if (value is String) {
      // string inpType
      inpType = TextInputType.text;
    } else if (value is bool) {
      // string inpType
      inpType = TextInputType.number;
    } else {
      inpType = TextInputType.text;
    }
    return inpType;
  }

  String getTypeString(dynamic value) {
    String typeString;
    if (value is int) {
      // int inpType
      typeString = "int";
    } else if (value is double) {
      // double inpType -> allows 1.2, 1, 1e-2, 1e2
      //inpType = FilteringTextInputinpType(RegExp(r"\d+\.{0,1}\d*e{0,1}-{0,1}\d*"), allow: true);
      typeString = "double";
    } else if (value is String) {
      // string inpType
      typeString = "String";
    } else if (value is bool) {
      // string inpType
      typeString = "bool";
    } else {
      typeString = "String";
    }
    return typeString;
  }

  Form buildFormFields(Map<String, dynamic> json) {
    var fieldMap = json;
    List<Widget> colItms = [];
    var keyIter = fieldMap.keys.iterator;
    List<Text> keyItms = [];
    List<TextFormField> valueItms = [];
    List<String> typeStrings = [];
    while (keyIter.moveNext()) {
      var curKey = keyIter.current;
      var curVal = fieldMap[curKey];
      //colItms.add(
      var keyTxt = Text(curKey,);
      //colItms.add(
      var valueController = TextEditingController ();
      valueController.text = curVal.toString();
      var valueFrmFld = TextFormField(
        //initialValue: curVal.toString(), 
        decoration: InputDecoration(hintText: curKey),
        keyboardType: getTextInputTypeForValue(curVal),
        inputFormatters: <TextInputFormatter>[getFormatterForValue(curVal)],
        controller: valueController,
      //  ),
      );
      keyItms.add(keyTxt);
      valueItms.add(valueFrmFld);
      typeStrings.add(getTypeString(curVal));
    }
    return Form(child: KeyValueView(keyWidgets: keyItms, textFormWidgets: valueItms,typeStrings: typeStrings));
  }

  /*Map<String, dynamic> listToJson(List<KeyValueFormField> lst) {
    Map<String, dynamic> json = {};
    for (var i = 0; i < lst.length; i++) {
      var kvff = lst[i];
      var keyVal = kvff.keyValue;
      var val = kvff.value;
      if (keyVal == null || val == null) continue;
      print("$keyVal $val");
      json.putIfAbsent(keyVal, () => val);
    }
    return json;
  }*/
}