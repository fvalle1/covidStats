import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'stats.dart';

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
      home: MyHomePage(title: 'COVID-19 stats'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Stats> _futureStatistics;


  _launchURLApp() async {
    const url = 'https://github.com/pcm-dpc/COVID-19';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState(){
    super.initState();
    _futureStatistics = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
          Container(
            child: Text(
              'Here some statistics',
              style: TextStyle(
                fontSize: 24
                )
            )
            ),
            Spacer(flex:1),
            FutureBuilder<Stats>(
                future: _futureStatistics,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                      [
                      Text.rich(TextSpan(text: 'Nuovi positivi: ', children: <TextSpan>[TextSpan(text: '${snapshot.data.nuovi_positivi}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize:18))])),
                      Text.rich(TextSpan(text: 'Terapie intensive: ', children: <TextSpan>[TextSpan(text: '${snapshot.data.terapia_intensiva}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize:18))])),
                      Text.rich(TextSpan(text: 'Totale positivi: ', children: <TextSpan>[TextSpan(text: '${snapshot.data.totale_positivi}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize:18))])),
                      Text.rich(TextSpan(text: 'Deceduti: ', children: <TextSpan>[TextSpan(text: '${snapshot.data.deceduti}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize:18))])),
                      Text.rich(TextSpan(text: 'Tamponi: ', children: <TextSpan>[TextSpan(text: '${snapshot.data.tamponi}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize:18))])),
                      Text.rich(TextSpan(text: 'Frazione tamponi: ', children: <TextSpan>[TextSpan(text: '${snapshot.data.frazione_tamponi.toStringAsFixed(2)} %', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize:18))])),
                      //Spacer(flex:1),
                      ]
                      );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              ),
            Spacer(flex:1),
            Row(
              children:[
              GestureDetector(
                onTap: _launchURLApp,
                child: Text("Source: Sito del Dipartimento della Protezione Civile \n Emergenza Coronavirus: la risposta nazionale",
                            maxLines: 3,
                            softWrap: true,
                            overflow: TextOverflow.clip,
                            style: TextStyle(fontSize:12),
                            )
                )
              ]
              ),
            Spacer(flex:1),
          ],
        ),
      ),
    );
  }
}
