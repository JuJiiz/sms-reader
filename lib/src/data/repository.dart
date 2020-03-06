import 'package:sms/sms.dart';
import 'package:sms_reader/src/data/sms_provider.dart';

class Repository {
  final smsReceiver = new SmsReceiver();
  final smsProvider = new SMSProvider();

  Stream<SmsMessage> retrieveAllSMS() => smsReceiver.onSmsReceived;

  Future<List<SmsMessage>> getAllSMS() => smsProvider.getAllSMS();
}
