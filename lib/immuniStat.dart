import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ImmuniStats {
  int notificheInviate;
  int totaleNotifiche;
  int utentiPositivi;
  int totaleUtentiPositivi;

  ImmuniStats(
      {this.notificheInviate = -1,
      this.utentiPositivi = -1,
      this.totaleNotifiche = -1,
      this.totaleUtentiPositivi = -1});

  factory ImmuniStats.fromFetchedJson(List<dynamic> json) {
    var l = json.length - 1;
    var notificheInviate = json[l]['notifiche_inviate'];
    var utentiPositivi = json[l]['utenti_positivi'];
    var totaleNotifiche = json[l]['notifiche_inviate_totali'];
    var totaleUtentiPositivi = json[l]['utenti_positivi_totali'];

    return ImmuniStats(
        notificheInviate: notificheInviate,
        utentiPositivi: utentiPositivi,
        totaleNotifiche: totaleNotifiche,
        totaleUtentiPositivi: totaleUtentiPositivi);
  }
}

getImmuniData() async {
  final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/immuni-app/immuni-dashboard-data/master/dati/andamento-dati-nazionali.json'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return jsonDecode(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load');
  }
}

Future<ImmuniStats> fetchImmuniData() async {
  var immuniData = ImmuniStats.fromFetchedJson(await getImmuniData());
  return immuniData;
}
