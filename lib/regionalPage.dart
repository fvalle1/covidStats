import 'package:flutter/material.dart';

import 'regionPage.dart';

class MyRegionalPage extends StatelessWidget {
  MyRegionalPage({Key? key, this.title = ""}) : super(key: key);

  final String title;
  final int _itemCount = 21;
  final List<String> _regions = ["Abruzzo",
                                "Basilicata",
                                "Calabria",
                                "Campania",
                                "Emilia-Romagna",
                                "Friuli Venezia Giulia",
                                "Lazio",
                                "Liguria",
                                "Lombardia",
                                "Marche",
                                "Molise",
                                "P.A. Bolzano",
                                "P.A. Trento",
                                "Piemonte",
                                "Puglia",
                                "Sardegna",
                                "Sicilia",
                                "Toscana",
                                "Umbria",
                                "Valle d'Aosta",
                                "Veneto"];

  Widget _getRegionalWidget(int index) {
    return MyRegionPage(title: _regions[index]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
            child: ListView.builder(
                itemCount: _itemCount,
                itemBuilder: (BuildContext context, int index) {
                  return ElevatedButton(
                      child: Text("${_regions[index]}"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    _getRegionalWidget(index)));
                        //Navigator.pop(context);
                      });
                }
              )
            )
        );
  }
}
