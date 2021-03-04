import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VaccineStats {
  int personeVaccinate;
  int dosiSomministrate;
  double fracPopolazione;
  static final int popolazione = 60756087;

  VaccineStats(
      {this.dosiSomministrate = -1, this.personeVaccinate = -1, this.fracPopolazione = -1});

  factory VaccineStats.fromFetchedJson(List<dynamic> json) {
    var personeVaccinate = 0;
    var dosiSomministrate = 0;
    for (var item in json) {
      int primaDose = item["prima_dose"];
      int secondaDose = item["seconda_dose"];
      var fornitore = item["fornitore"];
      //some vaccines requires two doses
      switch (fornitore) {
        case "Pfizer\/BioNTech":
          personeVaccinate += secondaDose;
          break;
        case "Moderna":
          personeVaccinate += secondaDose;
          break;
        case "AstraZeneca":
          personeVaccinate += secondaDose;
          break;
        default:
          personeVaccinate += primaDose;
      }
      dosiSomministrate += primaDose + secondaDose;
    }
    return VaccineStats(
        dosiSomministrate: dosiSomministrate.toInt(),
        personeVaccinate: personeVaccinate.toInt(),
        fracPopolazione:
            double.parse("${personeVaccinate / popolazione * 100}"));
  }
}

Future<VaccineStats> fetchVaccineData() async {
  final response = await http.get(
      Uri.parse(
      'https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/somministrazioni-vaccini-latest.json')
      );

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
