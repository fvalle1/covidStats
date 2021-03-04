import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyAdBanner extends BannerAd {
  static String? _getID() {
    if (Platform.isAndroid) {
      return "ca-app-pub-5634083263382878/1543430580";
    }
    if (Platform.isIOS) {
      return "ca-app-pub-5634083263382878~5098983473";
    }
  }

  MyAdBanner()
      : super(
          adUnitId: _getID(),
          size: AdSize.banner,
          request: AdRequest(),
          listener: AdListener(),
        );
}

class MyAdWidget extends AdWidget {
  MyAdWidget({BannerAd? ad}) : super(ad: ad!);
}

final AdListener listener = AdListener(
  // Called when an ad is successfully received.
  onAdLoaded: (Ad ad) => print('Ad loaded.'),
  // Called when an ad request failed.
  onAdFailedToLoad: (Ad ad, LoadAdError error) {
    print('Ad failed to load: $error');
  },
  // Called when an ad opens an overlay that covers the screen.
  onAdOpened: (Ad ad) => print('Ad opened.'),
  // Called when an ad removes an overlay that covers the screen.
  onAdClosed: (Ad ad) => print('Ad closed.'),
  // Called when an ad is in the process of leaving the application.
  onApplicationExit: (Ad ad) => print('Left application.'),
);
