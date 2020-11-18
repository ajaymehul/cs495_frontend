import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'eTaskManager.dart';

class EmployeeView extends StatefulWidget {
  @override
  _eViewState createState() => _eViewState();
}

class _eViewState extends State<EmployeeView> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Task List"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(14.0),
              height: 300,
              width: 300,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(width: 5, color: Colors.teal[200])),
                child: Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 30, top: 30),
                          child: Text(
                            'Name : Bob Marley',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text('Role : Morning Cashier',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    )),
              ),
            ),
            Card(
              color: Colors.teal[200],
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  print('Card tapped.');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => eTaskList()),
                  );
                },
                child: Container(
                  width: 300,
                  height: 100,
                  padding: EdgeInsets.all(30.0),
                  child: Text(
                    'Pending Tasks',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
            Card(
              color: Colors.teal[200],
              child: InkWell(
                splashColor: Colors.yellow[100].withAlpha(30),
                onTap: () {
                  print('Card tapped.');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => eTaskList()),
                  );
                },
                child: Container(
                  width: 300,
                  height: 100,
                  padding: EdgeInsets.all(30.0),
                  child: Text(
                    'Completed Tasks',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

