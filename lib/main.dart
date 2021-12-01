import 'package:dati_italia/InfoPage.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'plotPage.dart';
import 'regionalPage.dart';
import 'package:upgrader/upgrader.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Italia OpenData pandemia',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyView(),
    );
  }
}

class MyView extends StatefulWidget {
  MyView({Key? key, this.title}) : super(key: key);

  late final String? title;

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
    MyHomePage(title: "Home"),
    MyPlotPage(title: "Trends (moving average)"),
    MyRegionalPage(title: "Regioni"),
    InfoPage()
  ];

  @override
  Widget build(BuildContext context) {
    final appcastURL =
        'https://filippov-hko4rv9s2jb-apigcp.nimbella.io/api/covidStats/getVersion';
    final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("COVID-19 dati"),
      ),
      body: UpgradeAlert(
        appcastConfig: cfg,
        debugLogging: true,
        countryCode: 'it',
        child: _pagesOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Grafici',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Regioni',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          )
        ],
        currentIndex: _selectedIndex,
        //fixedColor: Colors.purple,
        selectedItemColor: Colors.purple[900],
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.grey[200],
        onTap: _onBottomBarTap,
      ),
    );
  }
}
