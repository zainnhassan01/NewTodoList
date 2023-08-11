import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
class Task{

  String task;
  String description;
  bool isFav;
  String id;
  Task({required this.task,required this.description,required this.isFav}): id = Uuid().v4();
  
  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'description': description,
      'isFav' : isFav
    };
  }

  @override
  String toString() {
    return 'Task{task: $task,description: $description,isFav: $isFav}';
  }
}

class TaskProvider extends ChangeNotifier{
  var prefs;
  var _time = DateTime.now();
  DateTime get time => _time; 
  Timer? _timer;
  TaskProvider() {
    loaddatacalling();
    _timer = Timer.periodic(Duration(minutes: 1),(timer)  {
    _time = DateTime.now();
    });
    notifyListeners();
  }

  //Editing the task
  bool _isEdit = false;
  bool get isEditing => _isEdit;
  void isEdit(bool val){
  _isEdit = false;
  _isDescriptionEditing = false;
  }
  void isEditingEnable(){
    _isEdit = !_isEdit;
    notifyListeners();
  }
  bool _isDescriptionEditing = false;
  bool get descriptionEditing => _isDescriptionEditing;
  void isDesEditingEnable(){
    _isDescriptionEditing = !_isDescriptionEditing;
    notifyListeners();
  }

  

  // loading the stored tasks
  void loaddatacalling() async {
  try{
  prefs = await SharedPreferences.getInstance();
  await loadData();
  // await loadFavData();
    }catch(e) {
      print(e);
    }
  }

  List<Task> _task = [];
  List<Task> get task => _task;

  List<Task> _favtask = [];
  List<Task> get fav => _favtask;

  Future<void> loadData() async {
  try {
    final jsonString = await prefs.getString("data") ?? "[]";
    final jsonList = json.decode(jsonString) as List<dynamic>;
    List<Task> loadedtask = jsonList.map((jsonTask) {
      return Task(
        task: jsonTask['task'] as String,
        description: jsonTask['description'] as String,
        isFav: jsonTask['isFav'] as bool,
      );
    }).toList();
    _task = loadedtask;
    _favtask = loadedtask.where((task) => task.isFav).toList();
    print("Showing the list of data named _task only");
    print(_task.toString());
    notifyListeners();
  } catch (e) {
    print(e);
  }
}


  Future<void> saveData (List<Task> instance) async {
   try{
    final List<Map<String, dynamic>> jsonList = instance.map((task) => task.toJson()).toList();
    print(jsonList);
    final savedjson = json.encode(instance);
    await prefs.setString("data",savedjson);
   }catch(e){print("error" + e.toString());}
  }

  void addTask(Task newtask){
    task.add(newtask);
    saveData(task);
    notifyListeners();
  }
  void removeMainTask(Task newtask){
    newtask.isFav = false;
    task.remove(newtask);
    saveData(task);
    notifyListeners();
  }
  void addFavTask(Task newtask){
    newtask.isFav = true;
    fav.add(newtask);
    saveData(task);
    notifyListeners();
  }
  void removeFav(Task newtask){
    newtask.isFav = false;
    fav.remove(newtask);
    saveData(task);
    notifyListeners();
  }
   @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  
}

