import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubit.dart';
import '../cubit/states.dart';


class HomeLayout extends StatelessWidget {


  var scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {

    var cubit = TodoCubit.get(context);

    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
          ),
          body: ConditionalBuilder(
            condition: true,
            builder: (context) => cubit.screen[cubit.currentIndex],
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return cubit.buildAlertDialog(context);
                },
                barrierDismissible: false,
              );
            },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.ChangeIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: "Tasks",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                label: "Done",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.archive_outlined),
                label: "Archive",
              ),
            ],
          ),
        );
      },
    );
  }
}

