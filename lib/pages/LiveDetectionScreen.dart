import 'dart:convert';
import 'dart:io';
import 'package:face_net_authentication/pages/widgets/FacePainter.dart';
import 'package:face_net_authentication/pages/widgets/camera_header.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/facenet.service.dart';
import 'package:face_net_authentication/services/ml_kit_service.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'models/Sessions.dart';
import 'widgets/presentAbsentWidget.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'models/AttendanceBlocks.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'models/student.dart';

class LiveDetectionScreen extends StatefulWidget {
  final CameraDescription cameraDescription;
  final List student;
  final Color color;
  final String classId;
  final Function addSession;
  const LiveDetectionScreen(this.cameraDescription, this.student, this.color,
      this.classId, this.addSession);

  @override
  LiveDetectionScreenState createState() => LiveDetectionScreenState();
}

class LiveDetectionScreenState extends State<LiveDetectionScreen> {
  @override
  Face faceDetected;
  Size imageSize;
  List studentInFrame = [];
  List id = [];
  DateTime startTime;
  List studentEmbedding = [];
  List embedding = [];
  List firstName = [];
  List lastName = [];
  List status = [];
  bool loading = false;
  List<attendance> presentStream = [];
  int currentTab = 0;
  List presentColor = [Colors.cyanAccent[100], Colors.white, Colors.white];
  List absentColor = [
    Colors.white,
    Colors.white,
    Colors.cyanAccent[100],
  ];
  List tardyColor = [Colors.white, Colors.cyanAccent[100], Colors.white];
  List presentStreamId = [];
  List absentStream = [];
  List absentStreamId = [];
  bool isTardy = false;
  List tardyStram = [];

  get presentStreamMap => null;

  setUpVariables() {
    List studentsList = widget.student;
    for (int i = 0; i < studentsList.length; i++) {
      Students student = studentsList[i];
      id.add(student.id);
      startTime = DateTime.now();
      studentEmbedding.add([student.id, student.embeddings]);
      firstName.add(student.firtstName);
      lastName.add(student.lasttName);
      status.add(personOptions.absent);
      absentStreamId.add(student.id);
      absentStream.add(attendance(
          date: DateTime.now(),
          status: personOptions.absent,
          student: student));
    }
  }

  bool _detectingFaces = false;
  bool pictureTaked = false;

  Future _initializeControllerFuture;
  bool cameraInitializated = false;
  MLKitService _mlKitService = MLKitService();
  CameraService _cameraService = CameraService();
  FaceNetService _faceNetService = FaceNetService();
  streamThing(currentTab1) {
    if (currentTab1 == 0) {
      return presentStream.map((data) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
          child: PresentAbsentBlocks(
              data.student,
              MediaQuery.of(context).size.width * 0.85,
              MediaQuery.of(context).size.height * 0.07,
              data.date,
              personOptions.present,
              MediaQuery.of(context).textScaleFactor,
              widget.color),
        );
      }).toList();
    } else if (currentTab1 == 1) {
      return tardyStram.map((data) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
          child: PresentAbsentBlocks(
              data.student,
              MediaQuery.of(context).size.width * 0.85,
              MediaQuery.of(context).size.height * 0.07,
              data.date,
              personOptions.tardy,
              MediaQuery.of(context).textScaleFactor,
              widget.color),
        );
      }).toList();
    } else if (absentStream != null) {
      return absentStream.map((data) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
          child: PresentAbsentBlocks(
              data.student,
              MediaQuery.of(context).size.width * 0.85,
              MediaQuery.of(context).size.height * 0.07,
              data.date,
              personOptions.absent,
              MediaQuery.of(context).textScaleFactor,
              widget.color),
        );
      }).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    setUpVariables();
    _start();
  }

  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraService.dispose();
    super.dispose();
  }

  /// starts the camera & start framing faces
  _start() async {
    _initializeControllerFuture =
        _cameraService.startService(widget.cameraDescription);

    await _initializeControllerFuture;

    setState(() {
      cameraInitializated = true;
    });

    _frameFaces();
  }

  _frameFaces() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        // if its currently busy, avoids overprocessing
        if (_detectingFaces) return;
        _detectingFaces = true;

        try {
          List<Face> faces = await _mlKitService.getFacesFromImage(image);
          int personInFrame;
          if (faces.length > 0) {
            setState(() {
              faceDetected = faces[0];
            });
            _faceNetService.setCurrentPrediction(image, faceDetected);
            personInFrame = _faceNetService.searchResult2(
                _faceNetService.predictedData, studentEmbedding);
            int ind = absentStreamId.indexOf(id[personInFrame]);
            absentStreamId.removeAt(ind);
            var lateTime = DateTime.now().difference(startTime);
            if (presentStream.length == 0) {
              if (lateTime.inMinutes >= 5) {
                setState(() {
                  print(isTardy.toString() + "this is is tardy");
                  isTardy = true;
                  tardyStram.add(attendance(
                      date: DateTime.now(),
                      status: personOptions.tardy,
                      student: widget.student[personInFrame]));
                  presentStreamId.add(id[personInFrame]);
                  status[personInFrame] = personOptions.tardy;
                  absentStream.removeAt(ind);
                });
              } else {
                setState(() {
                  presentStream.add(attendance(
                      date: DateTime.now(),
                      status: personOptions.present,
                      student: widget.student[personInFrame]));
                  presentStreamId.add(id[personInFrame]);
                  status[personInFrame] = personOptions.present;
                  absentStream.removeAt(ind);
                });
              }
            } else if (presentStreamId.contains(id[personInFrame])) {
            } else {
              if (lateTime.inMinutes >= 5) {
                setState(() {
                  tardyStram.add(attendance(
                      date: DateTime.now(),
                      status: personOptions.tardy,
                      student: widget.student[personInFrame]));
                  presentStreamId.add(id[personInFrame]);
                  status[personInFrame] = personOptions.tardy;
                  absentStream.removeAt(ind);
                });
              } else {
                setState(() {
                  presentStream.add(attendance(
                      date: DateTime.now(),
                      status: personOptions.present,
                      student: widget.student[personInFrame]));
                });
                status[personInFrame] = personOptions.present;
                presentStreamId.add(id[personInFrame]);
                absentStream.removeAt(ind);
              }
            }
          } else {
            setState(() {
              faceDetected = null;
            });
          }

          _detectingFaces = false;
        } catch (e) {
          _detectingFaces = false;
        }
      }
    });
  }

  _onBackPressed() async {
    int presentTotal = 0;
    int absentTotal = 0;
    int tardyTotal = 0;
    setState(() {
      loading = true;
    });
    for (int i = 0; i < status.length; i++) {
      Students curStudent = widget.student[i];
      int present = curStudent.present;
      int absent = curStudent.absent;
      int tardy = curStudent.tardy;
      if (status[i] == personOptions.absent) {
        absent++;
        absentTotal++;
      } else if (status[i] == personOptions.present) {
        present++;
        presentTotal++;
      } else {
        tardy++;
        tardyTotal++;
      }
      Students newStudent = Students(
          absent: absent,
          present: present,
          tardy: tardy,
          breaks: 0,
          embeddings: curStudent.embeddings,
          firtstName: curStudent.firtstName,
          lasttName: curStudent.lasttName,
          id: curStudent.id,
          studentimagePath: curStudent.studentimagePath);
      Uri tempUrl = Uri.parse(
          "https://attendgo-7611e-default-rtdb.firebaseio.com/students/" +
              widget.classId +
              "/" +
              widget.student[i].id +
              ".json");
      await http.patch(tempUrl,
          body: jsonEncode({
            'First Name': newStudent.firtstName,
            'Last Name': newStudent.lasttName,
            'imagePath': newStudent.studentimagePath,
            'embedding': newStudent.embeddings,
            'attendance': newStudent.present,
            'absent': newStudent.absent,
            'tardy': newStudent.tardy,
            'break': 0,
          }));
    }
    Uri sessionUrl = Uri.parse(
        "https://attendgo-7611e-default-rtdb.firebaseio.com/sessions/" +
            widget.classId +
            ".json");
    final Map presentStreammap = {};
    final Map tradyStreammap = {};
    final Map absentStreammap = {};
    List tempAbsentStream = [];
    List tempTardyStream = [];
    List tempPresentStream = [];
    var presentStreamval;
    var tardyStreamval;
    var absentStreamval;
    print("here");
    for (int l = 0; l < presentStream.length; l++) {
      tempPresentStream.add(attendanceUiModel(
          day: presentStream[l].date.day.toString(),
          hour: presentStream[l].date.hour.toString(),
          month: presentStream[l].date.month.toString(),
          minute: presentStream[l].date.minute.toString(),
          student: presentStream[l].student,
          status: personOptions.present));
      presentStreammap[l.toString()] = {
        'student': presentStream[l].student.id.toString(),
        'month': presentStream[l].date.month.toString(),
        'day': presentStream[l].date.day,
        'hour': presentStream[l].date.hour,
        'mintue': presentStream[l].date.minute
      };
    }
    print("here2");
    print(presentStreamMap);
    if (absentStream.length != 0) {
      for (int w = 0; w < absentStream.length; w++) {
          tempAbsentStream.add(attendanceUiModel(
          day: absentStream[w].date.day.toString(),
          hour: absentStream[w].date.hour.toString(),
          month: absentStream[w].date.month.toString(),
          minute: absentStream[w].date.minute.toString(),
          student: absentStream[w].student,
          status: personOptions.absent));
        absentStreammap[w.toString()] = {
          'student': absentStream[w].student.id.toString(),
          'month': absentStream[w].date.month.toString(),
          'day': absentStream[w].date.day,
          'hour': absentStream[w].date.hour,
          'mintue': absentStream[w].date.minute
        };
      }
      absentStreamval = absentStreammap;
    } else {
      absentStreamval = 0;
    }
    print("here3");
    if (isTardy == true) {
      for (int i = 0; i < tardyStram.length; i++) {
         tempTardyStream.add(attendanceUiModel(
          day: tardyStram[i].date.day.toString(),
          hour: tardyStram[i].date.hour.toString(),
          month: tardyStram[i].date.month.toString(),
          minute: tardyStram[i].date.minute.toString(),
          student: tardyStram[i].student,
          status: personOptions.tardy));
        tradyStreammap[i.toString()] = {
          'student': tardyStram[i].student.id.toString(),
          'month': tardyStram[i].date.month.toString(),
          'day': tardyStram[i].date.day,
          'hour': tardyStram[i].date.hour,
          'mintue': tardyStram[i].date.minute
        };
        tardyStreamval = tradyStreammap;
      }
    } else {
      tardyStreamval = 0;
    }
    tardyStreamval = 0;
    http.post(sessionUrl,
        body: jsonEncode({
          "basic info": {
            "present": presentTotal,
            "absent": absentTotal,
            "tardy": tardyTotal,
            "month": startTime.month.toString(),
            "day": startTime.day.toString(),
            "year": startTime.year.toString(),
            "hour": startTime.hour.toString(),
            "minute": startTime.minute.toString(),
          },
          "present": presentStreammap,
          "absent": absentStreamval,
          "tardy": tardyStreamval,
        }));
    setState(() {
      loading = false;
    });
    widget.addSession(session(startTime.month, startTime.day, startTime.hour, startTime.minute, tempPresentStream, tempAbsentStream, tempTardyStream, presentTotal, absentTotal, tardyTotal));
    Navigator.of(context).pop();
  }

  _reload() {
    setState(() {
      cameraInitializated = false;
      pictureTaked = false;
    });
    this._start();
  }

  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  loading == false) {
                if (pictureTaked) {
                  return Container(
                    width: width,
                    height: height,
                    child: Transform(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.cover,
                        ),
                        transform: Matrix4.rotationY(mirror)),
                  );
                } else {
                  return Transform.scale(
                    scale: 1.0,
                    child: AspectRatio(
                      aspectRatio: MediaQuery.of(context).size.aspectRatio,
                      child: OverflowBox(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Container(
                            width: width,
                            height: width *
                                _cameraService
                                    .cameraController.value.aspectRatio,
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                CameraPreview(_cameraService.cameraController),
                                /* CustomPaint(
                                  painter: FacePainter(
                                      face: faceDetected, imageSize: imageSize),
                                ),*/
                                Positioned(
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.01,
                                  left: MediaQuery.of(context).size.width * 0.1,
                                  right:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.95,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.06,
                                          color: widget.color,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
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
                                                        color: presentColor[
                                                            currentTab],
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                        color: tardyColor[
                                                            currentTab],
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                        color: absentColor[
                                                            currentTab],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.95,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.29,
                                          color: Colors.white,
                                          child: ListView(
                                            children: [
                                              ...streamThing(currentTab)
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          CameraHeader(
            "Attendance",
            onBackPressed: _onBackPressed,
          )
        ],
      ),
    );
  }
}
