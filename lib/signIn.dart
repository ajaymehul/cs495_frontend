import 'dart:io';
import 'globals.dart' as global;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

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
    final uri = Uri.http(global.ip, '/login');
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
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
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
                      'BizManager',
                      style: GoogleFonts.josefinSans( textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 50, foreground: Paint()..shader = linearGradient)),
                    )),
                SizedBox(height: 20),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign in',
                      style: GoogleFonts.josefinSans( textStyle:TextStyle(fontSize: 20)),
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
                SizedBox(height: 20),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xfffaac7b), Color(0xfff74c83)]),

                    ),
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: FlatButton(
                      color: Colors.transparent,
                      textColor: Colors.white,
                      child: Text(
                        'Login',
                        style: GoogleFonts.josefinSans( textStyle: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 22)),
                      ),
                      onPressed: getToken,
                    )),
                SizedBox(height: 30)
              ],
            )));
  }
}