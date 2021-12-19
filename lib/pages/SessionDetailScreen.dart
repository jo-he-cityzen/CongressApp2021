import 'package:face_net_authentication/pages/StudentAnalysisScreen.dart';
import 'package:face_net_authentication/pages/widgets/presentAbsentWidget.dart';
import 'package:pie_chart/pie_chart.dart';
import 'models/AttendanceBlocks.dart';
import "package:flutter/material.dart";

import 'models/student.dart';

class SessionDetailScreen extends StatefulWidget {
  List presentStream;
  List absentStream;
  List tardyStream;
  int presentNum;
  int tardyNum;
  int absentNum;
  SessionDetailScreen(this.presentStream, this.absentStream, this.tardyStream,
      this.presentNum, this.tardyNum, this.absentNum);
  @override
  _SessionDetailScreenState createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  @override
  int currentTab = 0;
  List presentColor = [Colors.cyanAccent[100], Colors.white, Colors.white];
  List absentColor = [
    Colors.white,
    Colors.white,
    Colors.cyanAccent[100],
  ];
  List tardyColor = [Colors.white, Colors.cyanAccent[100], Colors.white];
  streamThing(currentTab1) {
    if (currentTab1 == 0) {
      return widget.presentStream.map((data) {
        print(data);
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
          child: PresentUiBlocks(
              data.student,
              MediaQuery.of(context).size.width * 0.85,
              MediaQuery.of(context).size.height * 0.1,
              data.month,
              data.day,
              data.hour,
              data.minute,
              personOptions.present,
              MediaQuery.of(context).textScaleFactor,
              Colors.blue),
        );
      }).toList();
    } else if (currentTab1 == 1) {
      return widget.tardyStream.map((data) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
          child: PresentUiBlocks(
              data.student,
              MediaQuery.of(context).size.width * 0.85,
              MediaQuery.of(context).size.height * 0.1,
              data.month,
              data.day,
              data.hour,
              data.minute,
              personOptions.tardy,
              MediaQuery.of(context).textScaleFactor,
              Colors.blue),
        );
      }).toList();
    } else {
      return widget.absentStream.map((data) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
          child: PresentUiBlocks(
              data.student,
              MediaQuery.of(context).size.width * 0.85,
              MediaQuery.of(context).size.height * 0.1,
              data.month,
              data.day,
              "0",
              "0",
              personOptions.absent,
              MediaQuery.of(context).textScaleFactor,
              Colors.blue),
        );
      }).toList();
    }
  }

  Widget build(BuildContext context) {
    // pie chart code
    Map<String, double> dataMap = {
      "Absent": widget.absentNum.toDouble(),
      "Tardy": widget.tardyNum.toDouble(),
      "Present": widget.presentNum.toDouble(),
    };
    double percent = 0.00;
    List<Color> colorList = [Colors.red, Colors.orange, Colors.green];
    ChartType _chartType = ChartType.disc;
    bool _showCenterText = true;
    double _chartLegendSpacing = 32;
    bool _showLegendsInRow = true;
    bool _showLegends = true;
    bool _showChartValueBackground = true;
    bool _showChartValues = false;
    bool _showChartValuesInPercentage = true;
    bool _showChartValuesOutside = false;
    LegendShape _legendShape = LegendShape.Circle;
    LegendPosition _legendPosition = LegendPosition.bottom;
    int key = 0;
    final chart = PieChart(
        key: ValueKey(key),
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 3,
        chartRadius: MediaQuery.of(context).size.height * 0.18,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: _chartType,
        centerText: null,
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
            fontSize: 10
          ),
        ));

    return Scaffold(
        appBar: AppBar(
          title: Text("session analysis screen"),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child:
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

            Container(
          //      padding: EdgeInsets.only(right : 5),
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    chart,
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("present",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20 *
                                          MediaQuery.of(context)
                                              .textScaleFactor)),
                              SizedBox(width: 20),
                              Text(widget.presentNum.toString(),
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20 *
                                          MediaQuery.of(context)
                                              .textScaleFactor)),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("absent",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20 *
                                          MediaQuery.of(context)
                                              .textScaleFactor)),
                              SizedBox(width: 25),
                              Text(widget.absentNum.toString(),
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20 *
                                          MediaQuery.of(context)
                                              .textScaleFactor)),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("tardy",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20 *
                                          MediaQuery.of(context)
                                              .textScaleFactor)),
                              SizedBox(width: 37),
                              Text(widget.tardyNum.toString(),
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20 *
                                          MediaQuery.of(context)
                                              .textScaleFactor)),
                            ],
                          )
                        ]),
                  ],
                ), ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.06,
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              currentTab = 0;
                            });
                          },
                          child: Text("present",
                              style: TextStyle(
                                  fontFamily: "QuickSand",
                                  color: presentColor[currentTab],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                        ),
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              currentTab = 1;
                            });
                          },
                          child: Text("tardy",
                              style: TextStyle(
                                  fontFamily: "QuickSand",
                                  color: tardyColor[currentTab],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                        ),
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              currentTab = 2;
                            });
                          },
                          child: Text("absent",
                              style: TextStyle(
                                  fontFamily: "QuickSand",
                                  color: absentColor[currentTab],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.48,
                    color: Colors.white,
                    child: ListView(
                      children: [...streamThing(currentTab)],
                    ),
                  )
                ],
              ),
            )
          ]),
        ));
  }
}
