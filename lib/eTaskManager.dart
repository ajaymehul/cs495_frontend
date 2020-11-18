import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class eTaskList extends StatefulWidget {
  @override
  _eTaskListState createState() => _eTaskListState();
}

class _eTaskListState extends State<eTaskList> {
  @override
  Widget build(BuildContext context) {
    bool _isChecked = false;
    return Scaffold(
        appBar: AppBar(
          title: Text("To-Do Tasks"),
        ),
        body: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(10),
                height: 200,
                width: 100,
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'TITLE:   Put change in the cashier',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'DESCRIPTION : Please ensure that there are enough 1 and 5 dollar bills ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text("Task completed?"),
                        value: _isChecked,
                        onChanged: (bool value) {
                          setState(() {
                            _isChecked = true;
                          });
                        },
                      )
                    ],
                  ),
                )),
            Container(
                padding: EdgeInsets.all(10),
                height: 200,
                width: 100,
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'TITLE:    Prepare Boiled peanuts ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'DESCRIPTION : Clean the pot, pour fresh water, put peanuts and start boiling ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text("Task completed?"),
                        value: _isChecked,
                        onChanged: (bool value) {
                          setState(() {
                            _isChecked = true;
                          });
                        },
                      )
                    ],
                  ),
                )),
            Container(
                padding: EdgeInsets.all(10),
                height: 200,
                width: 100,
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'TITLE:   Clean the area  near cash register',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'DESCRIPTION : Remove unwanted stuff from the table and make sure everything is clean ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text("Task completed?"),
                        value: _isChecked,
                        onChanged: (bool value) {
                          setState(() {
                            _isChecked = true;
                          });
                        },
                      )
                    ],
                  ),
                )),
          ],
        ));
  }
}
/*
  Widget _myListView() {
    return ListView.builder(
      itemCount: tasklist.length,
      itemBuilder: (context, index) {
        final Task item = tasklist[index];
        return Card(
            child: Column(children: [
              Container(
                  child: Row(children: [
                    Container(child: CircleAvatar()),
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
  String title;
  String description;
  String role;
  String shift;
  Task(this.title,this.description,this.role,this.shift );

  // named constructor
  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        role = json['role'],
        shift = json['shift'];

  // method
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'role': role,
      'shift': shift

    };
  }

}
*/