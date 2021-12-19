import 'dart:typed_data';
import 'package:face_net_authentication/pages/sign-up.dart';

import 'models/student.dart';
import 'package:face_net_authentication/services/ml_kit_service.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:face_net_authentication/services/facenet.service.dart';

class CreateStudentPage extends StatefulWidget {
  @override
  _CreateStudentPageState createState() => _CreateStudentPageState();
}

class _CreateStudentPageState extends State<CreateStudentPage> {
  @override
  CameraDescription cameraDescription;
  void initState() {
    super.initState();
    _startUp();
  }
  FaceNetService _faceNetService = FaceNetService();
  _startUp() async {
    FaceNetService _faceNetService = FaceNetService();
    MLKitService _mlKitService = MLKitService();
    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = await cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );
    print(cameraDescription);

    // start the services
    await _faceNetService.loadModel();
    _mlKitService.initialize();
  }

  bool isPicked = false;
  List embedding = null;
  int started = 0;
  XFile pickDImage;
  File pickedImage;
  void chooseImage(XFile img) {
    setState(() {
      pickedImage = File(img.path);
      setState(() {
        isPicked = true;
      });
    });
  }

  Future pickImage() async {
    if (cameraDescription != null) {
     
    } else {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              title: Text("ERROR",
                  style: TextStyle(
                      fontFamily: "QuickSand",
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              content: Text("camera wrong",
                  style: TextStyle(
                      fontFamily: "QuickSand",
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 10)),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok"))
              ]);
        },
        barrierDismissible: false,
      );
    }
  }

  final studentFirstName = TextEditingController();
  final studentLasttName = TextEditingController();
  final List<String> items = ["Select Grade", "1", "2", "3", "4", '5', '6', '7', '8', '9', '10', '11', '12'];
  String itemValue = "Select Grade";
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context).settings.arguments as List;
    String id = data[0];
    Uri Url = Uri.parse(
        "https://attendgo-7611e-default-rtdb.firebaseio.com/students/" +
            id +
            ".json");
    Color classColor = data[1];
    Function addClass = data[2];
    Color fColor = classColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: classColor,
        title: Text("Attendance App",
            style: TextStyle(
                fontFamily: "QuickSand",
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: classColor,
            radius: MediaQuery.of(context).size.width * 0.17,
            backgroundImage: isPicked != false ? FileImage(pickedImage) : null,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          FlatButton(
              onPressed: () {
                Navigator.push(
                  
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SignUp(
                                   cameraDescription,chooseImage
                                ),
                              ),
                            );
              },
              child: Text("Capture Image",
                  style: TextStyle(
                      fontFamily: "QuickSand",
                      color: classColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 25))),
          Padding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.2,
              MediaQuery.of(context).size.height * 0.02,
              MediaQuery.of(context).size.width * 0.2,
              MediaQuery.of(context).size.height * 0.02,
            ),
            child: TextField(
              controller: studentFirstName,
              style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  color: fColor),
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: fColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: fColor),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: fColor),
                  ),
                  icon: Icon(Icons.person, color: fColor, size: 40),
                  labelText: 'Student First Name',
                  fillColor: fColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.2,
                0,
                MediaQuery.of(context).size.width * 0.2,
                0),
            child: TextField(
              controller: studentLasttName,
              style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  color: fColor),
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: fColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: fColor),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: fColor),
                  ),
                  icon: Icon(Icons.person, color: fColor, size: 40),
                  labelText: 'Student Last Name',
                  fillColor: fColor),
            ),
          ), 
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),          
          Container(
            decoration : BoxDecoration(
              border: Border.all(color : classColor, width: 4), 
              borderRadius: BorderRadius.circular(12)
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.symmetric(horizontal: 72),
            child: DropdownButton<String>(
              onChanged : (value) => setState(() => itemValue = value),
              isExpanded: true,
              icon : Icon(Icons.arrow_drop_down, color : Colors.black),
              iconSize : 20,
              value : itemValue,
              items: this.items.map(
              (String items){
                return DropdownMenuItem<String>(
                  value : items
                  ,child: 
                  Text(
                    items, 
                    style : TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize : 15,
                    )
                  )
                );
              }
            ).toList(),
            ),
          ), 
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          embedding = _faceNetService.predictedData;
          if (studentLasttName != null &&
              studentFirstName != null &&
              isPicked != false && embedding != null) {
          await Firebase.initializeApp();
          final firstUrl = await firebase_storage.FirebaseStorage.instance
                .ref()
                .child('student image')
                .child(studentFirstName.text +
                    studentLasttName.text +
                    id.toString()+
                    '.jpg');
          firebase_storage.UploadTask uploadTask = firstUrl.putFile(pickedImage);
          uploadTask.whenComplete(() async {
              final finalUrl = await firstUrl.getDownloadURL();
              addClass(Students(
                  firtstName: studentFirstName.text,
                  lasttName: studentLasttName.text,
                  embeddings: embedding,
                  studentimagePath:finalUrl,
                  present: 0,
                  absent: 0,
                  id: "id",
                  tardy: 0,
                  breaks: 0));
              print("here");
              http.post(Url,
                  body: jsonEncode({
                    'First Name': studentFirstName.text,
                    'Last Name': studentLasttName.text,
                    'imagePath': finalUrl,
                    'embedding': embedding,
                    'attendance': 0,
                    'absent': 0,
                    'tardy': 0,
                    'break': 0,
                  }));
              
              Navigator.of(context).pop();
            });
          } else {
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                    title: Text("ERROR",
                        style: TextStyle(
                            fontFamily: "QuickSand",
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    content: Text("Make sure that you fill out all the fields",
                        style: TextStyle(
                            fontFamily: "QuickSand",
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 10)),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Ok"))
                    ]);
              },
              barrierDismissible: false,
            );
          }
        },
        backgroundColor: classColor,
        child: Icon(
          Icons.person_add,
          color: Colors.white,
        ),
      ),
    );
  }
}
/* ,*/
/*             }*/
