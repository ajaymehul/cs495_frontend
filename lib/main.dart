import 'package:flutter/material.dart';
import 'package:flutterapp/sample_browser.dart';
import 'signIn.dart';
import 'taskManager.dart';
import 'addTask.dart';
import 'eView.dart';
import 'scheduleViewer.dart';


void main () {

  runApp(
      MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xfff3a2755),
          accentColor: Color(0xfffaac7b)
        ),
        home: SignIn(),
        routes: {
          "signIn": (BuildContext signInContext) => SignIn(),
          "taskManager": (BuildContext taskManagerContext) => TaskManager(),
          "addTask": (BuildContext taskManagerContext) => AddTask(),
          "mschedule": (BuildContext taskManagerContext) => SampleBrowser(),
          "eView": (BuildContext eViewContext) => EmployeeView(),
          "scheduler" : (BuildContext schedulerContext) => Scheduler()
      },
        initialRoute: "home",
      )
  );

}