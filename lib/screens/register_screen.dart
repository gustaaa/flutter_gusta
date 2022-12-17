import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gusta/models/loginError.dart';
import 'package:flutter_gusta/models/token.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  bool isLoggedIn = false;
  bool isLoginInProgress = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            TextFormField(
              controller: passwordConfirmationController,
              decoration: const InputDecoration(
                labelText: 'Konfiramsi Password',
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoginInProgress = true;
                  });
                  //request login
                  Map<String, String> headers = {"Accept": "application/json"};
                  final response = await http.post(
                    Uri.parse('http://192.168.240.84:8000/api/auth/register'),
                    headers: headers,
                    body: {
                      'name': nameController.text,
                      'email': emailController.text,
                      'password': passwordController.text,
                      // 'device_name': 'android',
                    },
                  );
                  print(response.body);
                  print(response.statusCode);
                  if (response.statusCode == 200) {
                    final jsonResponse = json.decode(response.body);
                    final token = Token.fromJson(jsonResponse);
                    final prefs = await SharedPreferences.getInstance();
                    print("Token From Api ${token.token}");
                    if (token.token != null) {
                      await prefs.setString('token', token.token!);
                      setState(() {
                        isLoginInProgress = false;
                        isLoggedIn = true;
                      });

                      if (!mounted) {
                        return;
                      }

                      if (isLoggedIn) {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    }
                  } else {
                    final jsonResponse = json.decode(response.body);
                    final loginError = LoginError.fromJson(jsonResponse);
                    // print(loginError.message);
                    // print(loginError.errors?.email?.elementAt(0));
                    setState(() {
                      isLoginInProgress = false;
                      isLoggedIn = false;
                    });
                  }
                },
                child: const Text("Register"),
              ),
            ),
            Center(
              child: Row(
                children: [
                  const Text("Sudah punya akun?"),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: const Text("Login"))
                ],
              ),
            ),
            Visibility(
              visible: isLoginInProgress,
              child: const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
