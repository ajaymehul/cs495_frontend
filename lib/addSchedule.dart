import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'globals.dart' as global;
import 'package:google_fonts/google_fonts.dart';
import 'SubTasks.dart';

class AddSchedule extends StatefulWidget {
  @override
  _AddScheduleState createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {

  String user_id = "";
  final _formKey = GlobalKey<FormState>();
  List<User> userlist;
  List<String> usernamelist;
  String dropdownValue = "";
  bool flag = true;
  List<TextEditingController> subTasks = new List<TextEditingController>();

  @override
  void initState() {
    // TODO: implement initState
    usernamelist = new List<String>();
    super.initState();
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  Future fetchUsers() async{
    final uri = Uri.http(global.ip, '/users');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
      usernamelist.clear();

      usernamelist.add("open");
      userlist=(json.decode(response.body) as List).map((i) =>
          User.fromJson(i)).toList();
      for(int i=0; i< userlist.length; i++){
        usernamelist.add(userlist[i].username);
      }
      print(usernamelist);
      dropdownValue = usernamelist[0];

    setState(() {
    });


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
      'subTasks': st_list,
      'status': 'incomplete',
      'assigned': dropdownValue
    };

    final jsonString = json.encode(body);
    final uri = Uri.http(global.ip, '/addTask');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    print(json.encode(st_list));
    print(jsonString);
    final response = http.post(uri, headers: headers, body: jsonString);

    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    user_id = ModalRoute.of(context).settings.arguments;
    if(flag){
      fetchUsers();

      subTasks.add(new TextEditingController());
      print(subTasks.length.toString());
      flag = false;
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: Colors.purple
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Add New Shift", style: GoogleFonts.josefinSans(textStyle: TextStyle(foreground: Paint()..shader = linearGradient, fontSize: 25, fontWeight: FontWeight.bold))),

      ),
      body: Builder( builder: (context) => Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                    ),
                    Text('Assign To:',
                        style: GoogleFonts.josefinSans(textStyle: TextStyle(foreground: Paint()..shader = linearGradient,  fontWeight: FontWeight.bold)),
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
                          .toList() ?? null,
                    ),
                    SizedBox(
                    )
                  ],
                )
            ),


          ],
        ),
      )),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0)
          ),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xfffaac7b), Color(0xfff74c83)]),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]

        ),
        child: FlatButton(
          color: Colors.transparent,
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
                postTask(context);
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));

              }
            }
          },
          child: Text('Submit', style: GoogleFonts.josefinSans(textStyle: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold))),
        ),
      ) ,
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

