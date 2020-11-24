import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'globals.dart' as global;

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  String user_id = "";
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final roleController = TextEditingController();
  final shiftController = TextEditingController();
  List<User> userlist;
  List<String> usernamelist = new List<String>();
  String dropdownValue = "";
  bool flag = true;

  Future fetchUsers() async{
    final uri = Uri.http(global.ip, '/users');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);

    setState(() {
      userlist=(json.decode(response.body) as List).map((i) =>
          User.fromJson(i)).toList();
    });
    print(json.encode(userlist[0]));
    dropdownValue = userlist[0].username;

    for(int i=0; i< userlist.length; i++){
      usernamelist.add(userlist[i].username);
    }

  }

  Future postTask() async{
    final body = {
      'title': titleController.text,
      'description': descController.text,
      'role': roleController.text,
      'shift': shiftController.text,
      
    };
    final jsonString = json.encode(body);
    final uri = Uri.http(global.ip, '/addTask');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(uri, headers: headers, body: jsonString);
  }


  @override
  Widget build(BuildContext context) {
    user_id = ModalRoute.of(context).settings.arguments;
    if(flag){
      fetchUsers();
      flag = false;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Task"),

      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Title'
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: titleController,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Description'
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: descController,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Role'
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: roleController,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Shift'
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: shiftController,
            ),
            Container(
                child: Row(
                  children: [
                    Text("Assigned To:"),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                          color: Colors.deepPurple
                      ),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: usernamelist
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                          .toList(),
                    )
                  ],
                )
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));
                    postTask();
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }


}


class User {
  String sId;
  String username;
  String password;
  String type;

  User({this.sId, this.username, this.password, this.type});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    password = json['password'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['password'] = this.password;
    data['type'] = this.type;
    return data;
  }
}
