import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'scheduleViewer.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'globals.dart' as global;
import 'Task.dart';
import 'SubTasks.dart';

class eSchedule extends StatefulWidget {
  @override
  _eScheduleState createState() => _eScheduleState();
}

class _eScheduleState extends State<eSchedule> with TickerProviderStateMixin {
  String user_id = "";
  List<Task> tasklist;
  bool flag = true;

  List<bool> _isExpanded = new List<bool>();
  AnimationController _controller;
  Animation<double> _animation;


  Future fetchTasks() async{

    final uri = Uri.http(global.ip, '/tasks/' + user_id);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);

    setState(() {
      tasklist=(json.decode(response.body) as List).map((i) =>
          Task.fromJson(i)).toList();
      for(int i=0; i<tasklist.length;i++) _isExpanded.add(false);
    });
    print(json.encode(tasklist[0]));

  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this,
        value: 1,
        lowerBound: 0,
        upperBound: 1
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
    super.initState();
  }

  Future<void> _handleRefresh() async
  {
    setState(() {

    });
  }


  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    user_id = ModalRoute.of(context).settings.arguments;
    if(flag){
      flag = false;
      fetchTasks();
    }



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Schedule", style: GoogleFonts.josefinSans(textStyle: TextStyle(foreground: Paint()..shader = linearGradient, fontSize: 25, fontWeight: FontWeight.bold))),

      ),
      body: RefreshIndicator(
          onRefresh: () => _handleRefresh(),
          child: Column(
            children: [
              //for trade requests
              Row(),
              //three columns: your shifts, other shifts, pending requests
              Row(),
            ],
          )
      ),
      //navigation bar to switch to scheduling
      bottomNavigationBar: new Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
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
                  )
              ),
              Expanded(
                //Task button - bold font and darker
                child: FlatButton(
                  textColor: Colors.white,
                  height: 60,

                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(
                      "eView",
                      arguments: user_id,
                    );
                  },
                  child: Text('Tasks',
                      style: GoogleFonts.josefinSans(textStyle: TextStyle(foreground: Paint()..shader = linearGradient, fontSize: 24, fontWeight: FontWeight.bold )),
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
                    Navigator.of(context)
                        .pushReplacementNamed(
                      "scheduler",
                      // we are passing a value to the settings page

                    );
                  },
                  child: Text('Schedules', style: GoogleFonts.josefinSans(foreground: Paint()..shader = linearGradient, fontSize: 18, fontWeight: FontWeight.w500),textAlign: TextAlign.center),
                ),
              ),
            ],
          )
      ),
    );
  }







}



