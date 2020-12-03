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

  Future<void> _handleRefresh() async
  {
    await fetchSchedules();
    setState(() {

    });
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
                   ).then((value){
                     fetchSchedules();
                   });
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
      body: RefreshIndicator(
    child: SfCalendar(
        headerHeight: 60,
        viewHeaderHeight: 50,
        view: CalendarView.month,
        showDatePickerButton: true,
        allowedViews: <CalendarView>
        [
          CalendarView.week
        ],
        controller: _calendarController,
        dataSource: _calendarDataSource(),
      ),
        onRefresh: () => _handleRefresh(),
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
    final List<Appointment> appointments = <Appointment>[];

    for(int i=0; i<schedulelist.length;i++){
      print(DateTime.fromMillisecondsSinceEpoch(int.parse(schedulelist[i].startTime)*1000));
      print(DateTime.fromMillisecondsSinceEpoch(int.parse(schedulelist[i].endTime)));
      appointments.add(Appointment(
        startTime: new DateTime.fromMillisecondsSinceEpoch(int.parse(schedulelist[i].startTime)),
        endTime: new DateTime.fromMillisecondsSinceEpoch(int.parse(schedulelist[i].endTime)),
        subject: schedulelist[i].assignedTo,
        color: Colors.blue
      ));
    }

    return _DataSource(appointments);
  }



}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}




