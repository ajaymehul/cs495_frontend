import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'scheduleViewer.dart';

class TaskManager extends StatefulWidget {
  @override
  _TaskManagerState createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  String user_id = "";
  List<Task> tasklist;


  Future fetchTasks() async{

    final uri = Uri.http('10.0.0.246:3002', '/tasks/' + user_id);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);

    setState(() {
      tasklist=(json.decode(response.body) as List).map((i) =>
          Task.fromJson(i)).toList();
    });
    print(json.encode(tasklist[0]));

  }

  @override
  Widget build(BuildContext context) {
    user_id = ModalRoute.of(context).settings.arguments;
    fetchTasks();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Task Manager"),
        actions: <Widget>[FlatButton(
          color: Colors.teal[400],
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(2.0),
          splashColor: Colors.teal,
          onPressed: () {
            Navigator.of(context)
                .pushNamed(
              "addTask",
              // we are passing a value to the settings page
              //arguments: '${user['username']}',
            );
          },
          child: Text(
            "Add Task",
            style: TextStyle(fontSize: 16.0),
          ),
        )],
      ),
      body: _myListView(),
      //navigation bar to switch to scheduling
      bottomNavigationBar: new Container(
          height: 60.0,
          color: Colors.teal[600],
          child: Row(
            children: <Widget>[
              Expanded(
                //Task button - bold font and darker
                child: MaterialButton(
                    color: Colors.teal[800],
                    textColor: Colors.white,
                    height: 60,
                    onPressed: () {
                      //nothing
                    },
                    child: Text('Tasks',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ),
                      textAlign: TextAlign.center),
                ),
              ),
              Expanded(
                //Scheduling button - normal font and lighter
                child: MaterialButton(
                  color: Colors.teal[600],
                  textColor: Colors.white,
                  height: 60,
                  onPressed: () { //navigate to scheduling widget
                    Navigator.of(context)
                        .pushReplacementNamed(
                      "scheduler",
                      // we are passing a value to the settings page
                      arguments: user_id,
                    );
                  },
                  child: Text('Schedules', style: TextStyle(fontSize: 18),textAlign: TextAlign.center),
                ),
              ),
            ],
          )
      ),
    );
  }

  Widget _myListView() {
    return ListView.builder(
      itemCount: tasklist.length,
      itemBuilder: (context, index) {
        final Task item = tasklist[index];
        return Card(
            child: Column(children: [
              Container(
                  child: Row(children: [
                    Container(child: CircleAvatar(backgroundColor: Colors.teal[200],)),
                    Column(children: [
                      Text(item.title, style: TextStyle(fontSize: 16.0)),
                      Text(item.role, style: TextStyle(color: Color(4278190080))),
                      Text(item.shift, style: TextStyle(color: Color(4278190080)))
                    ])
                  ])),
              SizedBox(height: 10),
              Container(
                  child: Column(children: [
                    Text(
                        item.description),
                    Container()
                  ]))
            ]));
      },
    );
  }
}



class Task {
  String sId;
  String title;
  String description;
  List<SubTasks> subTasks;
  String role;
  String shift;
  String status;
  String assigned;

  Task(
      {this.sId,
        this.title,
        this.description,
        this.subTasks,
        this.role,
        this.shift,
        this.status,
        this.assigned});

  Task.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    if (json['subTasks'] != null) {
      subTasks = new List<SubTasks>();
      json['subTasks'].forEach((v) {
        subTasks.add(new SubTasks.fromJson(v));
      });
    }
    role = json['role'];
    shift = json['shift'];
    status = json['status'];
    assigned = json['assigned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.subTasks != null) {
      data['subTasks'] = this.subTasks.map((v) => v.toJson()).toList();
    }
    data['role'] = this.role;
    data['shift'] = this.shift;
    data['status'] = this.status;
    data['assigned'] = this.assigned;
    return data;
  }
}

class SubTasks {
  String stDesc;
  bool completed;

  SubTasks({this.stDesc, this.completed});

  SubTasks.fromJson(Map<String, dynamic> json) {
    stDesc = json['st_desc'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['st_desc'] = this.stDesc;
    data['completed'] = this.completed;
    return data;
  }
}
