import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'globals.dart' as global;
import 'Schedule.dart';
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
  List<Schedule> schedulelist = new List<Schedule>();
  bool flag = true;
  List<bool> _isExpanded = new List<bool>();

  Future fetchSchedules() async {
    final uri = Uri.http(global.ip, '/shifts');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);

    setState(() {
      schedulelist = (json.decode(response.body) as List).map((i) =>
          Schedule.fromJson(i)).toList();
      for (int i = 0; i < schedulelist.length; i++)
        _isExpanded.add(false);
    });
    print(json.encode(schedulelist[0]));
  }

  @override
  initState() {
    _calendarController = CalendarController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user_id = ModalRoute
        .of(context)
        .settings
        .arguments;
    if (flag) {
      flag = false;
      fetchSchedules();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Scheduler', style: GoogleFonts.josefinSans(
            textStyle: TextStyle(foreground: Paint()
              ..shader = linearGradient,
                fontSize: 25, fontWeight: FontWeight.bold))),
        actions: <Widget>[FlatButton(
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(2.0),
          onPressed: () {
            // Navigator.of(context)
            //     .pushNamed(
            //   "addShift",
            //   // we are passing a value to the settings page
            //   //arguments: '${user['username']}',
            // );
          },
          child: Text(
            "Add Shift",
            style: GoogleFonts.josefinSans(
                textStyle: TextStyle(foreground: Paint()
                  ..shader = linearGradient,
                    fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
          //button to navigate calendar dates
          IconButton(icon: Icon(Icons.arrow_forward),
            onPressed: () {
              _calendarController.forward();
            },
          )
        ],
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
        dataSource: _calendarDataSource(),
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
                offset: Offset(0, 3),
              ),
            ],
          ),
          height: 60.0,
          child: Row(
            children: <Widget>[
              Expanded(
                child: IconButton(

                  icon: Icon(Icons.logout),
                  color: Colors.purple,
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("signIn");
                  },
                ),
              ),
              Expanded(
                //Task button - bold font and darker
                child: FlatButton(
                  textColor: Colors.white,
                  height: 60,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context) //Add arguments? throws error
                        .pushReplacementNamed(
                      "taskManager",
                      // we are passing a value to the settings page

                    );
                  },
                  child: Text('Tasks',
                      style: GoogleFonts.josefinSans(
                          foreground: Paint()
                            ..shader = linearGradient,
                          fontSize: 18, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center),
                ),
              ),
              Expanded(
                //Scheduling button - normal font and lighter
                child: FlatButton(
                  textColor: Colors.white,
                  color: Colors.white,
                  height: 60,
                  onPressed: () { //navigate to scheduling widget
                    //nothing
                  },
                  child: Text('Scheduler',
                      style: GoogleFonts.josefinSans(
                          textStyle: TextStyle(
                              foreground: Paint()
                                ..shader = linearGradient,
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      textAlign: TextAlign.center),
                ),
              ),
            ],
          )
      ),
    );
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));


  _DataSource _calendarDataSource() {
    ShiftDataSource(List<Schedule> source) {
      schedulelist = source;
    }
  }
}
class _DataSource extends CalendarDataSource {
  List<Schedule> schedulelist = new List<Schedule>();
  Future fetchSchedules() async {
    final uri = Uri.http(global.ip, '/shifts');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);

    //setState(() {
      schedulelist = (json.decode(response.body) as List).map((i) =>
          Schedule.fromJson(i)).toList();
      // for (int i = 0; i < schedulelist.length; i++)
        // _isExpanded.add(false);
    //}

    print(json.encode(schedulelist[0]));
  }
  _DataSource(List<Schedule> source) {
    schedulelist = source;
  }

  // @override
  // bool isAllDay(int index) => schedulelist[index].isAllDay;

  @override
  String getSubject(int index) => schedulelist[index].assignedTo;

  // @override
  // String getStartTimeZone(int index) => appointments[index].startTimeZone;

  // @override
  // String getNotes(int index) => appointments[index].description;

  // @override
  // String getEndTimeZone(int index) => appointments[index].endTimeZone;

  // @override
  // Color getColor(int index) => schedulelist[index].color;

  @override
  DateTime getStartTime(int index) {
    var startTime = new DateTime.fromMicrosecondsSinceEpoch(int.parse(schedulelist[index].startTime));
    return startTime;
  }


  @override
  DateTime getEndTime(int index) {
    var endTime = new DateTime.fromMicrosecondsSinceEpoch(int.parse(schedulelist[index].endTime));
    return endTime;
  }

}
class Meeting {
  Meeting(
      {@required this.from,
        @required this.to,
        this.background = Colors.green,
        this.isAllDay = false,
        this.eventName = '',
        this.startTimeZone = '',
        this.endTimeZone = '',
        this.description = ''});

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String startTimeZone;
  final String endTimeZone;
  final String description;
}



