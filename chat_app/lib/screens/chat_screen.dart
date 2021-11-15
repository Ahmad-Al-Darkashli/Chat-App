import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onMessage.listen(
      (message) {
        print('Asad');
        print(message.data);
        print("Asad");
      },
    ).onData(
      (message) {
        print('Ahmad');
        print(message.data);
        print("Ahmad");
      },
    );
    messaging.requestPermission();
    messaging.getInitialMessage();
    messaging.getNotificationSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButton(
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(
                  child: Row(
                    children: const [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8.0),
                      Text('Logout'),
                    ],
                  ),
                  value: 'logout',
                ),
              ],
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              }),
        ],
        title: const Text('Chat Page'),
      ),
      body: Column(
        children: const [
          Expanded(
            child: Messages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
