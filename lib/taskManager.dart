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

class TaskManager extends StatefulWidget {
  @override
  _TaskManagerState createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> with TickerProviderStateMixin {
  String user_id = "";
  List<Task> tasklist = new List<Task>();
  bool flag = true;
  List<bool> _isExpanded = new List<bool>();
  AnimationController _controller;
  Animation<double> _animation;

  Future fetchTasks() async{

    final uri = Uri.http(global.ip, '/tasks');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);


    setState(() {
      tasklist=(json.decode(response.body) as List).map((i) =>
          Task.fromJson(i)).toList();
      for(int i=0; i<tasklist.length;i++) _isExpanded.add(false);
    });
    print(json.encode(tasklist[0]));

  }
  Future deleteTask(String taskid) async{

    final uri = Uri.http(global.ip, '/deleteTask/'+taskid);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(uri, headers: headers);


    setState(() {
      fetchTasks();
    });
    print(response);
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

    _controller.forward();
    super.initState();
  }

  Future<void> _handleRefresh() async
  {
    await fetchTasks();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    user_id = ModalRoute.of(context).settings.arguments;
    if(flag){
      flag = false;
      fetchTasks();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Task Manager", style: GoogleFonts.josefinSans()),
        actions: <Widget>[FlatButton(
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(2.0),
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
            style: GoogleFonts.josefinSans( textStyle: TextStyle(fontSize: 16.0)),
          ),
        )],
      ),
      body: RefreshIndicator(
          child: _myListView(this),
          onRefresh: () => _handleRefresh(),
      ),
      //navigation bar to switch to scheduling
      bottomNavigationBar: new Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Expanded(
                //Task button - bold font and darker
                child: MaterialButton(
                    textColor: Colors.white,
                    height: 60,
                    color: Color(0xfee50a80),
                    onPressed: () {
                      //nothing
                    },
                    child: Text('Tasks',
                      style: GoogleFonts.josefinSans(textStyle: TextStyle(fontSize: 18 )),
                      textAlign: TextAlign.center),
                ),
              ),
              Expanded(
                //Scheduling button - normal font and lighter
                child: MaterialButton(
                  textColor: Colors.white,
                  color: Color(0xfff3a2755),
                  height: 60,
                  onPressed: () { //navigate to scheduling widget
                    Navigator.of(context)
                        .pushReplacementNamed(
                      "scheduler",
                      // we are passing a value to the settings page

                    );
                  },
                  child: Text('Schedules', style: GoogleFonts.josefinSans(textStyle: TextStyle(fontSize: 18)),textAlign: TextAlign.center),
                ),
              ),
            ],
          )
      ),
    );
  }



  Widget _myListView(TickerProvider tp) {
    return ListView.builder(
      padding: EdgeInsets.all(15),
      itemCount: tasklist.length,
      itemBuilder: (context, taskindex) {
        final Task item = tasklist[taskindex];
        return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.startToEnd,
            background: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 20),
                    Icon(Icons.delete, color: Colors.red, size: 65)
                    ],
                  ),
                ),
              ),
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Delete Confirmation"),
                    content: const Text("Are you sure you want to delete this item?"),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Delete")
                      ),
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancel"),
                        ),
                    ],
                  );
                  },
                );
                },
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.startToEnd) {
                    deleteTask(tasklist[taskindex].sId);
                    print("Deleted");
                    }
                  },
                child:

          Center(
          child: Container(
            margin: const EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
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
              ],
            ),
            padding: EdgeInsets.all(10.0),
            child: Column(

              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: SizedBox(),
                  title: Center(child: Text(tasklist[taskindex].title,
                      style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white)))),
                  trailing: IconButton(
                    icon: _isExpanded[taskindex]?Icon(Icons.arrow_upward_rounded):Icon(Icons.arrow_downward_rounded),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        _isExpanded[taskindex]= !_isExpanded[taskindex];

                      });
                    },
                  )
                ),
                AnimatedSize(
                    vsync: tp,
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,

                  child: Container(
                    child: Container(
                        child: !_isExpanded[taskindex]
                            ? null
                            : FadeTransition(opacity: _animation,
                            child: Column(children: [
                Container(
                    padding: EdgeInsets.all(8.0),
                    child: Center( child: Text(tasklist[taskindex].description,
                        style: GoogleFonts.josefinSans( textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70))
                    ))
                ),
                ListTile(
                  leading: Icon(Icons.assignment_ind),
                  title: Text("Assigned:",style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white))),
                  trailing: Text(tasklist[taskindex].assigned,style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white))),
                ),
                _mySubTasks(taskindex)]))))),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: new LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 80,
                    animation: true,
                    lineHeight: 20.0,
                    animationDuration: 2000,
                    percent: percent(taskindex),
                    center: Text((percent(taskindex)*100).toStringAsFixed(2)+"%"),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.greenAccent,
                  ),
                )
              ],
            ),
          ),
        ));
      },
    );
  }

  double percent(x){
    int total = 0;
    for(int i=0; i<tasklist[x].subTasks.length;i++){
      if(tasklist[x].subTasks[i].completed) total++;
    }
    return total/tasklist[x].subTasks.length;
  }

  Widget _mySubTasks(x) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: tasklist[x].subTasks.length,
      itemBuilder: (context, index) {
        final SubTasks item = tasklist[x].subTasks[index];
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
              child: CheckboxListTile(

                title: Text(tasklist[x].subTasks[index].stDesc,  style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xfff74c66)))),
                value: tasklist[x].subTasks[index].completed,
                onChanged: null,
              ),
            )
        );
      },
    );
  }
}







