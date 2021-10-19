import "package:charts_flutter/flutter.dart" as charts;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:core';

class MeasureData {
  DateTime? day;
  double? value;
  charts.Color color = charts.ColorUtil.fromDartColor(Colors.grey);
  MeasureData({@required this.day, @required this.value});
}

class PlotSeries {
  static List<MeasureData> _data = [];

  List<charts.Series<MeasureData, DateTime>>? series;

  factory PlotSeries.makeSeries(
      List<dynamic> json, String label, bool delta, bool deltaDenominator) {
    _data = [];
    if (label.contains("/")) {
      var keys = label.split("/");
      for (var i = 4; i < json.length - 4; i++) {
        var numerator = 0.0;
        var denominator = 0.0;
        if (delta) {
          for (int j = i - 3; j < i + 4; j++) {
            numerator += double.parse(
                '${(json[j][keys[0]] - json[j - 1][keys[0]]).toDouble().abs()}');
          }
        } else {
          for (int j = i - 3; j < i + 4; j++) {
            numerator += double.parse('${(json[j][keys[0]]).abs()}');
          }
        }
        if (deltaDenominator) {
          for (int j = i - 3; j < i + 4; j++) {
            denominator += double.parse(
                '${(json[j][keys[1]] - json[j - 1][keys[1]]).abs()}');
          }
        } else {
          for (int j = i - 3; j < i + 4; j++) {
            denominator = double.parse('${json[j][keys[1]]}');
          }
        }
        // avoid division by zero
        if (denominator.abs() <= 1e-10) {
          numerator = 0.0;
          denominator = 1.0;
        }
        _data.add(MeasureData(
            day: DateTime.parse(json[i]["data"]),
            value: double.parse('${numerator / denominator * 100}')));
      }
    } else {
      if (delta) {
        for (var i = 4; i < json.length - 3; i++) {
          double val = 0;
          for (int j = i - 3; j < i + 4; j++) {
            val += double.parse('${json[j][label] - json[j - 1][label]}');
          }
          _data.add(MeasureData(
              day: DateTime.parse(json[i]["data"]),
              value: double.parse('${val / 7.0}')));
        }
      } else {
        for (var i = 4; i < json.length - 4; i++) {
          double val = 0;
          for (int j = i - 3; j < i + 4; j++) {
            val += double.parse('${json[j][label]}');
          }
          _data.add(MeasureData(
              day: DateTime.parse(json[i]["data"]),
              value: double.parse('${val / 7.0}')));
        }
      }
    }
    return PlotSeries(series: [
      charts.Series<MeasureData, DateTime>(
          id: "serie1",
          data: _data,
          domainFn: (MeasureData series, _) => series.day!,
          measureFn: (MeasureData series, _) => series.value!,
          colorFn: (MeasureData series, _) => series.color)
    ]);
  }

  PlotSeries({this.series});
}

Future<PlotSeries> fetchPlotSeries(String label,
    {bool delta = false, bool deltaDenominator = false}) async {
  final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-json/dpc-covid19-ita-andamento-nazionale.json'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return PlotSeries.makeSeries(
        jsonDecode(response.body), label, delta, deltaDenominator);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load');
  }
}
