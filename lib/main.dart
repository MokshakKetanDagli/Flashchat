import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat_app/screens/chatscreen.dart';
import 'package:flash_chat_app/screens/loginscreen.dart';
import 'package:flash_chat_app/screens/registerscreen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'screens/homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    DevicePreview(
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      initialRoute: HomeScreen.id,
      onGenerateRoute: (settings) {
        if (settings.name == HomeScreen.id) {
          return PageTransition(
            child: HomeScreen(),
            type: PageTransitionType.rightToLeft,
          );
        } else if (settings.name == LoginScreen.id) {
          return PageTransition(
            child: LoginScreen(),
            type: PageTransitionType.rightToLeft,
          );
        } else if (settings.name == RegisterScreen.id) {
          return PageTransition(
            child: RegisterScreen(),
            type: PageTransitionType.rightToLeft,
          );
        } else if (settings.name == ChatScreen.id) {
          return PageTransition(
            child: ChatScreen(),
            type: PageTransitionType.rightToLeft,
          );
        } else {
          return PageTransition(
            child: HomeScreen(),
            type: PageTransitionType.rightToLeft,
          );
        }
      },
    );
  }
}
