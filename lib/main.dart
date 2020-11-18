import 'package:flutter/material.dart';
import 'package:flutterapp/sample_browser.dart';
import 'signIn.dart';
import 'taskManager.dart';
import 'addTask.dart';
import 'eView.dart';

void main () {

  runApp(
      MaterialApp(
        home: SignIn(),
        routes: {
      "signIn": (BuildContext signInContext) => SignIn(),
      "taskManager": (BuildContext taskManagerContext) => TaskManager(),
          "addTask": (BuildContext taskManagerContext) => AddTask(),
          "mschedule": (BuildContext taskManagerContext) => SampleBrowser(),
          "eView": (BuildContext eViewContext) => EmployeeView()
      },
        initialRoute: "home",
      )
  );

}