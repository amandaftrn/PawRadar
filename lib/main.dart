import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pet_activity_screen.dart';
import 'screens/health_chart_screen.dart';
import 'screens/location_screen.dart';
import 'screens/preferences_screen.dart';

void main() {
  runApp(PawRadarApp());
}

class PawRadarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawRadar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF4A80F0),
        hintColor: Color(0xFFF09A59),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      home: LoginScreen(),
      routes: {
        '/home' : (context) => HomeScreen(),
        '/login' : (context) => LoginScreen(),
      },
    );
  }
}