import "package:charts_flutter/flutter.dart" as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:dati_italia/immuniStat.dart';
import 'package:dati_italia/plot.dart';
import 'package:flutter/material.dart';

class ImmuniPlot extends PlotSeries {
  factory ImmuniPlot.makeImmuniSeries(List<dynamic> json,
      {required String label}) {
    List<MeasureData> _data = [];

    //7-days moving average
    // skip (-7) the first 7 days to remove bias due to initial emission
    for (var i = json.length - 4 - 7; i >= 4; i--) {
      var value = 0.0;
      for (int j = i - 3; j < i + 4; j++) {
        value += json[j][label];
      }
      var dataPoint = MeasureData(
          day: DateTime.parse(json[i]["data"]), value: (value / 7.0));
      dataPoint.color = charts.ColorUtil.fromDartColor(Colors.purple[800]!);
      _data.add(dataPoint);
    }

    return ImmuniPlot(series: [
      charts.Series<MeasureData, DateTime>(
          id: "serie1",
          data: _data,
          domainFn: (MeasureData series, _) => series.day!,
          measureFn: (MeasureData series, _) => series.value!,
          colorFn: (MeasureData series, _) => series.color)
    ]);
  }

  ImmuniPlot({required List<Series<MeasureData, DateTime>> series})
      : super(series: series);
}

Future<PlotSeries>? fetchImmuniPlotSeries({String label = "notifiche_inviate"}) async {
  var data = await getImmuniData();
  return ImmuniPlot.makeImmuniSeries(data, label: label);
}
