import 'package:flutter/material.dart';
class ClassesWidget extends StatelessWidget{
  @override
  Color color;
  String title;
  String id;
  ClassesWidget(this.color, this.title, this.id);
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed("ClassMainScreen", arguments: {"color" : color, "title" : title, "id" : id});
      },
      splashColor : color, 
      borderRadius : BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Center( child :Text(title, style: TextStyle(fontSize: 25 * MediaQuery.of(context).textScaleFactor, fontFamily: 'Quicksand', fontWeight: FontWeight.bold, color: Colors.white,))),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withOpacity(0.7), color], begin: Alignment.bottomLeft, end : Alignment.topRight), borderRadius: BorderRadius.circular(20)),     
      )
      );
}
}