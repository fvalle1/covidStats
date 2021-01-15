import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VaccineStats {
  int dosiConsegnate;
  int dosiSomministrate;
  double fracPopolazione;
  static final int popolazione = 60756087;

  VaccineStats(
      {this.dosiConsegnate, this.dosiSomministrate, this.fracPopolazione});

  factory VaccineStats.fromFetchedJson(List<dynamic> json) {
    var dosiConsegnate = 0;
    var dosiSomministrate = 0;
    for (var item in json) {
      dosiConsegnate += item["dosi_consegnate"];
      dosiSomministrate += item["dosi_somministrate"];
    }
    return VaccineStats(
        dosiConsegnate: dosiConsegnate.toInt(),
        dosiSomministrate: dosiSomministrate.toInt(),
        fracPopolazione: double.parse("${dosiSomministrate / popolazione * 100}")
        );
  }
}

Future<VaccineStats> fetchVaccineData() async {
  final response = await http.get(
      'https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/vaccini-summary-latest.json');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return VaccineStats.fromFetchedJson(jsonDecode(response.body)["data"]);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load');
  }
}
