import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newtodo/home.dart';
import 'package:newtodo/addtask.dart';
import 'package:newtodo/importanttask.dart';
import 'package:newtodo/taskdisplay.dart';
import 'package:newtodo/taskprovider.dart';
void main() { 
  runApp(
  ChangeNotifierProvider(
    create:  (context) =>  TaskProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "start":(context) => MyBottomNavigationBar(),
        "/home":(context) => home(),
        "/addtask" :(context) => addtask(),
        "/fav" :(context) => favtasks(),
        "/display" :(context) => taskdisplay(),
      },
      theme: ThemeData(
        focusColor: Colors.black
      ),
      color: Colors.black,
      initialRoute: "start",
    ),
  )
);
}
