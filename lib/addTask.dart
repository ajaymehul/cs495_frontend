import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'globals.dart' as global;
import 'package:google_fonts/google_fonts.dart';
import 'SubTasks.dart';

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
  List<TextEditingController> subTasks = new List<TextEditingController>();

  Future fetchUsers() async{
    final uri = Uri.http(global.ip, '/users');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);

    setState(() {
      userlist=(json.decode(response.body) as List).map((i) =>
          User.fromJson(i)).toList();
    });
    print(json.encode(userlist[0]));

    for(int i=0; i< userlist.length; i++){
      usernamelist.add(userlist[i].username);
    }
    dropdownValue = usernamelist[0];

  }

  Future postTask(BuildContext context) async{

    if(subTasks[0].text == ""){
      return;}
    List<SubTasks> st_list = new List<SubTasks>();
    for(int i=0;i<subTasks.length;i++){
      SubTasks temp = new SubTasks();
      temp.stDesc = subTasks[i].text;
      temp.completed = false;
      st_list.add(temp);
    }

    final body = {
      'title': titleController.text,
      'description': descController.text,
      'role': roleController.text,
      'subTasks': json.encode(st_list),
      'shift': shiftController.text,
      'status': 'incomplete',
      'assigned': dropdownValue
    };

    final jsonString = json.encode(body);
    final uri = Uri.http(global.ip, '/addTask');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    print(json.encode(st_list));
    print(jsonString);
    final response = http.post(uri, headers: headers, body: jsonString);
    print(response);

    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    user_id = ModalRoute.of(context).settings.arguments;
    if(flag){
      usernamelist.add("open");
      fetchUsers();
      flag = false;
      subTasks.add(new TextEditingController());
      print(subTasks.length.toString());
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Task"),

      ),
      body: Builder( builder: (context) => Form(
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
                style: GoogleFonts.josefinSans(textStyle: TextStyle(fontSize: 20 ))
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
                style: GoogleFonts.josefinSans(textStyle: TextStyle(fontSize: 20 ))
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
                style: GoogleFonts.josefinSans(textStyle: TextStyle(fontSize: 20 ))
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
              style: GoogleFonts.josefinSans(textStyle: TextStyle(fontSize: 20 )),
            ),
            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                    ),
                    Text('Assign To:',
                        style: GoogleFonts.josefinSans(textStyle: TextStyle(fontSize: 20 )),
                        textAlign: TextAlign.center),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: GoogleFonts.josefinSans(textStyle: TextStyle(fontSize: 20 ), color: Colors.deepPurple),
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
                    ),
                    SizedBox(
                    )
                  ],
                )
            ),

            Expanded(
                child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: false,
              itemCount: subTasks.length,
              itemBuilder: (context, index) {
                print(index.toString()+ "/" + subTasks.length.toString());
              return Container(
                margin: const EdgeInsets.only(top: 8.0),
                decoration: BoxDecoration(
                    color: Color(0xddffffff),
                    borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)
                )),
              child:  Container(
              child: Row(
                children: [Expanded(child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(

                      labelText: 'Enter Sub Task'

                  ),
                  controller: subTasks[index],
                  style: GoogleFonts.josefinSans(textStyle: TextStyle(fontSize: 15 )),
                )),
                  IconButton(
                    icon: Icon(Icons.add_circle_rounded, color: Colors.green),
                    tooltip: 'Add new task',
                    onPressed: () {
                      subTasks.add(new TextEditingController());
                      setState(() {
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel,color: Colors.red),
                    tooltip: 'Delete task',
                    onPressed: () {
                      if(index>0) subTasks.removeAt(index);
                      setState(() {
                      });
                    },
                  )
                ]

              ),
              )
            );
          },
            )),

            Center(

              child: RaisedButton(

                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    bool invalidst = false;
                    for(int i=0;i<subTasks.length;i++){
                      if(subTasks[i].text == "") invalidst = true;
                    }
                    if(invalidst){
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('Subtasks cannot be empty')));
                    }
                    else{
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));
                    postTask(context);
                    }
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      )),
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

