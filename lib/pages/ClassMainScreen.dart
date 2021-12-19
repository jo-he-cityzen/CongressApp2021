import 'dart:convert';

import 'People.dart';
import 'Sessions.dart';
import 'models/student.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class ClassMainScreen extends StatefulWidget {
  @override
  // final dynamic cameras;
  // ClassMainScreen(this.cameras);
  _ClassMainScreenState createState() => _ClassMainScreenState();
}

class _ClassMainScreenState extends State<ClassMainScreen> {
  @override
  int SelectedPageIndex = 0;

  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final labels = [" : sessions", " : classes"];
    var appbarWidget = AppBar(
      title: Text(data["title"]),
      backgroundColor: data["color"],
    );
    void SwitchScreen(ind) {
      setState(() {
        SelectedPageIndex = ind;
      });
    }
    var bottombarWidget = CurvedNavigationBar(
      onTap: SwitchScreen,
      items: [
        Icon(Icons.menu_book, size: 30, color: Colors.white),
        Icon(Icons.people, size: 30, color: Colors.white),
      ],
      backgroundColor: Colors.white,
      color: data["color"],
    );
    double screenHeight = MediaQuery.of(context).size.height -
        bottombarWidget.height -
        appbarWidget.preferredSize.height;
    List<Widget> screenslist = [
      SessionsScreen(data["color"], screenHeight, data["id"].toString()),
      StudentsScreen(data["color"], screenHeight, data["id"].toString())
    ];
    return Scaffold(
        appBar: appbarWidget,
        body: screenslist[SelectedPageIndex],
        bottomNavigationBar: bottombarWidget);
  }
}
