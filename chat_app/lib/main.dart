import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './screens/chat_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        backgroundColor: Colors.deepOrange,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.amber,
          primarySwatch: Colors.deepOrange,
          backgroundColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.deepOrange,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (userSnapshot.data != null) {
            return const ChatScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
