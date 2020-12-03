import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart' show DateFormat;
import 'package:http/http.dart' as http;

class Stats {
  int totalePositivi;
  int nuoviPositivi;
  int previousPositivi;
  int terapiaIntensiva;
  int deltaTerapiaIntensiva;
  int ricoverati;
  int deltaRicoverati;
  int deceduti;
  int deltaDeceduti;
  int tamponi;
  int previousTamponi;
  int casi;
  String data;
  double frazioneTamponi;
  double deltaFrazioneTamponi;

  Stats(
      {this.totalePositivi,
      this.nuoviPositivi,
      this.previousPositivi,
      this.terapiaIntensiva,
      this.deltaTerapiaIntensiva,
      this.ricoverati,
      this.deltaRicoverati,
      this.deceduti,
      this.deltaDeceduti,
      this.tamponi,
      this.previousTamponi,
      this.casi,
      this.data}) {
    this.frazioneTamponi = this.nuoviPositivi / this.tamponi * 100;
    this.deltaFrazioneTamponi = this.previousPositivi / this.previousTamponi * 100;
  }

  factory Stats.fromFetchedJson(List<dynamic> json) {
    var latest = json.last;
    var previous = json[json.length - 2];
    return Stats(
      totalePositivi: latest["totale_positivi"],
      previousPositivi: previous["nuovi_positivi"],
      nuoviPositivi: latest["nuovi_positivi"],
      terapiaIntensiva: latest["terapia_intensiva"],
      deltaTerapiaIntensiva:
          latest["terapia_intensiva"] - previous["terapia_intensiva"],
      ricoverati: latest["totale_ospedalizzati"],
      deltaRicoverati:
          latest["totale_ospedalizzati"] - previous["totale_ospedalizzati"],
      deceduti: latest["deceduti"] - previous["deceduti"],
      deltaDeceduti: previous["deceduti"] - json[json.length - 3]["deceduti"],
      tamponi: latest["tamponi"] - previous["tamponi"],
      previousTamponi: previous["tamponi"] - json[json.length - 3]["tamponi"],
      casi: latest["casi_testati"] - previous["casi_testati"],
      data: DateFormat("dd/MM/yyyy").format(DateTime.parse(latest["data"])),
    );
  }
}

Future<Stats> fetchData() async {
  final response = await http.get(
      'https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-json/dpc-covid19-ita-andamento-nazionale.json');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Stats.fromFetchedJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
