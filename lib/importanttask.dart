import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newtodo/taskprovider.dart';
class favtasks extends StatelessWidget {
  const favtasks({super.key});

  @override
  Widget build(BuildContext context) {
    
    var fav = context.watch<TaskProvider>().fav;
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
             padding: const EdgeInsets.fromLTRB(5.0,40,20,30),
             child: Container(
                height: 300,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0,60,20,30),
                  child: Container(child: Text("Favorites",style: TextStyle(fontSize: 80,fontWeight: FontWeight.bold),)),
                ),
              ),
           ),
           (fav.isEmpty)? const  Center(child: Text("No Favorites",style: TextStyle(fontSize: 30),),): Expanded(
                child: Container(
                  child: ListView.builder(
                    itemCount: fav.length,
                    itemBuilder: (context, index) {
                      var ins = fav[index];
                      return Dismissible(
                      key: ValueKey(ins.task),
                      onDismissed: (direction) => {
                        context.read<TaskProvider>().removeFav(ins),
                      },
                      child:Card(
                        child:ListTile(
                          onTap: () {
                            print(index);
                            Navigator.pushNamed(context, "/display",arguments: {'index':index,'task': fav});
                          },
                              title: Text(ins.task,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              subtitle: Text(ins.description,style: TextStyle(fontSize: 15,)),
                              trailing: IconButton(
                                onPressed: () {
                                  if(fav.contains(ins) && ins.isFav == true)
                                  {
                                    context.read<TaskProvider>().removeFav(ins);
                                  }
                                  else{
                                    context.read<TaskProvider>().addFavTask(ins);
                                  }

                                },
                                icon: Icon(Icons.star,size: 30,),
                                color: (fav.contains(ins)  && ins.isFav == true)? Colors.red: Colors.grey,
                            ),
                          ),
                      ),
                      );
                    },
                ),
              ),
              ),
        ],
      ),
    );
  }
}
