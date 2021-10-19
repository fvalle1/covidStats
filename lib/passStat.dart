import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PassStats {
  int passEmessi;
  int totalPassEmessi;

  PassStats({this.passEmessi = -1,
  this.totalPassEmessi = -1});

  factory PassStats.fromFetchedJson(List<dynamic> json) {
    var passEmessi = json[0]['issued_all_total'];
    var newPassEmessi = json[0]['issued_all'];

    return PassStats( passEmessi: newPassEmessi,  
                      totalPassEmessi: passEmessi);
  }
}

getPassData() async {
  final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/ministero-salute/it-dgc-opendata/master/data/dgc-issued.json'));

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

Future<PassStats> fetchPassData() async {
  var passData = PassStats.fromFetchedJson(await getPassData());
  return passData;
}
