import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'new_tasks_screen.dart';

class ArchiveTasksScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit,TodoStates>(
      listener: (context,state){},
      builder: (context,state){
        var tasks = TodoCubit.get(context).archiveTasks;
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
