import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VaccineStats {
  int personeVaccinate;
  int dosiSomministrate;
  int? dosiAggiuntive;
  double fracPopolazione;
  //http://demo.istat.it/popres/index.php?anno=2021&lingua=ita
  static final int popolazione = 59257566;

  VaccineStats(
      {this.dosiSomministrate = -1,
      this.personeVaccinate = -1,
      this.fracPopolazione = -1,
      this.dosiAggiuntive = -1});

  factory VaccineStats.fromFetchedJson(List<dynamic> json) {
    var personeVaccinate = 0;
    var dosiSomministrate = 0;
    int dosiAggiuntive = 0;
    for (var item in json) {
      int primaDose = item["prima_dose"];
      int secondaDose = item["seconda_dose"];
      dosiAggiuntive += item["dose_addizionale_booster"] as int? ?? 0;
      var fornitore = item["fornitore"];
      //some vaccines requires two doses
      switch (fornitore) {
        case "Pfizer\/BioNTech":
          personeVaccinate += secondaDose;
          break;
        case "Moderna":
          personeVaccinate += secondaDose;
          break;
        case "Vaxzevria (AstraZeneca)":
          personeVaccinate += secondaDose;
          break;
        case "Janssen":
          personeVaccinate += primaDose;
          break;
        default:
          personeVaccinate += secondaDose;
      }
      personeVaccinate += int.parse("${item["pregressa_infezione"]}");
      dosiSomministrate += primaDose + secondaDose;
    }

    dosiSomministrate += dosiAggiuntive;

    return VaccineStats(
        dosiSomministrate: dosiSomministrate.toInt(),
        personeVaccinate: personeVaccinate.toInt(),
        fracPopolazione:
            double.parse("${personeVaccinate / popolazione * 100}"),
        dosiAggiuntive: dosiAggiuntive);
  }
}

Future<VaccineStats> fetchVaccineData() async {
  final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/italia/covid19-opendata-vaccini/master/dati/somministrazioni-vaccini-latest.json'));

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
