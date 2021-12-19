import 'dart:io';

import '../models/student.dart';
import 'package:flutter/material.dart';

class StudentWidget extends StatelessWidget {
  @override
  double givenHeight;
  Students student;
  Color mainColor;
  StudentWidget(this.givenHeight, this.student, this.mainColor);
  Widget build(BuildContext context) {
    return Container(
      width : double.infinity, 
      height: givenHeight,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), 
        border: Border.all(color: mainColor, width: 5)
      ),
      padding: EdgeInsets.fromLTRB(0, 10, 40, 10),
      child : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children : [

            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              
              child: Image.network(student.studentimagePath,
               height: givenHeight*0.9, 
               width : givenHeight*0.9, 
               fit : BoxFit.cover,),                
            ),
          Column(
            mainAxisAlignment : MainAxisAlignment.center,
            children : [
            Text(
             student.firtstName, 
              style: TextStyle(
                  fontFamily: "QuickSand",
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)
            ), 
            Text(
             student.lasttName, 
              style: TextStyle(
                  fontFamily: "QuickSand",
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)
            )
            ]
          )
        ]
      )
    );
  }
}