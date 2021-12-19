import 'package:flutter/material.dart';

class drawerScreen extends StatefulWidget {
  bool showColor;
  Color mainColor;
  Function changeState;
  Function changeColor;
  List availColors;
  drawerScreen(this.showColor, this.mainColor, this.changeState,
      this.changeColor, this.availColors);
  @override
  _drawerScreenState createState() => _drawerScreenState();
}

class _drawerScreenState extends State<drawerScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.showColor == false
        ? Drawer(
            child: Column(
            children: [
              Container(
                  height: 120,
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  color: widget.mainColor,
                  child: Text("Settings",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ))),
              SizedBox(
                height: 30,
              ),
              ListTile(
                  leading: Icon(
                    Icons.color_lens,
                    size: 26,
                    color: Colors.black,
                  ),
                  title: Text("Colors",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                  onTap: () {
                    setState(() => widget.changeState(widget.showColor));
                  }),
            ],
          ))
        : Drawer(
            child: Column(
            children: [
              Container(
                  height: 120,
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  color: widget.mainColor,
                  child: Text("Settings",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ))),
              SizedBox(
                height: 30,
              ),
              ListTile(
                  leading: Icon(
                    Icons.color_lens,
                    size: 26,
                    color: Colors.black,
                  ),
                  title: Text("Colors",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                  onTap: () {
                    setState(() => widget.changeState(widget.showColor));
                  }),
              ...widget.availColors.map((data) {
                return ListTile(
                    leading: Icon(
                      Icons.circle,
                      size: 26,
                      color: data[0],
                    ),
                    onTap: () {
                      widget.changeColor(data[0]);
                    },
                    title: Text(data[1],
                        style: TextStyle(
                          fontSize: 19,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )));
              }).toList()
            ],
          ));
  }
}
