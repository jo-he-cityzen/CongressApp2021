import 'dart:ffi';

List<double> convertStringtoList(String stringList){
  List<double> embedding = [];
  int i = 0;
  bool j = true;
  int num;
  for(;i< stringList.length;){
    j = true;
    num = i;
    String tempNum = "";
    for(;j;){
      if(stringList[num] != " "){
        tempNum = tempNum + stringList[num];
        num = num + 1;
      }
      else{
        i = num;
        embedding.add(double.parse(tempNum));
        j = false;
      }
    }
  }
  return embedding;
}
String convertListtoString(List list){
  String listString = "";
  int i = 0;
  for(;i < list.length; i++){
    listString = listString + list[i].toString() + " ";
  }
  return listString;
}