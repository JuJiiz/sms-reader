import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_reader/src/background_main.dart';
import 'package:sms_reader/src/ui/home_ui.dart';
import 'package:sms_reader/src/ui/widget/app_retain_widget.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(MyApp());

  var channel = const MethodChannel('com.hengjung/background_service');
  var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
  channel.invokeMethod('startService', callbackHandle.toRawHandle());

  //CounterService().startCounting();
  Wakelock.enable();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gamemun',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppRetainWidget(
        child: HomeUI(title: 'Gamemun SMS'),
      ),
    );
  }
}
