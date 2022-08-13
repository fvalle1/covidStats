import 'package:dati_italia/InfoPage.dart';
import 'package:flutter/cupertino.dart';

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
    return CupertinoApp(
      title: 'Italia OpenData pandemia',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemPurple,
        barBackgroundColor: CupertinoColors.systemGrey,
        scaffoldBackgroundColor: CupertinoColors.white,
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
        'https://developer.fvalle.online/appcast.xml';
    final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          middle: const Text("COVID-19 dati"),
        ),
        child: CupertinoTabScaffold(
          tabBuilder: (context, _selectedIndex) => UpgradeAlert(
            appcastConfig: cfg,
            debugLogging: true,
            countryCode: 'it',
            child: _pagesOptions.elementAt(_selectedIndex),
          ),
          tabBar: CupertinoTabBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chart_bar),
                label: 'Grafici',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.map),
                label: 'Regioni',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.info),
                label: 'Info',
              )
            ],
            currentIndex: _selectedIndex,
            activeColor: CupertinoColors.systemPurple,
            backgroundColor: CupertinoColors.white,
            onTap: _onBottomBarTap,
          ),
        ));
  }
}
