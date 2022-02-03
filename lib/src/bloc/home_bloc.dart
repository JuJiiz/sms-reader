import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms/sms.dart';
import 'package:sms_reader/src/data/repository.dart';
import 'package:wakelock/wakelock.dart';

class HomeBloc {
  final repo = new Repository();

  final _smsFetcher = PublishSubject<List<SmsMessage>>();

  Observable<List<SmsMessage>> get smsObservable => _smsFetcher.stream;

  retrieveAllSMS() async {
    repo.retrieveAllSMS().listen((SmsMessage sms) async {
      Wakelock.enable();
      log("sms sender: ${sms.sender} | address: ${sms.address} | body: ${sms.body} | date_send: ${sms.dateSent}");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var phoneName = prefs.getString('PHONE_NAME_PREF_KEY');

      var bodyField = {
        'body': sms.body,
        'sender': sms.sender,
        'address': sms.address,
        'phone_name': phoneName,
        'date_send': sms.date.toString(),
        'domain_name': 'sms-finance',
      };

      //TODO
      final url =
          Uri.https('sms-finance-prod-gye6ncwdlq-as.a.run.app', 'v1/sms');
      final request = http.Request('POST', url);
      request.body = jsonEncode(bodyField);
      Map<String, String> headerJson = {'Content-Type': 'application/json'};
      request.headers.addAll(headerJson);
      var res = await request.send();
      var resStr = await res.stream.bytesToString();
      print("res -> ${res.statusCode}, res: $resStr");
      getAllSMS();
    });
  }

  getAllSMS() async {
    var messages = await repo.getAllSMS();
    _smsFetcher.sink.add(messages);
  }

  dispose() {
    _smsFetcher?.close();
  }
}
