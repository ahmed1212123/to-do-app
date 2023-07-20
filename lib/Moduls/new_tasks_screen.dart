import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit,TodoStates>(
      listener: (context,state){},
      builder: (context,state){
        var tasks = TodoCubit.get(context).newTasks;
        return ListView.separated(
          itemBuilder: (context, index) => buildTasksItem(tasks[index],context),
          separatorBuilder: (context, index) => Container(
            width: double.infinity,
            height: 5,
            color: Colors.blueGrey[400],
          ),
          itemCount: tasks.length,
        );
      },
    );
  }

}
Widget buildTasksItem(Map model,context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
    padding: EdgeInsets.all(15),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40,
          child: Text(
            model['time'],
          ),
        ),
        Expanded(child: Padding(
          padding: EdgeInsets.only(
            left: 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model['title'],style: TextStyle(fontSize: 25),),
              Text(model['date'],style: TextStyle(color: Colors.blueGrey),),
            ],
          ),
        )),
        IconButton(onPressed: (){
          TodoCubit.get(context).updateData(status: 'done', id: model['id']);
        }, icon: Icon(Icons.check_circle ,color: Colors.green,)),
        SizedBox(width: 5,),
        IconButton(onPressed: (){
          TodoCubit.get(context).updateData(status: 'archive', id: model['id']);
        }, icon: Icon(Icons.archive_outlined ,color: Colors.black54,)),
        // SizedBox(width: 5,),
        // IconButton(onPressed: (){
        //   TodoCubit.get(context).deleteData(id: model['id']);
        // }, icon: Icon(Icons.delete ,color: Colors.red,)),
      ],
    ),
  ),
    onDismissed: (direction){
      TodoCubit.get(context).deleteData(id: model['id']);
    },
    background: Container(
      //color: Colors.red,
      child: Center(child: Icon(Icons.delete,color: Colors.red,),),
    ),
  );
}
