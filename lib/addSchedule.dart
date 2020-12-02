import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'globals.dart' as global;
import 'package:google_fonts/google_fonts.dart';
import 'SubTasks.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
class AddSchedule extends StatefulWidget {
  @override
  _AddScheduleState createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {

  String user_id = "";
  final _formKey = GlobalKey<FormState>();
  List<User> userlist;
  List<String> usernamelist;
  String dropdownValue = "";
  bool flag = true;
  List<TextEditingController> subTasks = new List<TextEditingController>();

  double _height;
  double _width;

  String _setTime, _setDate;
  String _setTime2, _setDate2;

  String _hour, _minute, _time;
  String _hour2, _minute2, _time2;

  String dateTime;
  String dateTime2;

  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedTime2 = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  TextEditingController _dateController2 = TextEditingController();
  TextEditingController _timeController2 = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate2,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate2 = picked;
        _dateController2.text = DateFormat.yMd().format(selectedDate2);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  Future<Null> _selectTime2(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime2,
    );
    if (picked != null)
      setState(() {
        selectedTime2 = picked;
        _hour2 = selectedTime2.hour.toString();
        _minute2 = selectedTime2.minute.toString();
        _time2 = _hour2 + ' : ' + _minute2;
        _timeController2.text = _time2;
        _timeController2.text = formatDate(
            DateTime(2019, 08, 1, selectedTime2.hour, selectedTime2.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    usernamelist = new List<String>();
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _dateController2.text = DateFormat.yMd().format(DateTime.now());
    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();

    _timeController2.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  Future fetchUsers() async{
    final uri = Uri.http(global.ip, '/users');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);
      usernamelist.clear();
      userlist=(json.decode(response.body) as List).map((i) =>
          User.fromJson(i)).toList();
      for(int i=0; i< userlist.length; i++){
        usernamelist.add(userlist[i].username);
      }
      print(usernamelist);
      dropdownValue = usernamelist[0];

    setState(() {
    });


  }

  Future postSchedule(BuildContext context) async{

    if(subTasks[0].text == ""){
      return;}
    List<SubTasks> st_list = new List<SubTasks>();
    for(int i=0;i<subTasks.length;i++){
      SubTasks temp = new SubTasks();
      temp.stDesc = subTasks[i].text;
      temp.completed = false;
      st_list.add(temp);
    }

    final body = {
      'subTasks': st_list,
      'status': 'incomplete',
      'assigned': dropdownValue
    };

    final jsonString = json.encode(body);
    final uri = Uri.http(global.ip, '/addTask');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    print(json.encode(st_list));
    print(jsonString);
    final response = http.post(uri, headers: headers, body: jsonString);

    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    user_id = ModalRoute.of(context).settings.arguments;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());

    dateTime2 = DateFormat.yMd().format(DateTime.now());

    if(flag){
      fetchUsers();

      subTasks.add(new TextEditingController());
      print(subTasks.length.toString());
      flag = false;
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            color: Colors.purple
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Add New Shift", style: GoogleFonts.josefinSans(textStyle: TextStyle(foreground: Paint()..shader = linearGradient, fontSize: 25, fontWeight: FontWeight.bold))),

      ),
      body: Builder( builder: (context) => Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Start", style: GoogleFonts.josefinSans(textStyle: TextStyle(foreground: Paint()..shader = linearGradient, fontSize: 20, fontWeight: FontWeight.bold))),
                Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Container(
                        width: _width / 3.4,
                        height: _height / 18,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: TextFormField(
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _dateController,
                          onSaved: (String val) {
                            _setDate = val;
                          },
                          decoration: InputDecoration(
                              disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                              // labelText: 'Time',
                              contentPadding: EdgeInsets.only(top: 0.0)),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: Container(
                        width: _width / 3.4,
                        height: _height / 18,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: TextFormField(
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          onSaved: (String val) {
                            _setTime = val;
                          },
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _timeController,
                          decoration: InputDecoration(
                              disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                              // labelText: 'Time',
                              contentPadding: EdgeInsets.all(5)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(
              height: 20
            ),
// ---------------------------------------------End Date Time ---------------------------------------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("End", style: GoogleFonts.josefinSans(textStyle: TextStyle(foreground: Paint()..shader = linearGradient, fontSize: 20, fontWeight: FontWeight.bold))),
                Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _selectDate2(context);
                      },
                      child: Container(
                        width: _width / 3.4,
                        height: _height / 18,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: TextFormField(
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _dateController2,
                          onSaved: (String val) {
                            _setDate2 = val;
                          },
                          decoration: InputDecoration(
                              disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                              // labelText: 'Time',
                              contentPadding: EdgeInsets.only(top: 0.0)),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _selectTime2(context);
                      },
                      child: Container(
                        width: _width / 3.4,
                        height: _height / 18,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: TextFormField(
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          onSaved: (String val) {
                            _setTime2 = val;
                          },
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _timeController2,
                          decoration: InputDecoration(
                              disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                              // labelText: 'Time',
                              contentPadding: EdgeInsets.all(5)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(
                height: 20
            ),

            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                    ),
                    Text('Assign To:',
                        style: GoogleFonts.josefinSans(textStyle: TextStyle(foreground: Paint()..shader = linearGradient,  fontWeight: FontWeight.bold, fontSize: 20)),
                        textAlign: TextAlign.center),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: GoogleFonts.josefinSans(textStyle: TextStyle(fontSize: 20 ), color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: usernamelist
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                          .toList() ?? null,
                    ),
                    SizedBox(
                    )
                  ],
                )
            ),


          ],
        ),
      )),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0)
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
            ]

        ),
        child: FlatButton(
          color: Colors.transparent,
          onPressed: () {
            print(_dateController2.text);
            print(_timeController2.text);
          },
          child: Text('Submit', style: GoogleFonts.josefinSans(textStyle: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold))),
        ),
      ) ,
    );
  }


}


class User {
  String sId;
  String username;
  String password;
  String type;

  User({this.sId, this.username, this.password, this.type});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    password = json['password'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['password'] = this.password;
    data['type'] = this.type;
    return data;
  }
}

