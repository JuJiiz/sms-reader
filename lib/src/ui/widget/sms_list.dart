import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sms/sms.dart';
import 'package:wakelock/wakelock.dart';

void smsLog() {}

class SMSList extends StatelessWidget {
  final List<SmsMessage> messages;

  SMSList(this.messages);

  Widget smsListItem(SmsMessage message) {
    return Container(
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(message.sender),
              Text(message.address),
              Text(message.body),
              Text(message.date.toString()),
              Text(message.dateSent.toString()),
              RaisedButton(
                onPressed: () async {
                  bool isEnabled = await Wakelock.isEnabled;
                  if (!isEnabled) {
                    Wakelock.enable();
                  }
                  print(
                      "-> -> sms sender: ${message.sender} | address: ${message.address} | body: ${message.body} | date_send: ${message.dateSent}");
                  var bodyField = {
                    'body': message.body,
                    'sender': message.sender,
                    'address': message.address,
                    'phone_name': 'phoneA',
                    'date_send': message.dateSent.toString(),
                  };

                  //TODO
                  final url = Uri.https('hengjung.com', 'api-sms/test.php');
                  final request = http.Request('POST', url);
                  request.body = jsonEncode(bodyField);
                  /*if (headers != null) {
                  request.headers.addAll(headers);
                }*/
                  var res = await request.send();
                  var resStr = await res.stream.bytesToString();
                  print("res -> ${res.statusCode}, res: $resStr");
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
          smsListItem(messages[index]),
    );
  }
}
