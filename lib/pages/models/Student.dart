import 'package:flutter/foundation.dart';

class Students {
  final String firtstName;
  final String lasttName;
  final List embeddings;
  final String studentimagePath;
  final int tardy;
  final int present;
  final int absent;
  final String id;
  final int breaks;
  Students({
    @required this.firtstName,
    @required this.lasttName,
    @required this.embeddings,
    @required this.studentimagePath, 
    @required this.present, 
    @required this.absent,
    @required this.id,
    @required this.tardy, 
    @required this.breaks,
  });
}
