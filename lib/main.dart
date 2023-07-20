import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc_observer.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/layout/home_layout.dart';

void main() {

  Bloc.observer = MyBlocObserver();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..createDatabase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(

          textTheme: TextTheme(
              bodyMedium: TextStyle(color: Colors.red)
          ),
          primarySwatch: Colors.teal,
        ),
        home: HomeLayout(),
      ),
    );
  }
}
