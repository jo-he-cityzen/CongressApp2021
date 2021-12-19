import 'package:face_net_authentication/pages/models/student.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/student.dart';
import '../models/AttendanceBlocks.dart';

class PresentAbsentBlocks extends StatelessWidget {
  Students student;
  var width;
  var height;
  DateTime date;
  personOptions status;
  var childTextFactor;
  Color color;
  PresentAbsentBlocks(this.student, this.width, this.height, this.date,
      this.status, this.childTextFactor, this.color);
  @override
  Widget build(BuildContext context) {
    if (status == personOptions.present) {
      return Container(
        width: width,
        height: height,
        padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 4),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(student.firtstName + " " + student.lasttName,
              style: TextStyle(
                  fontFamily: "QuickSand",
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          Text(date.hour.toString() + ":" + date.minute.toString(),
              style: TextStyle(
                  fontFamily: "QuickSand",
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20))
        ]),
      );
    } else if (status == personOptions.absent) {
      return Container(
        width: width,
        height: height,
        padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 4),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(student.firtstName + " " + student.lasttName,
              style: TextStyle(
                  fontFamily: "QuickSand",
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          Text(
              date.month.toString() +
                  "/" +
                  date.day.toString() +
                  "/" +
                  date.year.toString(),
              style: TextStyle(
                  fontFamily: "QuickSand",
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15))
        ]),
      );
    } else {
      return Container(
        width: width,
        height: height,
        padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.orange, width: 4),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(student.firtstName + " " + student.lasttName,
              style: TextStyle(
                  fontFamily: "QuickSand",
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          Text(date.hour.toString() + ":" + date.minute.toString(),
              style: TextStyle(
                  fontFamily: "QuickSand",
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 20))
        ]),
      );
    }
  }
}

class PresentUiBlocks extends StatelessWidget {
  Students student;
  var width;
  var height;
  String month;
  String day;
  String hour;
  String minute;
  personOptions status;
  var childTextFactor;
  Color color;
  PresentUiBlocks(this.student, this.width, this.height, this.month, this.day, this.hour, this.minute,
      this.status, this.childTextFactor, this.color);
  @override
  Widget build(BuildContext context) {
    if (status == personOptions.present) {
      return Container(
        width: width,
        height: height,
        padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 4),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(student.firtstName + " " + student.lasttName,
              style: TextStyle(
                  fontFamily: "QuickSand",
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 28)),
          Text(hour.toString() + ":" + minute.toString(),
              style: TextStyle(
                  fontFamily: "QuickSand",
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 25))
        ]),
      );
    } else if (status == personOptions.absent) {
      return Container(
        width: width,
        height: height,
        padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 4),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(student.firtstName + " " + student.lasttName,
              style: TextStyle(
                  fontFamily: "QuickSand",
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 24)),
          Text(
              month.toString() +
                  "/" +
                  day.toString() +
                  "/" +
                  DateTime.now().year.toString(),
              style: TextStyle(
                  fontFamily: "QuickSand",
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 22))
        ]),
      );
    } else {
      return Container(
        width: width,
        height: height,
        padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.orange, width: 4),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(student.firtstName + " " + student.lasttName,
              style: TextStyle(
                  fontFamily: "QuickSand",
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 27)),
          Text(hour.toString() + ":" + minute.toString(),
              style: TextStyle(
                  fontFamily: "QuickSand",
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 25))
        ]),
      );
    }
  }
}
