import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:nepaly/ads/admobads.dart';
import 'package:nepaly/pages/createMeeting.dart';
import 'package:nepaly/pages/joinMeeting.dart';
import 'package:nepaly/pages/loading.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/',
      routes: {'/': (context) => Loading(), '/home': (context) => Nepaly()},
      debugShowCheckedModeBanner: false,
    ));

class Nepaly extends StatefulWidget {
  @override
  _NepalyState createState() => _NepalyState();
}

class _NepalyState extends State<Nepaly> {
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
//    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Nepaly Video Conference"),
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
