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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    repo.retrieveAllSMS().listen((SmsMessage sms) async {
      Wakelock.enable();
      log("sms sender: ${sms.sender} | address: ${sms.address} | body: ${sms.body} | date_send: ${sms.dateSent}");

      var phoneName = prefs.getString('PHONE_NAME_PREF_KEY');

      var bodyField = {
        'body': sms.body,
        'sender': sms.sender,
        'address': sms.address,
        'phone_name': phoneName,
        'date_send': sms.dateSent.toString(),
      };

      final url = Uri.https('hengjung.com', 'api-sms/index.php');
      final request = http.Request('POST', url);
      request.body = jsonEncode(bodyField);
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
