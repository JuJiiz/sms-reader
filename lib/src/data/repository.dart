import 'package:sms/sms.dart';
import 'package:sms_reader/src/data/sms_provider.dart';

class Repository {
  final smsProvider = new SMSProvider();

  Future<List<SmsMessage>> getAllSMS() => smsProvider.getAllSMS();
}