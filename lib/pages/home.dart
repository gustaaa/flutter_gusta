import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gusta/pages/categories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/http_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var categoryList = <Category>[];

  @override
  void initState() {
    setState(() {
      fetchData();
    });
    super.initState();
  }

  void fetchData() async {
    var categories = await getList();
    if (categories != null) {
      categoryList.addAll(categories);
    }
  }

  Future<List<Category>?> getList() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('token');
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      var url =
          Uri.parse(HttpService.baseUrl + HttpService.authEndpoints.categories);

      http.Response response = await http.get(url, headers: headers);

      print(response.statusCode);
      print(categoryList.length);
      print(jsonDecode(response.body));

      if (response.statusCode == 200) {
        var jsonString = response.body;
        return categoryFromJson(jsonString);
      }
    } catch (error) {
      print('Testing');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('List Categories'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(categoryList[index].name),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    //request logout
                    final pref = await SharedPreferences.getInstance();
                    final token = pref.getString('token');

                    final logoutRequest = await http.post(
                      Uri.parse('http://192.168.240.84:8000/api/auth/logout'),
                      headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                    );
                    if (!mounted) return;
                    if (logoutRequest.statusCode == 204) {
                      print("logout success");
                      //logout success
                      pref.remove('token');
                      //navigate to login page
                      Navigator.of(context).pushReplacementNamed('/');
                    }
                  },
                  child: Text('Logout'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
