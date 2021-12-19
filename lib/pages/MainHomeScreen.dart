import 'dart:convert';

import 'drawerScreen.dart';
import 'Widgets/ClassesWidet.dart';
import 'models/Class.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

List<Classes> allClasses = [];
Map<String, Color> listColor = {
  "MaterialColor(primary value: Color(0xff2196f3))": Colors.blue,
  "MaterialColor(primary value: Color(0xfff44336))": Colors.red,
  "MaterialColor(primary value: Color(0xffffeb3b))": Colors.yellow,
  "MaterialColor(primary value: Color(0xffe91e63))": Colors.pink,
  "MaterialColor(primary value: Color(0xffff9800))": Colors.orange,
  "MaterialColor(primary value: Color(0xff9c27b0))": Colors.purple,
  "MaterialColor(primary value: Color(0xff009688))": Colors.teal,
  "MaterialAccentColor(primary value: Color(0xffb2ff59))":
      Colors.lightGreenAccent
};
Color mainColor = Colors.blue;
Color classChosenColor = mainColor;

class MainHomeScreen extends StatefulWidget {
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  Future<void> getData() async {
    Uri Url = Uri.parse(
        "https://attendgo-7611e-default-rtdb.firebaseio.com/classes.json");
    List<Classes> classesList;
    try {
      final response = await http.get(Url);
      //print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((key, value) {
        allClasses.add(Classes(
            id: key,
            canShare: value["privacy"],
            name: value["title"],
            color: listColor[value["color"] as String] as Color));
      });
      setState(() {
        allClasses;
      });
    } catch (error) {
      print(error);
      classesList = [];
    }
  }

  void initState() {
    getData();
    super.initState();
  }

  @override
  voidChangedropVal(newValue) {
    setState(() {
      dropdownValue = newValue;
    });
  }

  bool showColor = false;
  void changeColor(color) {
    setState(() {
      mainColor = color;
    });
  }

  void changeState(curState) {
    setState(() => curState == true ? showColor = false : showColor = true);
  }

  void addClass(newclass) {
    setState(() {
      allClasses.add(newclass);
    });
  }

  String dropdownValue = 'Red';
  List availColors = [
    [Colors.pink, "pink"],
    [Colors.orange, "orange"],
    [Colors.red, "Red"],
    [Colors.yellow, "Yellow"],
    [Colors.green, "Green"],
    [Colors.purple, "purple"],
    [Colors.blue, "blue"]
  ];
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Attendance App",
              style: TextStyle(
                  fontFamily: "QuickSand",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          backgroundColor: mainColor,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.05,
              MediaQuery.of(context).size.height * 0.03,
              MediaQuery.of(context).size.width * 0.05,
              MediaQuery.of(context).size.height * 0.01),
          child: 
          allClasses.length != 0 ?
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: MediaQuery.of(context).size.height * 0.05,
            crossAxisSpacing: MediaQuery.of(context).size.width * 0.05,
            childAspectRatio: 3 / 2,
            children: [
              ...allClasses.map((data) {
                return ClassesWidget(data.color, data.name, data.id);
              }).toList()
            ],
          ):
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children : [
              Icon(Icons.error_outline, size : 20 * MediaQuery.of(context).textScaleFactor), 
              Text("There is either a problem with the internet, or you have no classes")
            ]
          )),
        drawer: drawerScreen(
            showColor, mainColor, changeState, changeColor, availColors),
        bottomNavigationBar: CurvedNavigationBar(
          onTap: (_) {
            Navigator.of(context)
                .pushNamed('createClassScreen', arguments: addClass);
          },
          items: [Icon(Icons.add, size: 30, color: Colors.white)],
          backgroundColor: Colors.white,
          color: mainColor,
          index: 0,
          height: 60,
        ));
  }
}
