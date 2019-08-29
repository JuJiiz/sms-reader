import 'package:sms/sms.dart';

class SMSProvider {
  final query = new SmsQuery();

  Future<List<SmsMessage>> getAllSMS() async {
    return await query.getAllSms;
  }
}