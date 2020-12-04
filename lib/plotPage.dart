import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'plot.dart';

class MyPlotPage extends StatefulWidget {
  MyPlotPage({Key key, this.title, this.label}) : super(key: key);

  final String title;
  final String label;

  @override
  _MyPlotPageState createState() => _MyPlotPageState();
}

class _MyPlotPageState extends State<MyPlotPage> {
  Future<PlotSeries> _futurePlotData;
  String _currentTrend;

  @override
  void initState() {
    super.initState();
    _currentTrend = "Here some plots";
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
                child: Text(_currentTrend, style: TextStyle(fontSize: 24))),
            FutureBuilder<PlotSeries>(
                future: _futurePlotData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                        child: charts.LineChart(snapshot.data.series,
                            animate: true));
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
                    child: Text("totale_positivi"),
                    onPressed: () {
                      setState(() {
                        _currentTrend = "Totale positivi";
                        _futurePlotData = fetchPlotSeries("totale_positivi");
                      });
                    }),
                ElevatedButton(
                    child: Text("frazione_positivi"),
                    onPressed: () {
                      setState(() {
                        _currentTrend = "Percentuale positivi";
                        _futurePlotData = fetchPlotSeries("nuovi_positivi/tamponi", delta:false, delta_denominator:true);
                      });
                    }),
                ElevatedButton(
                    child: Text("terapie_intensive"),
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
                    child: Text("nuovi_positivi"),
                    onPressed: () {
                      setState(() {
                        _currentTrend = "Nuovi positivi";
                        _futurePlotData = fetchPlotSeries("nuovi_positivi");
                      });
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
