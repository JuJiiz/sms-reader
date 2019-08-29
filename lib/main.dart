import 'package:flutter/material.dart';
import 'package:sms_reader/src/ui/home_ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeUI(title: 'Home'),
    );
  }
}
