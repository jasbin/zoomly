import 'package:firebase_admob/firebase_admob.dart';

class AdmobAds {
  //admob ads
  static const String testDevice = '';
  BannerAd _bannerAd;
  NativeAd _nativeAd;
  InterstitialAd _interstitialAd;

  //appId and banner ad unit id here
//  test app id: ca-app-pub-3940256099942544~3347511713
//  test banner ads id:ca-app-pub-3940256099942544/6300978111
//  test interstitial ads id: ca-app-pub-3940256099942544/1033173712

//  real ads
//  appid:ca-app-pub-3940256099942544~3347511713
//  banneradunitid:ca-app-pub-1666784341597244/9270155322
//  interstitialadunitid:ca-app-pub-1666784341597244/6069276914

  static String appId = "ca-app-pub-3940256099942544~3347511713";
  static const bannerAdUnitId = "ca-app-pub-1666784341597244/9270155322";
  static const interstitialAdUnitId = "ca-app-pub-1666784341597244/6069276914";

  static InitializeAds() {
    FirebaseAdMob.instance.initialize(appId: appId);
  }

  static String interstitialAdId() {
    return interstitialAdUnitId;
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: <String>['app', 'games'],
    contentUrl: 'http://google.com',
    childDirected: false,
    nonPersonalizedAds: false,
  );

  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }
}
