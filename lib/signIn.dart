import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<String> getToken() async {
    print(nameController.text);
    final body = {
      'username': nameController.text,
      'password': passwordController.text,
    };
    final jsonString = json.encode(body);
    final uri = Uri.http('10.0.0.175:3002', '/login');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(uri, headers: headers, body: jsonString);

    Map<String, dynamic> user = jsonDecode(response.body);
    print('type: ${user['type']}');
    if('${user['type']}' == 'manager'){
      Navigator.of(context)
          .pushReplacementNamed(
        "taskManager",
        // we are passing a value to the settings page
        arguments: '${user['username']}',
      );
    }
    else if ('${user['type']}' == 'employee'){
      Navigator.of(context)
          .pushReplacementNamed(
        "eView",
        // we are passing a value to the settings page
        arguments: '${user['username']}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 140),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '[Name Placeholder ]',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),

                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      onPressed: getToken,
                    )),
                SizedBox(height: 30)
              ],
            )));
  }
}