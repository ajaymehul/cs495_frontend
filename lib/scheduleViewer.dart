import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:google_fonts/google_fonts.dart';
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
  CalendarController _calendarController;

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
  initState() {
    _calendarController = CalendarController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user_id = ModalRoute.of(context).settings.arguments;


    return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Scheduler', style: GoogleFonts.josefinSans()),
              actions: <Widget>[FlatButton(
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(2.0),
                onPressed: () {
                   Navigator.of(context)
                       .pushNamed(
                     "addSchedule",
                     // we are passing a value to the settings page
                    //arguments: '${user['username']}',
                   );
                },
                child: Text(
                  "Add Shift",
                  style: GoogleFonts.josefinSans( textStyle: TextStyle(fontSize: 16.0)),
                ),
              ),
              //button to navigate calendar dates
              IconButton(icon: Icon(Icons.arrow_forward),
                onPressed: () {
                _calendarController.forward();
              },
            )],
          ),
          body: SfCalendar(
            headerHeight: 60,
            viewHeaderHeight: 50,
            view: CalendarView.month,
            showDatePickerButton: true,
            allowedViews: <CalendarView>
            [
              CalendarView.day,
              CalendarView.week,
              CalendarView.month,
              CalendarView.schedule
            ],
            controller: _calendarController,
            dataSource: _getDataSource(),
          ),
          bottomNavigationBar: new Container(
              //height: 60.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0,3),
                ),
              ],
            ),
              height: 60.0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    //Task button - bold font and darker
                    child: MaterialButton(
                      color: Color(0xfff3a2755),
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
                      color: Color(0xfff74c83),
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

//
