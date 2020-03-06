import 'dart:developer';

import 'package:rxdart/rxdart.dart';
import 'package:sms/sms.dart';
import 'package:sms_reader/src/data/repository.dart';

class HomeBloc {
  final repo = new Repository();

  final _smsFetcher = PublishSubject<List<SmsMessage>>();

  Observable<List<SmsMessage>> get smsObservable => _smsFetcher.stream;

  retrieveAllSMS() {
    repo.retrieveAllSMS().listen((SmsMessage sms) {
      log("sms sender: ${sms.sender} | address: ${sms.address} | body: ${sms.body}");

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
