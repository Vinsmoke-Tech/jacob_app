import 'package:flutter/material.dart';

const Color yellow = Color(0xffFDC054);
const Color mediumYellow = Color(0xffFDB846);
const Color darkYellow = Color(0xffE99E22);
const Color transparentBrown =  Color(0xffa5683a);
const Color darkGrey = Color.fromARGB(255, 226, 226, 226);
const Color white = Colors.white;
const Color bgGrey = Color.fromARGB(255, 0, 0, 0);
const Color black = Colors.black;
const Color blue = Colors.lightBlueAccent;



const LinearGradient mainButton = LinearGradient(colors: [
  Color.fromRGBO(176, 128, 112, 1),
  Color.fromRGBO(188, 152, 140, 1),
  Color.fromRGBO(255, 198, 171, 1),
], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter);

const List<BoxShadow> shadow = [
  BoxShadow(color: Colors.black12, offset: Offset(5, 5), blurRadius: 6)
];

screenAwareSize(int size, BuildContext context) {
  double baseHeight = 640.0;
  return size * MediaQuery.of(context).size.height / baseHeight;
}