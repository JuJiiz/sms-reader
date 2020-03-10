import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';
import 'package:sms_reader/src/bloc/home_bloc.dart';
import 'package:sms_reader/src/ui/phone_name_dialog.dart';
import 'package:sms_reader/src/ui/widget/sms_list.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
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
