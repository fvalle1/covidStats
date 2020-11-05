import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Stats{
  int totale_positivi;
  int nuovi_positivi;
  int terapia_intensiva;
  int deceduti;
  int tamponi;
  int casi;
  double frazione_tamponi;

  Stats({this.totale_positivi, this.nuovi_positivi, this.terapia_intensiva, this.deceduti, this.tamponi, this.casi}){
    this.frazione_tamponi = this.nuovi_positivi/this.casi*100;
  }

  factory Stats.fromFetchedJson(Map<String, dynamic> json) {
    return Stats(
      totale_positivi: json["totale_positivi"],
      nuovi_positivi: json["nuovi_positivi"],
      terapia_intensiva: json["terapia_intensiva"],
      deceduti: json["deceduti"],
      tamponi: json["tamponi"],
      casi: json["casi_testati"]
      );
  }
}

Future<Stats> fetchData() async {
  final response = await http.get('https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-json/dpc-covid19-ita-andamento-nazionale-latest.json');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Stats.fromFetchedJson(jsonDecode(response.body)[0]);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
