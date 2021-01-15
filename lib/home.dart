import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import 'stats.dart';
import 'vaccine_stats.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title = ""}) : super(key: key);
  final String title;
  Future<Stats> _futureStatistics;
  Future<VaccineStats> _futureVaccineStatistics;

  _launchURLApp() async {
    const url = 'https://github.com/pcm-dpc/COVID-19';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURLCommisssarioApp() async {
    const url = ' https://github.com/italia/covid19-opendata-vaccini';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    _futureStatistics = fetchData();
    _futureVaccineStatistics = fetchVaccineData();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                child:
                    Text('Qualche statistica', style: TextStyle(fontSize: 24))),
            Spacer(flex: 1),
            FutureBuilder<VaccineStats>(
                future: _futureVaccineStatistics,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Vaccinati: ',
                              children: <TextSpan>[
                                TextSpan(
                                    text: NumberFormat.compact(locale: "it_IT")
                                            .format(snapshot
                                                .data.dosiSomministrate) +
                                        ' (${snapshot.data.fracPopolazione.toStringAsFixed(2)}% della popolazione)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                        fontSize: 20))
                              ])),
                        ]);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            FutureBuilder<Stats>(
              future: _futureStatistics,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text.rich(TextSpan(
                            text: 'Nuovi positivi: ',
                            children: <TextSpan>[
                              TextSpan(
                                  text: '${snapshot.data.nuoviPositivi}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 20))
                            ])),
                        Text.rich(TextSpan(
                            text: 'Terapie intensive: ',
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      '${snapshot.data.terapiaIntensiva} (${snapshot.data.deltaTerapiaIntensiva})',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontSize: 20))
                            ])),
                        Text.rich(
                            TextSpan(text: 'Ricoverati: ', children: <TextSpan>[
                          TextSpan(
                              text:
                                  '${snapshot.data.ricoverati} (${snapshot.data.deltaRicoverati})',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 20))
                        ])),
                        Text.rich(TextSpan(
                            text: 'Totale positivi: ',
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      '${snapshot.data.totalePositivi} (${snapshot.data.totalePositivi - snapshot.data.previousTotalePositivi})',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 20))
                            ])),
                        Text.rich(
                            TextSpan(text: 'Deceduti: ', children: <TextSpan>[
                          TextSpan(
                              text:
                                  '${snapshot.data.deceduti} (${snapshot.data.deltaDeceduti})',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20))
                        ])),
                        Text.rich(
                            TextSpan(text: 'Tamponi: ', children: <TextSpan>[
                          TextSpan(
                              text: '${snapshot.data.tamponi}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 20))
                        ])),
                        Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text.rich(
                                TextSpan(text: 'Frazione tamponi positivi: ')),
                            Text.rich(TextSpan(
                                text:
                                    '${snapshot.data.frazioneTamponi.toStringAsFixed(1)} % (${snapshot.data.deltaFrazioneTamponi.toStringAsFixed(1)} %)',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 20)))
                          ],
                        ),
                        Text.rich(TextSpan(
                            text: 'Ultimo aggiornamento: ',
                            children: <TextSpan>[
                              TextSpan(
                                  text: '${snapshot.data.data}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 20))
                            ])),
                        //Spacer(flex:1),
                      ]);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
            Spacer(flex: 1),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Sources: ",
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 6),
                  textAlign: TextAlign.center),
              GestureDetector(
                  onTap: _launchURLApp,
                  child: Text(
                      "Sito del Dipartimento della Protezione Civile \n Emergenza Coronavirus: la risposta nazionale",
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontSize: 6),
                      textAlign: TextAlign.left)),
              GestureDetector(
                  onTap: _launchURLCommisssarioApp,
                  child: Text(
                      "2021 (c) Commissario straordinario per l'emergenza Covid-19 \n Presidenza del Consiglio dei Ministri.",
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontSize: 6),
                      textAlign: TextAlign.left))
            ]),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
