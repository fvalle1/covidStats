import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid_stats/plot.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:core';

import 'stats.dart';
import 'regional.dart';

class MyRegionPage extends StatefulWidget {
  MyRegionPage({Key? key, this.title = ""}) : super(key: key);

  final String title;

  @override
  _MyRegionPageState createState() => _MyRegionPageState();
}

class _MyRegionPageState extends State<MyRegionPage> {
  Future<Stats>? _futureStatistics;
  Future<PlotSeries>? _futurePlotData;
  bool _showPlots = false;
  bool _showStats = true;
  String? _currentTrend;

  @override
  void initState() {
    super.initState();
    _futureStatistics = fetchRegionalStats(widget.title);
    _futurePlotData = fetchRegionalPlotSeries(widget.title, "totale_positivi");
    _showPlots = false;
    _showStats = true;
    _currentTrend = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          children: [
            _showStats
                ? FutureBuilder<Stats>(
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
                                            fontSize: 20))
                                  ])),
                              Text.rich(TextSpan(
                                  text: 'Terapie intensive: ',
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            '${snapshot.data?.terapiaIntensiva} (${(snapshot.data!.deltaTerapiaIntensiva! > 0) ? "+" : ""}${snapshot.data?.deltaTerapiaIntensiva} da ieri)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                            fontSize: 20))
                                  ])),
                              Text.rich(TextSpan(
                                  text: 'Ricoverati: ',
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            '${snapshot.data?.ricoverati} (${(snapshot.data!.deltaRicoverati! > 0) ? "+" : ""}${snapshot.data?.deltaRicoverati} da ieri)',
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
                                            '${snapshot.data?.totalePositivi} (${(snapshot.data!.totalePositivi! > snapshot.data!.previousTotalePositivi!) ? "+" : ""}${snapshot.data!.totalePositivi! - snapshot.data!.previousTotalePositivi!} da ieri)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: 20))
                                  ])),
                              Text.rich(TextSpan(
                                  text: 'Deceduti: ',
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            '${snapshot.data?.deceduti} (ieri ${snapshot.data?.deltaDeceduti})',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 20))
                                  ])),
                              Text.rich(TextSpan(
                                  text: 'Tamponi: ',
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${snapshot.data?.tamponi}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                            fontSize: 20))
                                  ])),
                              Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Text.rich(TextSpan(
                                      text: 'Frazione tamponi positivi: ')),
                                  Text.rich(TextSpan(
                                      text:
                                          '${snapshot.data?.frazioneTamponi?.toStringAsFixed(1)}% (ieri ${snapshot.data?.deltaFrazioneTamponi?.toStringAsFixed(1)}%)',
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
                                        text: '${snapshot.data?.data}',
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
                  )
                : Container(),
            //Spacer(flex: 1),
            _showPlots ? Text(_currentTrend!) : Container(),
            Container(
                child: _showPlots
                    ? FutureBuilder<PlotSeries>(
                        future: _futurePlotData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                                child: charts.TimeSeriesChart(
                                    snapshot.data?.series,
                                    dateTimeFactory:
                                        const charts.LocalDateTimeFactory(),
                                    animate: true)
                                    );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }

                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        })
                    : Spacer(flex: 1)),
            _showPlots
                ? Wrap(
                    children: [
                      ElevatedButton(
                          child: Text("totale positivi"),
                          onPressed: () {
                            setState(() {
                              _currentTrend = "Totale positivi";
                              _futurePlotData = fetchRegionalPlotSeries(
                                  widget.title, "totale_positivi");
                            });
                          }),
                      ElevatedButton(
                          child: Text("percentuale positivi"),
                          onPressed: () {
                            setState(() {
                              _currentTrend = "Percentuale positivi";
                              _futurePlotData = fetchRegionalPlotSeries(
                                  widget.title, "nuovi_positivi/tamponi",
                                  delta: false, deltaDenominator: true);
                            });
                          }),
                      ElevatedButton(
                          child: Text("terapie intensive"),
                          onPressed: () {
                            setState(() {
                              _currentTrend = "Terapia intensiva";
                              _futurePlotData = fetchRegionalPlotSeries(
                                  widget.title, "terapia_intensiva");
                            });
                          }),
                      ElevatedButton(
                          child: Text("morti"),
                          onPressed: () {
                            setState(() {
                              _currentTrend = "Morti";
                              _futurePlotData = fetchRegionalPlotSeries(
                                  widget.title, "deceduti",
                                  delta: true);
                            });
                          }),
                      ElevatedButton(
                          child: Text("nuovi positivi"),
                          onPressed: () {
                            setState(() {
                              _currentTrend = "Nuovi positivi";
                              _futurePlotData = fetchRegionalPlotSeries(
                                  widget.title, "nuovi_positivi");
                            });
                          })
                    ],
                  )
                : Container(),
            Wrap(direction: Axis.horizontal, spacing: 1, children: [
              ElevatedButton(
                  child: Text("indietro"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              ElevatedButton(
                  child: _showPlots ? Text("mostra dati") : Text("mostra plot"),
                  onPressed: () {
                    setState(() {
                      _showPlots = !_showPlots;
                      _showStats = !_showPlots;
                    });
                  })
            ]),
            Spacer(),
          ],
        )));
  }
}
