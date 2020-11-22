import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'taskManager.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'eView.dart';

class Scheduler extends StatefulWidget {
  @override
  SchedulerState createState() => SchedulerState();
}

class SchedulerState extends State<Scheduler> {
  String user_id = "";
  // List<Task> tasklist;

  // Future fetchTasks() async{
  //
  //   final uri = Uri.http('10.0.0.246:3002', '/tasks/' + user_id);
  //   final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
  //   final response = await http.get(uri, headers: headers);
  //
  //   setState(() {
  //     tasklist=(json.decode(response.body) as List).map((i) =>
  //         Task.fromJson(i)).toList();
  //   });
  //   print(json.encode(tasklist[0]));
  //
  // }

  @override
  Widget build(BuildContext context) {
    user_id = ModalRoute.of(context).settings.arguments;

    return Scaffold(
          appBar: AppBar(
            title: Text('My Schedule'),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  //change state
                },
              ),
            ],
            backgroundColor: Colors.lightGreenAccent,
          ),
          body: SfCalendar(
            headerHeight: 60,
            viewHeaderHeight: 50,
            view: CalendarView.week,
            dataSource: _getDataSource(),
          ),
          bottomNavigationBar: new Container(
              height: 60.0,
              color: Colors.teal[600],
              child: Row(
                children: <Widget>[
                  Expanded(
                    //Task button - bold font and darker
                    child: MaterialButton(
                      color: Colors.teal[600],
                      textColor: Colors.white,
                      height: 60,
                      onPressed: () {
                        Navigator.of(context) //Add arguments? throws error
                            .pushReplacementNamed(
                          "taskManager",
                          // we are passing a value to the settings page

                        );
                      },
                      child: Text('Tasks',
                          style: TextStyle(fontSize: 18 ), textAlign: TextAlign.center),
                    ),
                  ),
                  Expanded(
                    //Scheduling button - normal font and lighter
                    child: MaterialButton(
                      color: Colors.teal[800],
                      textColor: Colors.white,
                      height: 60,
                      onPressed: () { //navigate to scheduling widget
                       //nothing
                      },
                      child: Text('Schedules',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                          ,textAlign: TextAlign.center),
                    ),
                  ),
                ],
              )
          ),
        );
  }

  _DataSource _getDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      startTime: DateTime(2020, 10, 16, 7),
      endTime: DateTime(2020, 10, 16, 11),
      subject: 'Hostess',
      color: Colors.lightBlueAccent,
    ));
    appointments.add(Appointment(
      startTime: DateTime(2020, 10, 15, 10),
      endTime: DateTime(2020, 10, 15, 16),
      subject: 'Server - patio',
      color: Colors.greenAccent,
    ));
    appointments.add(Appointment(
      startTime: DateTime(2020, 10, 12, 8),
      endTime: DateTime(2020, 10, 12, 12),
      subject: 'Server - section 3',
      color: Colors.cyanAccent,
    ));
    appointments.add(Appointment(
      startTime: DateTime(2020, 10, 12, 12, 15),
      endTime: DateTime(2020, 10, 12, 16),
      subject: 'Delivery',
      color: Color(0xFFf3282b8),
    ));

    return _DataSource(appointments);
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}