import 'models/student.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:io';

class StudentAnalysisScreen extends StatefulWidget {
  @override
  _StudentAnalysisScreenState createState() => _StudentAnalysisScreenState();
}

enum LegendShape { Circle, Rectangle }

class _StudentAnalysisScreenState extends State<StudentAnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    List data = ModalRoute.of(context).settings.arguments as List;
    var color = data[0];
    var appBarWidget = AppBar(
      backgroundColor: color,
    );
    Students student = data[1];
    Map<String, double> dataMap = {
      "Absent": student.absent.toDouble(),
      "Tardy": student.tardy.toDouble(),
      "Present": student.present.toDouble()
    };
    double percent = 0.00;
    if (student.absent + student.tardy + student.present != 0) {
      percent =
          student.breaks / (student.absent + student.tardy + student.present);
    } else {
      percent = 0.00;
    }
    if (student.absent.toDouble() != 0 &&
        student.tardy.toDouble() != 0 &&
        student.present.toDouble() != 0) {
      Map<String, double> dataMap = {
        "Absent": student.absent.toDouble(),
        "Tardy": student.tardy.toDouble(),
        "Present": student.present.toDouble()
      };
    } else {
      Map<String, double> dataMap = {"Absent": 1, "Tardy": 1, "Present": 1};
    }
    List<Color> colorList = [Colors.red, Colors.orange, Colors.green];
    ChartType _chartType = ChartType.disc;
    bool _showCenterText = true;
    double _chartLegendSpacing = 32;
    bool _showLegendsInRow = false;
    bool _showLegends = true;
    bool _showChartValueBackground = true;
    bool _showChartValues = false;
    bool _showChartValuesInPercentage = true;
    bool _showChartValuesOutside = false;
    LegendShape _legendShape = LegendShape.Circle;
    LegendPosition _legendPosition = LegendPosition.right;
    int key = 0;
    final chart = PieChart(
        key: ValueKey(key),
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: _chartLegendSpacing,
        chartRadius: 170,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: _chartType,
        centerText: _showCenterText ? "precentage" : null,
        chartValuesOptions:
            ChartValuesOptions(showChartValuesInPercentage: true),
        legendOptions: LegendOptions(
          showLegendsInRow: _showLegendsInRow,
          legendPosition: _legendPosition,
          showLegends: _showLegends,
          legendShape: _legendShape == LegendShape.Circle
              ? BoxShape.circle
              : BoxShape.rectangle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ));
    Map<String, double> dataMap2 = {
      "Absent": student.absent.toDouble(),
      "Tardy": student.tardy.toDouble(),
      "Present": student.present.toDouble()
    };
    final chart2 = PieChart(
        key: ValueKey(key),
        dataMap: dataMap2,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: _chartLegendSpacing,
        chartRadius: 170,
        colorList: colorList,
        initialAngleInDegree: 0,
        
        chartType: _chartType,
        centerText: _showCenterText ? "numbers" : null,
        chartValuesOptions:
            ChartValuesOptions(showChartValuesInPercentage: false, ),
        legendOptions: LegendOptions(
          showLegendsInRow: _showLegendsInRow,
          legendPosition: _legendPosition,
          showLegends: _showLegends,
          legendShape: _legendShape == LegendShape.Circle
              ? BoxShape.circle
              : BoxShape.rectangle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ));
    return Scaffold(
      appBar: appBarWidget,
      body: Column(
        children: [
          Stack(children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              color: color,
            ),
            Positioned(
              left: 30,
              bottom: MediaQuery.of(context).size.height * 0.01,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(student.studentimagePath),
              ),
            ),
            Positioned(
              right: 20,
              bottom: MediaQuery.of(context).size.height * 0.02,
              child: Column(
                children: [
                  // student.lasttName
                  Text(student.firtstName,
                      style: TextStyle(
                          fontFamily: "QuickSand",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 40)),
                  Text(student.lasttName,
                      style: TextStyle(
                          fontFamily: "QuickSand",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 40)),
                ],
              ),
            )
          ]),
          Container(
            height: MediaQuery.of(context).size.height * 0.74 -
                appBarWidget.preferredSize.height,
            child: ListView(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Attendance Summary",
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                          color: color,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          fontSize:
                              30 * MediaQuery.of(context).textScaleFactor)),
                ],
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("(Sem 1)",
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                          color: color,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          fontSize:
                              30 * MediaQuery.of(context).textScaleFactor)),
                ],
              ),
              Padding(
                padding:
                    EdgeInsets.all((MediaQuery.of(context).size.height * 0.05)),
                child: Column(children: [
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("present",
                          style: TextStyle(
                              color: color,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  27 * MediaQuery.of(context).textScaleFactor)),
                      Text(student.present.toString(),
                          style: TextStyle(
                              color: color,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  27 * MediaQuery.of(context).textScaleFactor)),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("absent",
                          style: TextStyle(
                              color: color,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  27 * MediaQuery.of(context).textScaleFactor)),
                      Text(student.absent.toString(),
                          style: TextStyle(
                              color: color,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  27 * MediaQuery.of(context).textScaleFactor)),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("tardy",
                          style: TextStyle(
                              color: color,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  27 * MediaQuery.of(context).textScaleFactor)),
                      Text(student.tardy.toString(),
                          style: TextStyle(
                              color: color,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  27 * MediaQuery.of(context).textScaleFactor)),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                ]),
              ),
               Padding(
                child: chart,
                padding: EdgeInsets.fromLTRB(
                    0,
                    MediaQuery.of(context).size.height * 0.03,
                    0,
                    MediaQuery.of(context).size.height * 0.05),
              ),
              Padding(
                child: chart2,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                          "note : if there is no data on student, the chart will apear grey",
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold))),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
