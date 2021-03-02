import 'package:flutter/material.dart';

import 'home.dart';
import 'plotPage.dart';
import 'regionalPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Italy Covid Stats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyView(),
    );
  }
}

class MyView extends StatefulWidget {
  MyView({Key key}) : super(key: key);

  @override
  _MyViewState createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  int _selectedIndex = 0;

  void _onBottomBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _pagesOptions = [
    MyHomePage(title: 'Main Statistics'),
    MyPlotPage(title: "Trends"),
    MyRegionalPage(title: "Regional")
  ];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("COVID-19 stats"),
      ),
      body: _pagesOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Plots',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Regional',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[300],
        onTap: _onBottomBarTap,
      ),
    );
  }
}
