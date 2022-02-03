import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';
import 'package:sms_reader/src/bloc/home_bloc.dart';
import 'package:sms_reader/src/ui/phone_name_dialog.dart';
import 'package:sms_reader/src/ui/widget/sms_list.dart';
import 'package:sms_reader/src/data/sms_provider.dart';
import 'package:http/http.dart' as http;

class HomeUI extends StatefulWidget {
  HomeUI({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _bloc = new HomeBloc();

  @override
  void initState() {
    super.initState();

    _checkPhoneName();
  }

  _checkPhoneName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var phoneName = prefs.getString('PHONE_NAME_PREF_KEY');
    if (phoneName == null) {
      _showPhoneNameDialog(false, (name) async {
        await prefs.setString('PHONE_NAME_PREF_KEY', name);
        _bloc.getAllSMS();
        _bloc.retrieveAllSMS();
      });
    } else {
      _bloc.getAllSMS();
      _bloc.retrieveAllSMS();
    }
  }

  _setPhoneName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var phoneName = prefs.getString('PHONE_NAME_PREF_KEY');

    _showPhoneNameDialog(true,
        (name) async => await prefs.setString('PHONE_NAME_PREF_KEY', name),
        currentPhoneName: phoneName);
  }

  _showPhoneNameDialog(bool cancelable, Function(String) action,
      {String currentPhoneName}) async {
    showDialog(
      context: _scaffoldKey.currentContext,
      barrierDismissible: cancelable,
      builder: (context) => cancelable
          ? PhoneNameDialog(
              onSavePhoneName: action,
              currentPhoneName: currentPhoneName,
            )
          : WillPopScope(
              onWillPop: () => Future.value(false),
              child: PhoneNameDialog(
                onSavePhoneName: action,
                currentPhoneName: currentPhoneName,
              ),
            ),
    );
  }

  _reSendAllUnReadSms() async {
    final smsProvider = new SMSProvider();
    var smsList = await smsProvider.getUnRead();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var phoneName = prefs.getString('PHONE_NAME_PREF_KEY');
    var listBody = [];
    for (var sms in smsList) {
      var bodyField = {
        'body': sms.body,
        'sender': sms.sender,
        'address': sms.address,
        'phone_name': phoneName,
        'date': sms.date.toString(),
        'date_send': sms.dateSent.toString(),
        'domain_name': 'sms-finance',
      };
      listBody.add(bodyField);
    }
    print(listBody);
    final url =
        Uri.https('sms-finance-prod-gye6ncwdlq-as.a.run.app', 'v1/sms/resend');
    final request = http.Request('POST', url);
    request.body = jsonEncode(listBody);
    Map<String, String> headerJson = {'Content-Type': 'application/json'};
    request.headers.addAll(headerJson);
    var res = await request.send();
    var resStr = await res.stream.bytesToString();
    print("res -> ${res.statusCode}, res: $resStr");
    var txtRes = "ส่งข้อความไปเช็คเรียบร้อยแล้ว";
    if (res.statusCode != 200) {
      txtRes = "ส่งข้อมูลไม่สำเร็จ";
    }

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(txtRes),
      duration: Duration(seconds: 5),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.autorenew),
            onPressed: () => _reSendAllUnReadSms(),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _setPhoneName(),
          )
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: _bloc.smsObservable,
          builder:
              (BuildContext context, AsyncSnapshot<List<SmsMessage>> snapshot) {
            final sms = snapshot.data ?? [];
            return RefreshIndicator(
              onRefresh: () => _bloc.getAllSMS(),
              child: SMSList(sms),
            );
          },
        ),
      ),
    );
  }
}
