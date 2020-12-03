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
import 'package:item_selector/item_selector.dart';
import 'Schedule.dart';
import 'package:intl/intl.dart';

class eSchedule extends StatefulWidget {
  @override
  _eScheduleState createState() => _eScheduleState();
}

class _eScheduleState extends State<eSchedule> with TickerProviderStateMixin {
  String user_id = "";
  List<Schedule> userSlist = new List<Schedule>();

  List<Schedule> otherlist = new List<Schedule>();
  bool flag = true;

  List<bool> _isExpanded = new List<bool>();
  AnimationController _controller;
  Animation<double> _animation;
  int ui = -1;
  int oi = -1;


  Future fetchShifts_user() async{

    final uri = Uri.http(global.ip, '/shifts/' + user_id);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);

    setState(() {
      userSlist=(json.decode(response.body) as List).map((i) =>
          Schedule.fromJson(i)).toList();
    });


    print(json.encode(userSlist[0]));


  }

  Future fetchShifts_other() async{

    final uri = Uri.http(global.ip, '/shiftsOther/' + user_id);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);

    setState(() {
      otherlist=(json.decode(response.body) as List).map((i) =>
          Schedule.fromJson(i)).toList();
    });


    print(json.encode(otherlist[0]));


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
      fetchShifts_user();
      fetchShifts_other();
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
      fetchShifts_user();
      fetchShifts_other();
    }



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Schedule", style: GoogleFonts.josefinSans(textStyle: TextStyle(foreground: Paint()..shader = linearGradient, fontSize: 25, fontWeight: FontWeight.bold))),

      ),
      resizeToAvoidBottomInset: false, // set it to false
      body:  RefreshIndicator(
          onRefresh: () => _handleRefresh(),

          child: Row(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: yourShifts(),),
              Expanded(child: otherShifts(),),
              Expanded(child: trades(),),
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

  Widget yourShifts(){

    int item_count = userSlist.length;
    return ItemSelectionController(
      child: ListView(
       // scrollDirection: Axis.horizontal,

          shrinkWrap: true,
        children: List.generate(item_count+1, (int index) {
          return ItemSelectionBuilder(
            index: index,
            builder: (BuildContext context, int index, bool selected) {
              if(index == 0){
                return Center(
                  child: Container(
                      margin: EdgeInsets.only(top:10),
                      child: Text("Your Shifts",
                      style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.purple))))

                );
              }
              index-= 1;
              if(selected) ui = index;
              DateTime sdate = new DateTime.fromMillisecondsSinceEpoch(int.parse(userSlist[index].startTime));
              DateTime edate = new DateTime.fromMillisecondsSinceEpoch(int.parse(userSlist[index].endTime));

              var format = new DateFormat("y-M-d hh:mm");

              return Center(
                child: Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width * 0.3,
                  margin: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
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
                        colors: [
                          selected?Colors.purple:Color(0xfffaac7b),
                          Color(0xfff74c83)

                        ]),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[SizedBox(height: 5,),
                      Text("You" ,
                          style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white))),
                      SizedBox(height: 3,),
                     Text( format.format(sdate),
                          style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white))),
                      SizedBox(height: 3,),
                      Text("to",
                          style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white70))),
                      SizedBox(height: 3,),
                      Text(format.format(edate),
                            style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white))),

                      SizedBox(height: 5,)
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget otherShifts(){

    int item_count = otherlist.length;
    return ItemSelectionController(
      child: ListView(
        // scrollDirection: Axis.horizontal,

        shrinkWrap: true,
        children: List.generate(item_count+1, (int index) {
          return ItemSelectionBuilder(
            index: index,
            builder: (BuildContext context, int index, bool selected) {


              if(index == 0){
                return Center(
                    child: Container(
                        margin: EdgeInsets.only(top:10),
                        child: Text("Other Shifts",
                            style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.deepPurple))))

                );
              }
              index-= 1;

              DateTime sdate = new DateTime.fromMillisecondsSinceEpoch(int.parse(otherlist[index].startTime));
              DateTime edate = new DateTime.fromMillisecondsSinceEpoch(int.parse(otherlist[index].endTime));

              var format = new DateFormat("y-M-d hh:mm");


              if(selected) oi = index;
              return Center(
                child: Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width * 0.3,
                  margin: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
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
                        colors: [
                          selected?Colors.purple:Color(0xfffaac7b),
                          Color(0xfff74c83)

                        ]),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[SizedBox(height: 5,),
                      Text(otherlist[index].assignedTo.toString() ,
                          style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white))),
                      SizedBox(height: 3,),
                      Text( format.format(sdate),
                          style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white))),
                      SizedBox(height: 3,),
                      Text("to",
                          style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white70))),
                      SizedBox(height: 3,),
                      Text(format.format(edate),
                          style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white))),

                      SizedBox(height: 5,)
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget trades(){

    int item_count = userSlist.length;
    return ItemSelectionController(
      child: ListView(
        // scrollDirection: Axis.horizontal,

        shrinkWrap: true,
        children: List.generate(item_count+1, (int index) {
          return ItemSelectionBuilder(
            index: index,
            builder: (BuildContext context, int index, bool selected) {
              if(index == 0){
                return Center(
                    child: Container(
                        margin: EdgeInsets.only(top:10),
                        child: Text("Trades",
                            style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.purple))))

                );
              }
              index-= 1;
              if(selected) ui = index;
              DateTime sdate = new DateTime.fromMillisecondsSinceEpoch(int.parse(userSlist[index].startTime));
              DateTime edate = new DateTime.fromMillisecondsSinceEpoch(int.parse(userSlist[index].endTime));

              var format = new DateFormat("y-M-d hh:mm");

              return Center(
                child: Container(
                  height: 212,
                  width: MediaQuery.of(context).size.width * 0.3,
                  margin: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
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
                        colors: [
                          selected?Colors.purple:Color(0xfffaac7b),
                          Color(0xfff74c83)

                        ]),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[SizedBox(height: 5,),
                      Text("You" ,
                          style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white))),
                      SizedBox(height: 3,),
                      Text( format.format(sdate),
                          style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white))),
                      SizedBox(height: 3,),
                      Text("to",
                          style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white70))),
                      SizedBox(height: 3,),
                      Text(format.format(edate),
                          style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white))),
                      Divider(
                          color: Colors.white
                      ),
                      Text("You" ,
                          style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white))),
                      SizedBox(height: 3,),
                      Text( format.format(sdate),
                          style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white))),
                      SizedBox(height: 3,),
                      Text("to",
                          style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white70))),
                      SizedBox(height: 3,),
                      Text(format.format(edate),
                          style: GoogleFonts.josefinSans( textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white))),
                      Divider(
                          color: Colors.white
                      ),
                      FlatButton(
                          child: Text("Accept", style: TextStyle(color: Colors.white)),

                          color: Colors.green,
                          onPressed: (){
                            print(ui);
                            print(oi);
                          },
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                      ),
                      SizedBox(height: 5,)
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

}



