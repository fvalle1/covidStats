import 'package:dati_italia/immuniPlot.dart';
import 'package:dati_italia/passPlot.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'plot.dart';

class MyPlotPage extends StatefulWidget {
  MyPlotPage({Key? key, this.title = "", this.label}) : super(key: key);

  final String title;
  final String? label;

  @override
  _MyPlotPageState createState() => _MyPlotPageState();
}

class _MyPlotPageState extends State<MyPlotPage> {
  Future<PlotSeries>? _futurePlotData;
  String? _currentTrend;

  @override
  void initState() {
    super.initState();
    _currentTrend = "Totale positivi";
    _futurePlotData = fetchPlotSeries("totale_positivi");
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
                child: Text(_currentTrend!, style: TextStyle(fontSize: 24))),
            FutureBuilder<PlotSeries>(
                future: _futurePlotData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                        child: charts.TimeSeriesChart(snapshot.data!.series!,
                            dateTimeFactory: const charts.LocalDateTimeFactory(),
                            animate: true)
                            );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                }),
            Wrap(
              direction: Axis.horizontal,
              spacing: 1,
              children: [
                ElevatedButton(
                    child: Text("totale positivi"),
                    onPressed: () {
                      setState(() {
                        _currentTrend = "Totale positivi";
                        _futurePlotData = fetchPlotSeries("totale_positivi");
                      });
                    }),
                ElevatedButton(
                    child: Text("percentuale positivi"),
                    onPressed: () {
                      setState(() {
                        _currentTrend = "Percentuale positivi";
                        _futurePlotData = fetchPlotSeries("nuovi_positivi/tamponi", delta:false, deltaDenominator:true);
                      });
                    }),
                ElevatedButton(
                    child: Text("terapie intensive"),
                    onPressed: () {
                      setState(() {
                        _currentTrend = "Terapia intensiva";
                        _futurePlotData = fetchPlotSeries("terapia_intensiva");
                      });
                    }),
                ElevatedButton(
                    child: Text("morti"),
                    onPressed: () {
                      setState(() {
                        _currentTrend = "Morti";
                        _futurePlotData = fetchPlotSeries("deceduti", delta: true);
                      });
                    }),
                ElevatedButton(
                    child: Text("nuovi positivi"),
                    onPressed: () {
                      setState(() {
                        _currentTrend = "Nuovi positivi";
                        _futurePlotData = fetchPlotSeries("nuovi_positivi");
                      });
                    }),
                ElevatedButton(
                    child: Text("green pass"),
                    onPressed: () {
                      setState(() {
                        _currentTrend = "Green Pass emessi";
                        _futurePlotData = fetchPassPlotSeries();
                      });
                    }),
                ElevatedButton(
                    child: Text("segnalazioni immuni"),
                    onPressed: () {
                      setState(() {
                        _currentTrend = "Segnalazioni effettuate su Immuni";
                        _futurePlotData =
                            fetchImmuniPlotSeries(label: "utenti_positivi");
                      });
                    }),
                ElevatedButton(
                    child: Text("notifiche immuni"),
                    onPressed: () {
                      setState(() {
                        _currentTrend = "Notifiche inviate da Immuni";
                        _futurePlotData = fetchImmuniPlotSeries(label: "notifiche_inviate");
                      });
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
