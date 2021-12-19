import 'dart:io';

import 'package:face_net_authentication/pages/models/Sessions.dart';

import '../SessionDetailScreen.dart';
import '../models/student.dart';
import 'package:flutter/material.dart';

class sessionWidget extends StatelessWidget {
  @override
  double givenHeight;
  session cursession;
  Color mainColor;
  sessionWidget(this.givenHeight, this.cursession, this.mainColor);
  Widget build(BuildContext context) {
    return InkWell(
      onTap : (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => SessionDetailScreen(cursession.presentStream, cursession.absentStream, cursession.tardyStream, cursession.presentNum, cursession.tardyNum, cursession.absentNum))
        );
      },
      child: Container(
        width : double.infinity, 
        height: givenHeight,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), 
          border: Border.all(color: mainColor, width: 5)
        ),
        padding: EdgeInsets.fromLTRB(0, 10, 40, 10),
        child : Center(
          child : Text(
               cursession.month.toString() + "/" + cursession.day.toString() + "/" + DateTime.now().year.toString() + " " + cursession.hour.toString() + ":" + cursession.minute.toString(),
                style: TextStyle(
                    fontFamily: "QuickSand",
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)
              )
        )
      ),
    );
  }
}