import 'models/Class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';

class createClassScreen extends StatefulWidget {
  @override
  _createClassScreenState createState() => _createClassScreenState();
}

class _createClassScreenState extends State<createClassScreen> {
  @override
  Classes newClass;
  Color classColor = Colors.blue;
  final className = TextEditingController();
  bool privacy = false;
  Color fColor = Colors.blue;
  bool isTurnOn = false;
  Map<String, Color> listColor = {
    "MaterialColor(primary value: Color(0xff2196f3))": Colors.blue,
    "MaterialColor(primary value: Color(0xfff44336))": Colors.red,
    "MaterialColor(primary value: Color(0xffffeb3b))": Colors.yellow,
    "MaterialColor(primary value: Color(0xffe91e63))": Colors.pink,
    "MaterialColor(primary value: Color(0xffff9800))": Colors.orange,
    "MaterialColor(primary value: Color(0xff9c27b0))": Colors.purple,
    "MaterialColor(primary value: Color(0xff009688))": Colors.teal,
    "MaterialAccentColor(primary value: Color(0xffb2ff59))":
        Colors.lightGreenAccent
  };
  Object get value => null;
  Widget build(BuildContext context) {
    final addClass = ModalRoute.of(context).settings.arguments as Function;
    var appBarCode = AppBar(
          title: Text("Create Class",
              style: TextStyle(
                  fontFamily: "QuickSand",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)));
    return Scaffold(
      appBar: appBarCode,
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.1,
            MediaQuery.of(context).size.height * 0.1,
            MediaQuery.of(context).size.width * 0.1,
            MediaQuery.of(context).size.height * 0.1),
        child: Container(
          height : MediaQuery.of(context).size.height * 0.9 ,
          child: ListView(
             // mainAxisAlignment: MainAxisAlignment.center,
             // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1,
                      right: MediaQuery.of(context).size.width * 0.1),
                  child: TextField(
                    controller: className,
                    style: TextStyle(
                        fontFamily: "Quicksand", fontWeight: FontWeight.bold),
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
                        icon: Icon(
                          Icons.class_,
                          color: fColor,
                        ),
                        labelText: 'Name of Class',
                        fillColor: fColor),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Can Share",
                        style: TextStyle(
                            fontFamily: "QuickSand",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                20 * MediaQuery.of(context).textScaleFactor)),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Switch(
                        value: isTurnOn,
                        onChanged: (onChanged) => setState(() {
                              isTurnOn = onChanged;
                              privacy = onChanged;
                            })),
                  ],
                ),
                //      SizedBox(height: MediaQuery.of(context).size.width*0.05,),
                BlockPicker(
                  availableColors: [
                    Colors.red,
                    Colors.blue,
                    Colors.yellow,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple,
                    Colors.teal,
                    Colors.lightGreenAccent
                  ],
                  pickerColor: Colors.blue,
                  onColorChanged: (changeColor) {
                    classColor = changeColor;
                  },
                ),
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Uri Url = Uri.parse(
              "https://attendgo-7611e-default-rtdb.firebaseio.com/classes.json");

          if (className.text.isNotEmpty) {
            print(classColor.toString());
            http
                .post(Url,
                    body: json.encode({
                      'title': className.text,
                      'color': classColor.toString(),
                      'privacy': privacy
                    }))
                .then((value) {
              newClass = Classes(
                  canShare: privacy,
                  color: classColor,
                  id: json.decode(value.body)['name'],
                  name: className.text);
              addClass(newClass);
            });
            Navigator.of(context).pop();
          } else {
            setState(() {
              fColor = Colors.red;
            });
          }
        },
        child: Icon(Icons.add,
            color: Colors.white,
            size: 30 * MediaQuery.of(context).textScaleFactor),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
