import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:sms_reader/src/bloc/home_bloc.dart';
import 'package:sms_reader/src/ui/widget/sms_list.dart';

class HomeUI extends StatefulWidget {
  HomeUI({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  final bloc = new HomeBloc();

  @override
  void initState() {
    super.initState();
    bloc.getAllSMS();
    bloc.retrieveAllSMS();
  }

  /*_checkPhoneName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getInt('counter')

  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        child: StreamBuilder(
          stream: bloc.smsObservable,
          builder:
              (BuildContext context, AsyncSnapshot<List<SmsMessage>> snapshot) {
            if (snapshot.hasData) {
              return SMSList(snapshot.data);
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
