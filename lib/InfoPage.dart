import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:package_info/package_info.dart';

class InfoPage extends StatelessWidget {
  void launchGitUrl() async {
    var url = Uri.parse("https://github.com/fvalle1/covidStats/");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(flex: 1),
        Image(
          image: NetworkImage(
              "https://raw.githubusercontent.com/fvalle1/covidStats/develop/Icon-192.png"),
          errorBuilder: (context, obj, st) => Container(),
        ),
        // FutureBuilder<PackageInfo>(
        //   future: PackageInfo.fromPlatform(),
        //   builder: (context, snapshot) {
        //     switch (snapshot.connectionState) {
        //       case ConnectionState.done:
        //         return Text("v " + snapshot.data!.version,
        //             style: TextStyle(fontSize: 25));
        //       default:
        //         return const Text("v 1.0.0^");
        //     }
        //   },
        // ),
        Text("v 5.1.0", style: TextStyle(fontSize: 25)),
        Text("by Filippo Valle", style: TextStyle(fontSize: 25)),
        Spacer(flex: 2),
        Text("App open Source", style: TextStyle(fontSize: 20)),
        GestureDetector(
          onTap: launchGitUrl,
          child: Text(
            "https://github.com/fvalle1/covidStats/",
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
        Text("Rilasciata con Licenza GPL v3", style: TextStyle(fontSize: 18)),
        Spacer(flex: 1)
      ],
    )));
  }
}
