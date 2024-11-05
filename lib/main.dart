import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:waterqualitymanagemen_system/app_features/logout.dart';
import 'app_menu.dart';
import 'authentication/forget_pass.dart';
import 'authentication/login_screen.dart';
import 'authentication/register.dart';
import 'authentication/screen.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure Flutter is initialized
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic Notification',
            channelDescription: 'Notification channel for basic tests'
        )
      ],
      debug: true
  );
  await Firebase.initializeApp().then((value) {
    print("Firebase initialized successfully!");
  }).catchError((error) {
    print("Error initializing Firebase: $error");
  });
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash_screen',
      routes: {
        '/splash_screen': (context) => SplashScreen(),
        '/screen': (context) => MyScreen(),
        '/login_screen': (context) => LoginScreen(),
        '/register_screen': (context) => RegisterScreen(),
        '/forget_pass_screen': (context) => ForgetPasswordScreen(),
        '/app_menu_screen': (context) => AppMenuPage(), // Change route to AppMenuPage
         '/logout_screen': (context) => LogoutPage(), // Change route to AppMenuPage

    },
    );
  }
}
