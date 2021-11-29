import "package:charts_flutter/flutter.dart" as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:dati_italia/passStat.dart';
import 'package:dati_italia/plot.dart';
import 'package:flutter/material.dart';

class PassPlot extends PlotSeries {
  factory PassPlot.makePassSeries(List<dynamic> json) {
    List<MeasureData> _data = [];

    //7-days moving average
    // skip (-7) the first 7 days to remove bias due to initial emission
    for (var i = json.length - 4 - 7; i >=4; i--) {
      var value = 0.0;
      for (int j = i - 3; j < i + 4; j++) {
        value += json[j]["issued_all"];
      }
      var dataPoint =
          MeasureData(day: DateTime.parse(json[i]["data"]), value: (value / 7.0));
      dataPoint.color = charts.ColorUtil.fromDartColor(Colors.green[900]!);
      _data.add(dataPoint);
    }

    return PassPlot(series: [
      charts.Series<MeasureData, DateTime>(
          id: "serie1",
          data: _data,
          domainFn: (MeasureData series, _) => series.day!,
          measureFn: (MeasureData series, _) => series.value!,
          colorFn: (MeasureData series, _) => series.color)
    ]);
  }

  PassPlot({required List<Series<MeasureData, DateTime>> series})
      : super(series: series);
}

Future<PlotSeries>? fetchPassPlotSeries() async {
  var data = await getPassData();
  return PassPlot.makePassSeries(data);
}
