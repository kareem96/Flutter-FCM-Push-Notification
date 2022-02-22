


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fcm/message.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  List<RemoteMessage> _message = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _message = [
          ..._message, message
        ];
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    if(_message.isEmpty){
      return const Text('No messages received');
    }
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _message.length,
        itemBuilder: (context, index){
          RemoteMessage message = _message[index];
          return Dismissible(
            background: Container(
              color: Colors.red,
            ),
              key: ValueKey<RemoteMessage>(_message[index]),
              onDismissed: (DismissDirection direction){
                setState(() {
                  _message.removeAt(index);
                });
              },
              child: ListTile(
                title: Text(message.messageId ?? 'no RemoteMessage.messageId available'),
                subtitle: Text(message.sentTime?.toString() ?? DateTime.now().toString()),

                onTap: () => {
                  Navigator.pushNamed(context, '/message', arguments: MessageArguments(message, false))
                },
              )
          );
        }
    );
  }
}
