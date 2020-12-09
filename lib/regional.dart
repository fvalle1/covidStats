import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'stats.dart';
import 'plot.dart';

Future<Stats> fetchRegionalStats(String region) async {
  final response = await http.get(
      'https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-json/dpc-covid19-ita-regioni.json');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<dynamic> toReturnList = [];
    for (var data in jsonDecode(response.body)) {
      if (data["denominazione_regione"] == region) {
        toReturnList.insert(toReturnList.length, data);
      }
    }
    return Stats.fromFetchedJson(toReturnList);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load');
  }
}

Future<PlotSeries> fetchRegionalPlotSeries(String region, String label,
    {bool delta = false, bool deltaDenominator = false}) async {
  final response = await http.get(
      'https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-json/dpc-covid19-ita-regioni.json');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<dynamic> toReturnList = [];
    for (var data in jsonDecode(response.body)) {
      if (data["denominazione_regione"] == region) {
        toReturnList.insert(toReturnList.length, data);
      }
    }
    return PlotSeries.makeSeries(toReturnList, label, delta, deltaDenominator);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load');
  }
}
