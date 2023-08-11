import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newtodo/taskprovider.dart';

class taskdisplay extends StatefulWidget {
  @override
  State<taskdisplay> createState() => _taskdisplayState();
}

class _taskdisplayState extends State<taskdisplay> {
  TextEditingController _controllertitle = TextEditingController();
   TextEditingController _controllerdescription = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
 
 bool _validatetitle(){
  if(_key.currentState!.validate()){
     return true;
  }
  return false;
 }

 String? _validate(String? value){
 return value!.isEmpty ? "Title can't be empty" : null;
 }
 @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context,listen: false).isEdit(false);
  }
  @override
  Widget build(BuildContext context) {
    var instance = TaskProvider();
  Map mapTask = ModalRoute.of(context)!.settings.arguments as Map;
  int index = mapTask['index'];
  List<Task> tasks = mapTask['task'];
    return Scaffold(
      body:  SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(15.0,100,10,10),
                  child: Consumer<TaskProvider>(builder: ((context, value, child)  {
                    return GestureDetector(
                      child: (value.isEditing == false)? 
                      (Container(
                          height: 100,
                          width: 700,
                          child: (tasks[index].task.length <= 10 )?  
                           (Text(tasks[index].task,style: TextStyle(fontSize: 60),)) : (Text(tasks[index].task,style: TextStyle(fontSize: 40),))
                          )): Center(
                            child: Column(
                              children: [
                                Form(
                                  key: _key,
                                  child: TextFormField(
                                    validator: (value) => _validate(value),
                                      controller: _controllertitle,
                                      decoration: InputDecoration(
                                        label: Text("Title"),
                                        hintText: "Enter new title",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        )
                                      ),
                                    ),
                                ),
                                  SizedBox(height: 20,),
                                      ElevatedButton(onPressed: () {
                                       bool savetitle = _validatetitle();
                                      (savetitle == true)? tasks[index].task = _controllertitle.text : tasks[index].task;
                                      instance.saveData(tasks);
                                       Provider.of<TaskProvider>(context,listen: false).isEditingEnable();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.black)
                                      ),
                                      child: Text("Save")),
                                  //   ],
                                  // )
                              ],
                            ),
                          ),
                      onTap: () {
                       Provider.of<TaskProvider>(context,listen: false).isEditingEnable();
                      },
                    );
                  }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0,100,10,10),
                  child: Consumer<TaskProvider>(builder: ((context, values, child)  {
                    return GestureDetector(
                      child: (values.descriptionEditing == false)? 
                      (Container(
                          height: 500,
                          width: 700,
                          child: SingleChildScrollView(child: Text(tasks[index].description,style: TextStyle(fontSize: 25),)),
                          )): Center(
                            child: Column(
                              children: [
                                TextFormField(
                                    controller: _controllerdescription,
                                    decoration: InputDecoration(
                                      label: Text("Description"),
                                      hintText: "Enter new description",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  ElevatedButton(onPressed: () {
                                    _controllerdescription.text.isEmpty? tasks[index].description == "No Description": tasks[index].description = _controllerdescription.text;
                                   instance.saveData(tasks);
                                   Provider.of<TaskProvider>(context,listen: false).isDesEditingEnable();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.black)
                                  ),
                                   child: Text("Save"),),
                              ],
                            ),
                          ),
                      onTap: () {
                       Provider.of<TaskProvider>(context,listen: false).isDesEditingEnable();
                      },
                    );
                  }),
                  ),
                ),
            ],
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 0.0,
        onPressed: () {
          Provider.of<TaskProvider>(context,listen: false).removeMainTask(tasks[index]);
          Provider.of<TaskProvider>(context,listen: false).removeFav(tasks[index]);
          Navigator.pop(context);
        } ,
        child: Icon(Icons.delete,color: Colors.black,size: 35,),
      ),
    );
  }
}