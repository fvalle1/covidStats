import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import 'stats.dart';
import 'vaccineStats.dart';
import 'passStat.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, this.title = "Home"}) : super(key: key);
  late final String title;
  late final Future<Stats>? _futureStatistics;
  late final Future<VaccineStats>? _futureVaccineStatistics;
  late final Future<PassStats>? _futurePassStatistics;

  _launchURLApp() async {
    const url = 'https://github.com/pcm-dpc/COVID-19';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURLCommisssarioApp() async {
    const url = 'https://github.com/italia/covid19-opendata-vaccini';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURLMinSaluteApp() async {
    const url = 'https://github.com/ministero-salute';
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
    _futurePassStatistics = fetchPassData();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                child: Text('Statistiche', style: TextStyle(fontSize: 22))),
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
                                                .data?.personeVaccinate) +
                                        ' (${snapshot.data?.fracPopolazione.toStringAsFixed(2)}% della popolazione)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                        fontSize: 18))
                              ])),
                          Text.rich(TextSpan(
                              text: 'Dosi somministrate: ',
                              children: <TextSpan>[
                                TextSpan(
                                    text: NumberFormat.compact(locale: "it_IT")
                                        .format(
                                            snapshot.data?.dosiSomministrate),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                        fontSize: 18))
                              ])),
                          Text.rich(TextSpan(
                              text: 'Booster somministrati: ',
                              children: <TextSpan>[
                                TextSpan(
                                    text: NumberFormat.compact(locale: "it_IT")
                                        .format(snapshot.data?.dosiAggiuntive),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                        fontSize: 18))
                              ])),
                        ]);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            FutureBuilder<PassStats>(
                future: _futurePassStatistics,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Green pass emessi: ',
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        '${NumberFormat.compact(locale: "it_IT").format(snapshot.data?.totalPassEmessi)} (+${NumberFormat.compact(locale: "it_IT").format(snapshot.data?.passEmessi)} da ieri)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[900],
                                        fontSize: 18))
                              ]))
                        ]);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
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
                                  text: '${snapshot.data?.nuoviPositivi}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 18))
                            ])),
                        Text.rich(TextSpan(
                            text: 'Terapie intensive: ',
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      '${snapshot.data?.terapiaIntensiva} (${(snapshot.data!.deltaRicoverati! > 0) ? "+" : ""}${snapshot.data?.deltaTerapiaIntensiva} da ieri)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontSize: 18))
                            ])),
                        Text.rich(
                            TextSpan(text: 'Ricoverati: ', children: <TextSpan>[
                          TextSpan(
                              text:
                                  '${snapshot.data?.ricoverati} (${(snapshot.data!.deltaRicoverati! > 0) ? "+" : ""}${snapshot.data?.deltaRicoverati} da ieri)',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 18))
                        ])),
                        Text.rich(TextSpan(
                            text: 'Totale positivi: ',
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      '${snapshot.data?.totalePositivi} (${(snapshot.data!.totalePositivi! > snapshot.data!.previousTotalePositivi!) ? "+" : ""}${snapshot.data!.totalePositivi! - snapshot.data!.previousTotalePositivi!} da ieri)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 18))
                            ])),
                        Text.rich(
                            TextSpan(text: 'Deceduti: ', children: <TextSpan>[
                          TextSpan(
                              text:
                                  '${snapshot.data?.deceduti} (ieri ${snapshot.data?.deltaDeceduti})',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18))
                        ])),
                        Text.rich(
                            TextSpan(text: 'Tamponi: ', children: <TextSpan>[
                          TextSpan(
                              text: '${snapshot.data?.tamponi}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 18))
                        ])),
                        Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text.rich(
                                TextSpan(text: 'Frazione tamponi positivi: ')),
                            Text.rich(TextSpan(
                                text:
                                    '${snapshot.data?.frazioneTamponi?.toStringAsFixed(1)} % (ieri ${snapshot.data?.deltaFrazioneTamponi?.toStringAsFixed(1)} %)',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 18)))
                          ],
                        ),
                        Text.rich(
                          TextSpan(
                              text:
                                  'Ultimo aggiornamento dalla Protezione Civile:',
                              children: <TextSpan>[
                                TextSpan(
                                    text: '${snapshot.data?.data}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: 18))
                              ]),
                          maxLines: 2,
                        ),
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
            Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                          "2021 (c) Commissario straordinario \n per l'emergenza Covid-19 \n Presidenza del Consiglio dei Ministri.",
                          maxLines: 3,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          style: TextStyle(fontSize: 6),
                          textAlign: TextAlign.left)),
                  GestureDetector(
                      onTap: _launchURLMinSaluteApp,
                      child: Text("Copyright 2021 (c) Ministero della Salute.",
                          maxLines: 3,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          style: TextStyle(fontSize: 6),
                          textAlign: TextAlign.left))
                ]),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
