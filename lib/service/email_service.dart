import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailService {
  static final instance = EmailService._();
  EmailService._();

  Future<void> sendSurvey({required String body}) async {
    final Email email = Email(
      subject: 'Survey of Festival Poster',
      body: body,
      recipients: ['infoapp003@gmail.com'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }
}
