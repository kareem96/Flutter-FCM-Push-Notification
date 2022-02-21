


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessageArguments {
  final RemoteMessage message;

  final bool openedApplication;

  MessageArguments(this.message, this.openedApplication);
}



class MessageView extends StatelessWidget {
  const MessageView({Key? key}) : super(key: key);

  Widget row(String title, String? value){
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title'),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MessageArguments args = ModalRoute.of(context)!.settings.arguments! as MessageArguments;
    RemoteMessage message = args.message;
    RemoteNotification? notification = message.notification;
    return Scaffold(
      appBar: AppBar(title: Text(message.messageId ??  'N/A'),),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
