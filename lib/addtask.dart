
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newtodo/taskprovider.dart';
class addtask extends StatefulWidget {
  @override
  State<addtask> createState() => _addtaskState();
}

class _addtaskState extends State<addtask> {
TextEditingController _titlecontroller = TextEditingController();
TextEditingController _descriptioncontroller = TextEditingController();
GlobalKey<FormState> _form = GlobalKey(); 
var taskclass = TaskProvider();
void additem ()
{
  if(_form.currentState!.validate())
  {
      var temp =  Task(task: _titlecontroller.text,description: _descriptioncontroller.text,isFav: false);
      context.read<TaskProvider>().addTask(temp);
      Navigator.pushReplacementNamed(context,"start");
  }
}
String? _validatetitle(String? value){
  return ((value == null || value.isEmpty))? "Title can't be empty" : null;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(3.0,18,0,10),
            child: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.black,size: 30,),
            onPressed: () {Navigator.pop(context);},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Container(
              height: 300,
              width: 800,
              child: Text("Add\nNew\nTask",style: TextStyle(fontSize: 70,fontWeight: FontWeight.bold),),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titlecontroller,
                      maxLines: 1,
                      maxLength: 30,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lightbulb),
                        prefixIconColor: Colors.black,
                        label: Text("Title",style: TextStyle(fontSize: 20,color: Colors.black),),
                        hintText: "Enter new title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)
                        )
                      ),
                      validator: (value) => _validatetitle(value),
                ),
                SizedBox(height: 20,),
                TextFormField(
                maxLength: 100,
                maxLines: 2,
                autocorrect: false,
                controller: _descriptioncontroller,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.arrow_forward_rounded),
                  prefixIconColor: Colors.black,
                  label: Text("Description",style: TextStyle(fontSize: 18,color: Colors.black),),
                  hintStyle: TextStyle(fontSize: 50),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                  )
                ),
                
              ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: additem,
        child: Icon(Icons.add),
      ),
    );
  }
}