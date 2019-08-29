import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

class SMSList extends StatelessWidget {
  final List<SmsMessage> messages;

  SMSList(this.messages);

  Widget smsListItem(SmsMessage message) {
    return Container(
      child: Column(
        children: <Widget>[
          Column(children: <Widget>[
            Text(message.address),
            Text(message.body),
            Text(message.date.toString()),
            Text(message.dateSent.toString()),
          ],),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) => smsListItem(messages[index]),
    );
  }
}
