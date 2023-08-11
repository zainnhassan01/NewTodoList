import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:newtodo/addtask.dart';
import 'package:newtodo/importanttask.dart';
import 'package:newtodo/taskprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int selectedindex = 0;

  List<Widget> screens = [
    home(),
    addtask(),
    favtasks(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: screens,
        index: selectedindex,
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home,),
              label: "Home",
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add,),
              label: "New Task"
              ),
              BottomNavigationBarItem(
              icon: Icon(Icons.star,),
              label: "Favorites"
              ),
          ],
          currentIndex: selectedindex,
          selectedItemColor: Colors.black,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          onTap:(index) {
            setState((){
              selectedindex = index;
            });
          },
        ),
    );
  }
}


class home extends StatelessWidget {
  home({super.key});
  

  @override
  Widget build(BuildContext context) {
    var sharedpref = TaskProvider();
    var task = context.watch<TaskProvider>().task;
    var fav = context.watch<TaskProvider>().fav;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 300,
            width: 700,
            decoration:  const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(50, 30),bottomRight: Radius.elliptical(50, 30)),
              color: Colors.black
            ),
            child:   Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0 ,0,0,0),
                child: Consumer<TaskProvider>(builder: (context, value, child){
                  var time = DateFormat("h:mm a").format(value.time);
                  return Text(time,
                  style: TextStyle(fontSize: 25,color: Colors.white),
                  );    
                 },),
              ),
               const SizedBox(height: 20,),
              const Padding(
                padding:  EdgeInsets.fromLTRB(10.0,0,0,0),
                child:  Text("MY\nTASKS",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.white),),
              ),
            ]
            ),
          ),
         const  SizedBox(height: 10,),
          (task.isEmpty)? const  Center(child: Text("No Tasks",style: TextStyle(fontSize: 26),),): Expanded(
             child: FutureBuilder<SharedPreferences>(
              future: sharedpref.prefs,
              builder: (context, snapshot)  {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return CircularProgressIndicator();
                }
                if(snapshot.hasError){
                  return Text("Error Found: ${snapshot.error}");
                }
                else
              {
                return Container(
                  child: ListView.builder(
                    itemCount: task.length,
                    itemBuilder: (context, index){
                      var i = task[index];
                      return Dismissible(
                        key: ValueKey(i.id),
                        onDismissed: (direction) => {
                          if(fav.contains(i)){
                          context.read<TaskProvider>().removeFav(i),
                          context.read<TaskProvider>().removeMainTask(i),
                          }else context.read<TaskProvider>().removeMainTask(i),
                        },
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, "/display",arguments: {'index':index,'task':task});
                            },
                            title: Text(i.task,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                            subtitle: Text(i.description,style: TextStyle(fontSize: 15,color: Colors.black)),
                            trailing: IconButton(
                              onPressed: () {
                                if(fav.contains(i) && i.isFav == true)
                                {
                                  context.read<TaskProvider>().removeFav(i);
                                }
                                else{
                                  context.read<TaskProvider>().addFavTask(i);
                                }
                              },
                              icon: Icon(Icons.star,size: 30,),
                              color: (fav.contains(i) && i.isFav == true )? Colors.red: Colors.grey,
                          ),
                        ),
                      ),
                      );
                    } ,
                    ),
               );
              }
             }
             ),  
             
              
           ),
        ],
      ),
    );
  }
}