import 'package:face_net_authentication/pages/models/student.dart';

class session {
  final int month;
  final int day;
  final int hour;
  final int minute;
  final List presentStream;
  final List absentStream;
  final List tardyStream;
  final int presentNum;
  final int absentNum;
  final int tardyNum;
  session(
      this.month,
      this.day,
      this.hour,
      this.minute,
      this.presentStream,
      this.absentStream,
      this.tardyStream,
      this.presentNum,
      this.absentNum,
      this.tardyNum);
}
