import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hourly/homescreen.dart';
import 'package:hourly/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/user.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // void initState() {
  //   super.initState();
  //
  //   _getCurrentUser();
  // }
  //
  // void _getCurrentUser() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //
  //   try {
  //     if(sharedPreferences.getString())
  //   }
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hourly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const KeyboardVisibilityProvider(
        child: AuthCheck(),
      )
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();

    try {
      if(sharedPreferences.getString('employeeId') != " ") {
        setState(() {
          User.username = sharedPreferences.getString('employeeId')!;
          userAvailable = true;
        });
      }
    } catch(e) {
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable ? const HomeScreen() : const LoginScreen();
  }
}


