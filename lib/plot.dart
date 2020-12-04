import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:core';

class MeasureData {
  int day;
  double value;
  charts.Color color = charts.ColorUtil.fromDartColor(Colors.grey);
  MeasureData({@required this.day, @required this.value});
}

class PlotSeries {
  static List<MeasureData> _data = [];

  List<charts.Series<MeasureData, int>> series;

  factory PlotSeries.makeSeries(List<dynamic> json, String label, bool delta) {
    _data = [];
    if (delta) {
      if (label.contains("/")) {
        var keys = label.split("/");
        for (var i = 1; i < json.length; i++)
          _data.add(MeasureData(
              day: i,
              value: double.parse('${(json[i][keys[0]] - json[i - 1][keys[0]]).abs() /(json[i][keys[1]] - json[i - 1][keys[1]]).abs() *100}')));
      } else {
        for (var i = 1; i < json.length; i++)
          _data.add(
              MeasureData(day: i, value: double.parse('${json[i][label] - json[i - 1][label]}')));
      }
    } else {
      if (label.contains("/")) {
        var keys = label.split("/");
        for (var i = 0; i < json.length; i++)
          _data.add(MeasureData(
              day: i, value: double.parse('${json[i][keys[0]] / json[i][keys[1]] * 100}')));
      } else {
        for (var i = 0; i < json.length; i++)
          _data.add(MeasureData(day: i, value: double.parse('${json[i][label]}')));
      }
    }
    return PlotSeries(series: [
      charts.Series<MeasureData, int>(
          id: "serie1",
          data: _data,
          domainFn: (MeasureData series, _) => series.day,
          measureFn: (MeasureData series, _) => series.value,
          colorFn: (MeasureData series, _) => series.color)
    ]);
  }

  PlotSeries({this.series});
}

Future<PlotSeries> fetchPlotSeries(String label, {bool delta = false}) async {
  final response = await http.get(
      'https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-json/dpc-covid19-ita-andamento-nazionale.json');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return PlotSeries.makeSeries(jsonDecode(response.body), label, delta);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
