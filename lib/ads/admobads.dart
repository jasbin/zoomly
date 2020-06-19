import 'package:firebase_admob/firebase_admob.dart';

class AdmobAds {
  //admob ads
  static const String testDevice = 'F4FA7C1356925D1F';
  BannerAd _bannerAd;
  NativeAd _nativeAd;
  InterstitialAd _interstitialAd;

  static InitializeAds() {
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['app', 'games'],
    contentUrl: 'http://google.com',
    childDirected: true,
    nonPersonalizedAds: true,
  );

  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }
}
