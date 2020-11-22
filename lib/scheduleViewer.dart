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
  List<Shifts> shiftList;

  Future fetchShifts() async{

    final uri = Uri.http('10.0.0.246:3002', '/schedules/' + user_id);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);

    setState(() {
      shiftList=(json.decode(response.body) as List).map((i) =>
          Shifts.fromJson(i)).toList();
    });
    print(json.encode(shiftList[0]));

  }

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
            backgroundColor: Colors.teal,
          ),
          body: SfCalendar(
            headerHeight: 60,
            viewHeaderHeight: 50,
            view: CalendarView.week,
            dataSource: MeetingDataSource(_getDataSource()),
            monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
          ),
            //dataSource: _getDataSource(),
          //),
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

  List<Meeting> _getDataSource() {
    meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
    DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
        Meeting('Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }

  class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(this.source);

  List<Meeting> source;

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
  return source[index].from;
  }

  @override
  DateTime getEndTime(int index) {
  return source[index].to;
  }

  @override
  String getSubject(int index) {
  return source[index].eventName;
  }

  @override
  Color getColor(int index) {
  return source[index].background;
  }

  @override
  bool isAllDay(int index) {
  return source[index].isAllDay;
  }
  }

  class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  }
  _DataSource _getDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      startTime: DateTime(2020, 11, 22, 7),
      endTime: DateTime(2020, 11, 22, 11),
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


class Shifts {
  String shiftId;
  String title;
  String userID;
  String status;
  int startYear;
  int startMonth;
  int startDay;
  int startHour;
  int startMin;
  int endYear;
  int endMonth;
  int endDay;
  int endHour;
  int endMin;

  Shifts(
      {this.shiftId,
        this.title,
        this.userID,
        this.status,
        this.startYear,
        this.startMonth,
        this.startDay,
        this.startHour,
        this.startMin,
        this.endYear,
        this.endMonth,
        this.endDay,
        this.endHour,
        this.endMin});

  Shifts.fromJson(Map<String, dynamic> json) {
    shiftId = json['_id'];
    title = json['title'];
    userID = json['userID'];
    status = json['status'];
    startYear = json['startYear'];
    startMonth = json['startMonth'];
    startDay = json['startDay'];
    startHour = json['startHour'];
    startMin = json['startMin'];
    endYear = json['endYear'];
    endMonth = json['endMonth'];
    endDay = json['endDay'];
    endHour = json['endHour'];
    endMin = json['endMin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.shiftId;
    data['title'] = this.title;
    data['userID'] = this.userID;
    data['status'] = this.status;
    data['startYear'] = this.startYear;
    data['startMonth'] = this.startMonth;
    data['startDay'] = this.startDay;
    data['startHour'] = this.startHour;
    data['startMin'] = this.startMin;
    data['endYear'] = this.endYear;
    data['endMonth'] = this.endMonth;
    data['endDay'] = this.endDay;
    data['endHour'] = this.endHour;
    data['endMin'] = this.endMin;
    return data;
  }
}



class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}