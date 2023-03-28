import 'package:flutter/material.dart';
import 'views/main_view.dart';

void main() {
  //runApp(const MyApp());
  runApp(
    MyApp(),
  );
}


class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
      home: MainView(),
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
    );
    }
}