import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:zoomly/ads/admobads.dart';
import 'package:zoomly/pages/createMeeting.dart';
import 'package:zoomly/pages/joinMeeting.dart';

void main() => runApp(MaterialApp(
      home: Zoomly(),
    ));

class Zoomly extends StatefulWidget {
  @override
  _ZoomlyState createState() => _ZoomlyState();
}

class _ZoomlyState extends State<Zoomly> {
  BannerAd _bannerAd;
  int currentPage = 0;

  final List<Widget> _pages = [
    JoinMeeting(),
    CreateMeeting(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AdmobAds.InitializeAds();
    _bannerAd = AdmobAds.createBannerAd()
      ..load()
      ..show();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Zoomly"),
          centerTitle: true,
          backgroundColor: Colors.blue[800],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Join Meeting'),
              Tab(text: 'Create Meeting'),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [JoinMeeting(), CreateMeeting()],
        ),
      ),
    );
  }
}
