import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'stats.dart';


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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      Text.rich(TextSpan(text: 'Nuovi positivi: ', children: <TextSpan>[TextSpan(text: '${snapshot.data.nuoviPositivi}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize:20))])),
                      Text.rich(TextSpan(text: 'Terapie intensive: ', children: <TextSpan>[TextSpan(text: '${snapshot.data.terapiaIntensiva} (${snapshot.data.deltaTerapiaIntensiva})', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize:20))])),
                      Text.rich(TextSpan(text: 'Ricoverati: ', children: <TextSpan>[TextSpan(text: '${snapshot.data.ricoverati} (${snapshot.data.deltaRicoverati})', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize:20))])),
                      Text.rich(TextSpan(text: 'Totale positivi: ', children: <TextSpan>[TextSpan(text: '${snapshot.data.totalePositivi} (${snapshot.data.totalePositivi-snapshot.data.previousTotalePositivi})', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize:20))])),
                      Text.rich(TextSpan(text: 'Deceduti: ', children: <TextSpan>[TextSpan(text: '${snapshot.data.deceduti} (${snapshot.data.deltaDeceduti})', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize:20))])),
                      Text.rich(TextSpan(text: 'Tamponi: ', children: <TextSpan>[TextSpan(text: '${snapshot.data.tamponi}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize:20))])),
                      Wrap(
                        direction: Axis.horizontal,
                        children: [
                        Text.rich(TextSpan(text: 'Frazione tamponi positivi: ')),
                        Text.rich(TextSpan(text: '${snapshot.data.frazioneTamponi.toStringAsFixed(1)} % (${snapshot.data.deltaFrazioneTamponi.toStringAsFixed(1)} %)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize:20)))
                      ],),
                      Text.rich(TextSpan(text: 'Ultimo aggiornamento: ', children: <TextSpan>[TextSpan(text: '${snapshot.data.data}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize:20))])),
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
