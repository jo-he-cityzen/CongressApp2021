import 'package:flutter/foundation.dart';
import '../models/student.dart';

enum personOptions { absent, present, tardy }

class attendance {
  Students student;
  DateTime date;
  personOptions status;
  String blockId = "attendance";
  attendance(
      {
      @required this.student,
      @required this.date,
      @required this.status,
      }
  );
}

class attendanceUiModel {
 Students student;
  String month;
  String day;
  String hour;
  String minute;
  personOptions status;
  String blockId = "attendance";
  attendanceUiModel(
      {
      @required this.month,
      @required this.day,
      @required this.hour, 
      @required this.minute,
      @required this.student,
      @required this.status,
      }
  );
}
