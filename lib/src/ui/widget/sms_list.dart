import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';
import 'package:wakelock/wakelock.dart';

void smsLog() {}

class SMSList extends StatelessWidget {
  final List<SmsMessage> messages;

  SMSList(this.messages);

  Widget smsListItem(SmsMessage message, BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(message.sender),
              Text(message.address),
              Text(message.body),
              Text(message.date.toString()),
              RaisedButton(
                onPressed: () async {
                  bool isEnabled = await Wakelock.isEnabled;
                  if (!isEnabled) {
                    Wakelock.enable();
                  }
                  print(
                      "-> -> sms sender: ${message.sender} | address: ${message.address} | body: ${message.body} | date_send: ${message.dateSent}");
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  var phoneName = prefs.getString('PHONE_NAME_PREF_KEY');
                  var bodyField = {
                    'body': message.body,
                    'sender': message.sender,
                    'address': message.address,
                    'phone_name': phoneName,
                    'date_send': message.date.toString(),
                  };

                  //TODO
                  final url = Uri.https('hengjung.com', 'api-sms/index.php');
                  final request = http.Request('POST', url);
                  request.body = jsonEncode(bodyField);
                  /*if (headers != null) {
                  request.headers.addAll(headers);
                }*/
                  var res = await request.send();
                  var resStr = await res.stream.bytesToString();
                  print("res -> ${res.statusCode}, res: $resStr");
                  var txtRes = "ส่งข้อความเรียบร้อยแล้ว";
                  if (res.statusCode != 200) {
                    txtRes = "ส่งข้อมูลไม่สำเร็จ";
                  }
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(txtRes),
                    duration: Duration(seconds: 5),
                  ));
                },
                child: Text('Send Api'),
              )
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) =>
          smsListItem(messages[index], context),
    );
  }
}
