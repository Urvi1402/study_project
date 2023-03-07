import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:study_project/responsive/mobile_screen_layout.dart';
import 'package:study_project/responsive/responsive_layout_screen.dart';
import 'package:study_project/responsive/web_screen_layout.dart';
import 'package:study_project/screens/home_screen.dart';
import 'package:study_project/utilities/colors.dart';
import 'package:camera/camera.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDxA9YsZH_eD8XOmEjXtDos8F9H_lYl0uk",
        appId: "1:267937519577:web:d06607f793c734cdd66bc8",
        messagingSenderId: "267937519577",
        projectId: "study-project-99570",
        storageBucket: "study-project-99570.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Project',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      // home: const ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(),
      //   webScreenLayout: WebScreenLayout(),
      // ),
      home: HomeScreen(),
    );
  }
}
