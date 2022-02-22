
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'firebase_config.dart';
import 'message.dart';
import 'message_list.dart';


///
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  print('Handling a background message ${message.messageId}');
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  }catch(e){}

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp( MyApp());
}

Future<void> onActionSelected(String value) async {
  switch (value) {
    case 'subscribe':
      {
        print(
          'FlutterFire Messaging Example: Subscribing to topic "fcm_test".',
        );
        await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
        print(
          'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.',
        );
      }
      break;
    case 'unsubscribe':
      {
        print(
          'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".',
        );
        await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
        print(
          'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.',
        );
      }
      break;
    case 'get_apns_token':
      {
        if (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS) {
          print('FlutterFire Messaging Example: Getting APNs token...');
          String? token = await FirebaseMessaging.instance.getAPNSToken();
          print('FlutterFire Messaging Example: Got APNs token: $token');
        } else {
          print(
            'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.',
          );
        }
      }
      break;
    default:
      break;
  }
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => MyHomePage(title: 'Flutter FCM',),
        '/message': (context) => const MessageView(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;
  String? token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) => {
      debugPrint(value),
    });
    // messaging.subscribeToTopic(token.toString());
    messaging.subscribeToTopic("flutterFCM");
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if(message != null){
        Navigator.pushNamed(context, '/message', arguments: MessageArguments(message, true));
      }
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published');
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text('Notification'),
              content: Text(message.notification!.body!),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Okay')
                )
              ],
            );
          }
      );
      Navigator.pushNamed(context, '/message', arguments: MessageArguments(message, true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        /*actions: [
          PopupMenuButton(
            onSelected: onActionSelected,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'subscribe',
                  child: Text('Subscribe to topic'),
                ),
                const PopupMenuItem(
                  value: 'unsubscribe',
                  child: Text('Unsubscribe to topic'),
                ),
                const PopupMenuItem(
                  value: 'get_apns_token',
                  child: Text('Get APNs token (Apple only)'),
                ),
              ];
            },
          ),
        ],*/
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // MetaCard('Permission', Permissions()),
            // MetaCard('_title', Token)
            MetaCard('Message Stream', const MessageList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MetaCard extends StatelessWidget{
  final String _title;
  final Widget _children;

  MetaCard(this._title, this._children);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Text(_title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              ),
              const Divider(thickness: 1, color: Colors.black,),
              _children,
            ],
          ),
        ),
      ),
    );
  }


}
