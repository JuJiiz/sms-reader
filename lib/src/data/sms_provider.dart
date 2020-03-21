import 'package:sms/sms.dart';

class SMSProvider {
  final query = new SmsQuery();

  Future<List<SmsMessage>> getAllSMS() async {
    return await query.getAllSms;
  }

  Future<List<SmsMessage>> getUnRead() async {
    var allSms = await query.getAllSms;
    return allSms.where((sms) => !sms.isRead).toList();
  }
}