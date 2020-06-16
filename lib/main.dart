import 'package:circle_bottom_navigation/circle_bottom_navigation.dart';
import 'package:circle_bottom_navigation/widgets/tab_data.dart';
import 'package:flutter/material.dart';
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
  int currentPage = 0;
  final List<Widget> _pages = [
    JoinMeeting(),
    CreateMeeting(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zoomly"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: _pages[currentPage],
      bottomNavigationBar: CircleBottomNavigation(
        barHeight: 60,
        circleSize: 40,
        initialSelection: currentPage,
        inactiveIconColor: Colors.grey,
        textColor: Colors.black,
        hasElevationShadows: false,
        tabs: [
          TabData(
            icon: Icons.home,
            iconSize: 30,
            title: 'Join Meeting',
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          TabData(
            icon: Icons.create,
            iconSize: 30,
            title: 'Create Meeting',
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ],
        onTabChangedListener: (index) => setState(() => currentPage = index),
      ),
    );
  }
}
