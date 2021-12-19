import 'package:camera/camera.dart';
import 'package:face_net_authentication/pages/LiveDetectionScreen.dart';
import 'package:face_net_authentication/pages/widgets/sessionWidget.dart';
import 'package:face_net_authentication/services/facenet.service.dart';
import 'package:face_net_authentication/services/ml_kit_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Widgets/StudentWidget.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'models/AttendanceBlocks.dart';
import 'models/Sessions.dart';
import 'models/student.dart';

class SessionsScreen extends StatefulWidget {
  @override
  Color mainColor;
  double height;
  String id;
  SessionsScreen(this.mainColor, this.height, this.id);
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  List<Students> studentList  = [];
  List sessionList = [];
  CameraDescription cameraDescription;
  Future<void> getData() async {
    FaceNetService _faceNetService = FaceNetService();
    MLKitService _mlKitService = MLKitService();
    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = await cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    _mlKitService.initialize();
    Uri Url = Uri.parse(
        "https://attendgo-7611e-default-rtdb.firebaseio.com/students/" +
            widget.id +
            ".json");
    Uri Url2 = Uri.parse(
      "https://attendgo-7611e-default-rtdb.firebaseio.com/sessions/" + widget.id + ".json"
    );
    try {
      final response = await http.get(Url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((key, value) {
        studentList.add(Students(
          studentimagePath: value["imagePath"], 
          firtstName: value["First Name"], 
          lasttName: value["Last Name"], 
          embeddings: value["embedding"], 
          absent: value["absent"], 
          present: value['attendance'], 
          id: key, 
          tardy: value["tardy"], 
          breaks : value["break"]
        ));
      });
      setState((){
        studentList;
      });
    }
    catch(err){
      studentList = [];
    }
    
    try{
      final Sessionresponse = await http.get(Url2);
      final extractedSessions = json.decode(Sessionresponse.body) as Map;
      extractedSessions.forEach(
        (key, mapList){
          List tempPresentList = [];
          List tempTardyList = [];
          List tempAbsentList = [];
          if(mapList["present"] != 0){
            for(int i = 0; i < (mapList["present"] as List).length; i++){
              String studentId = mapList["present"][i]["student"];
               tempPresentList.add(attendanceUiModel(
                month: mapList["present"][i]["month"].toString(), 
                day :  mapList["present"][i]["day"].toString(),
                hour:  mapList["present"][i]["hour"].toString(), 
                minute: mapList["present"][i]["mintue"].toString(),
                status: personOptions.present, 
                student: studentList.firstWhere((data) => data.id == studentId) as Students
              ));
          }
          
          } else{
            tempPresentList = [];
          }
          if(mapList["tardy"] != 0){
            for(int i = 0; i < (mapList["tardy"] as List).length; i++){
              String studentId = mapList["tardy"][i]["student"];
              tempTardyList.add(attendanceUiModel(
                month: mapList["tardy"][i]["month"].toString(), 
                day :  mapList["tardy"][i]["day"].toString(),
                hour:  mapList["tardy"][i]["hour"].toString(), 
                minute: mapList["tardy"][i]["minute"].toString(),
                status: personOptions.tardy, 
                student: studentList.firstWhere((data) => data.id == studentId) as Students
              ));
          }} else{
            tempTardyList = [];
          }
          if(mapList["absent"] != 0){
            for(int i = 0; i < (mapList["absent"] as List).length; i++){
              String studentId = mapList["absent"][i]["student"];
              tempAbsentList.add(attendanceUiModel(
                month: mapList["absent"][i]["month"].toString(), 
                day :  mapList["absent"][i]["day"].toString(),
                hour:  mapList["absent"][i]["hour"].toString(), 
                minute: mapList["absent"][i]["minute"].toString(),
                status: personOptions.absent, 
                student: studentList.firstWhere((data) => data.id == studentId) as Students
              ));
          }} else{
            tempAbsentList = [];
          } 
          sessionList.add(
            session(
              int.parse(mapList["basic info"]["month"]), 
              int.parse(mapList["basic info"]["day"]), 
              int.parse(mapList["basic info"]["hour"]), 
              int.parse(mapList["basic info"]["minute"]), 
              tempPresentList, 
              tempAbsentList, 
              tempTardyList, 
              mapList["basic info"]["present"], 
              mapList["basic info"]["absent"], 
              mapList["basic info"]["tardy"]
            )
          );
          setState((){
          sessionList;
          });
        }
      );

    }
    catch(err){
    } 
  }
  void initState(){
   getData();
   super.initState();
  }
  void addSession(session newSession){
    setState(() {
      sessionList.add(newSession);
    });
  }
  void addPerson(Students student){
    studentList.add(student);
    setState(() {
      studentList;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widget.height * 0.86,
          child : ListView.builder(itemBuilder: (_, ind){
            return sessionWidget(widget.height * 0.15, sessionList[ind],widget.mainColor);
          }, itemCount: sessionList.length,)
        ),
        Container(
        height: widget.height * 0.07,
        width: widget.height * 0.07,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder : (ctx){
                    return LiveDetectionScreen(cameraDescription, studentList, widget.mainColor, widget.id, addSession);
                  }
                )
              );
            },

            child: Icon(Icons.add),
            backgroundColor: widget.mainColor,
          ),
          )
        )
        
      ],
    );
  }
}