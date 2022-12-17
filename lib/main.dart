import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gusta/screens/login_screen.dart';
import 'package:flutter_gusta/screens/register_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gusta/models/loginError.dart';
import 'package:flutter_gusta/models/token.dart';
import 'package:flutter_gusta/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
