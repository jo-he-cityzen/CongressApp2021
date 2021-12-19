import 'Widgets/StudentWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/student.dart';

class StudentsScreen extends StatefulWidget {
  @override
  Color mainColor;
  double height;
  String id;
  StudentsScreen(this.mainColor, this.height, this.id);
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List studentList = [];
  Future<void> getData() async {
    Uri Url = Uri.parse(
        "https://attendgo-7611e-default-rtdb.firebaseio.com/students/" +
            widget.id +
            ".json");
    try {
      print("there");
      final response = await http.get(Url);
      print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print("there");
      extractedData.forEach((key, value) {
        studentList.add(Students(
          studentimagePath: value["imagePath"], 
          firtstName: value["First Name"], 
          lasttName: value["Last Name"], 
          embeddings: [], 
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
      print(err.toString() + "where");
      studentList = [];
    }
  }
  void initState(){
   getData();
   print(studentList);
   super.initState();
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
          child: ListView.builder(
          itemBuilder : (bld, ind){
              Students student = studentList[ind]; 
              return 
              InkWell(child: StudentWidget(widget.height * 0.15, student, widget.mainColor), onTap: (){
                Navigator.of(context).pushNamed("StudentAnalysis", arguments: [widget.mainColor, student]);
              },);

          },
          itemCount: studentList.length
          )

        ),
        Container(
        height: widget.height * 0.07,
        width: widget.height * 0.07,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed("CreateStudent",
                  arguments: [widget.id, widget.mainColor, addPerson]);
            },

            child: Icon(Icons.person_add),
            backgroundColor: widget.mainColor,
          ),
        ),
      ),
        
      ],
    );
  }
}
