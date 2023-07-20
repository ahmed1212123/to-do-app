import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/states.dart';

import '../Moduls/archive_tasks_screen.dart';
import '../Moduls/done_tasks_screen.dart';
import '../Moduls/new_tasks_screen.dart';

class TodoCubit extends Cubit<TodoStates>
{
  TodoCubit() : super(TodoInitialState());

  static TodoCubit get(context) => BlocProvider.of(context);


  int currentIndex = 0;


  List<Map> newTasks =[];
  List<Map> doneTasks =[];
  List<Map> archiveTasks =[];

  List screen = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchiveTasksScreen(),
  ];
  List titles = ["Tasks", 'Done', 'Archive'];

  void ChangeIndex(int index)
  {
    currentIndex = index;
    emit(TodoChangeNavBarState());
  }
  late Database database;

  void createDatabase() async {
    database =
    await openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print('database created');
      database
          .execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print('table created');

        emit(TodoCreateDatabaseState());
      }).catchError((error) {
        print('error ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print('database opened');
    });
  }

  void insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) {
    database.transaction((txn) async {
      await txn
          .rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(TodoInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('error ${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
     value.forEach((e){
       if(e['status'] == 'new')
         newTasks.add(e);
       else if (e['status'] == 'done')
         doneTasks.add(e);
       else
         archiveTasks.add(e);
     });

      emit(TodoGetDatabaseState());
    }).catchError((error) {
      print('error ${error.toString()}');
    });
  }
  
  void updateData({
    required String status,
    required int id,
}){
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',[status,id]).then((value)
    {
      getDataFromDatabase(database);
      emit(TodoUpdateDatabaseState());
    });
  }
  void deleteData({
    required int id,
}){
    database.rawDelete('DELETE FROM tasks WHERE id = ? ',[id]).then((value){

      getDataFromDatabase(database);
      emit(TodoDeleteDatabaseState());
    });
  }

  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  AlertDialog buildAlertDialog(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.tealAccent,
        title: Text('Add New Task'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter your title";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Task title',
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: timeController,
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Time must not be empty ";
                  }
                  return null;
                },
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    timeController.text = value!.format(context).toString();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Task time',
                  prefixIcon: Icon(Icons.watch_later_outlined),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: dateController,
                keyboardType: TextInputType.datetime,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.parse('2030-01-01'),
                  ).then((value) {
                    dateController.text = DateFormat.yMMMd().format(value!);
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Date must not be empty ";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 5,
                      )),
                  labelText: 'Task Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                      color: Colors.red,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'close',
                      )),
                  MaterialButton(
                      color: Colors.green,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          insertToDatabase(
                            title: titleController.text,
                            time: timeController.text,
                            date: dateController.text,
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Save',
                      )),
                ],
              )
            ],
          ),
        ));
  }
}