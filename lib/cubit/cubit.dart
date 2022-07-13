import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import 'package:todo/cubit/states.dart';

import '../modules/archived_notes.dart';
import '../modules/donetasks.dart';
import '../modules/tasks.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(TodoInitialState());

  List<Widget> screens = [Tasks(), DoneTasks(), ArchivedTasks()];

  List<String> appBars = ['Tasks', 'Done Tasks', 'Archived Tasks'];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  late Database database;

  static TodoCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  void changeIndex(index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  void createDatabase() {
    openDatabase('todo1.db', version: 2, onCreate: (database, version) {
      print("Database created");

      database
          .execute(
              'CREATE TABLE task (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        // print(value);  //excute has no return type
      }).catchError((error) {
        print('error when creating table ${error.toString()}');
      });
    }, onOpen: (database) {
      debugPrint('Database opened');
      getDataFromDatabase(database);
    }).then((value) {
      database = value;
      emit(CreateDbState()); //
    });
  }

 



  Future insertDatabase(
      {required String title,
      required String time,
      required String date}) async {

    return await database.transaction((txn) async {
      txn.rawInsert(
              'INSERT INTO task(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('inserted: ${value}');

        emit(InsertDbState()); //

        getDataFromDatabase(database);
      }).catchError((error) {
        print('error when inserting ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase( Database database)async {
    emit(GetDbLoadingState());
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    
   await  database.rawQuery('SELECT * FROM task').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') newTasks.add(element);
        if (element['status'] == 'done') doneTasks.add(element);
        if (element['status'] == 'archived') archivedTasks.add(element);
      });
      emit(GetDbState());
    }).catchError((onError) => print('GetDataError $onError'));
  }

  void updateDatabase({required String status, required int id}) async {
   await  database.rawUpdate('UPDATE task SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
     // getDataFromDatabase(database);
      emit(UpdateDbState());
       getDataFromDatabase(database);
    });
  }

  void deleteDatabase({required int id}) async {
  await database.rawDelete('DELETE FROM task WHERE id = ?', [id]).then((value) {
     // getDataFromDatabase(database);
      emit(DeleteDbState());
    getDataFromDatabase(database);
    });
  }

  bool buttonSheetShown = false;

  IconData floatingButtonIcon = Icons.add;

  void changeBottomSheetState(
      {required bool isShown, required IconData fabIcon}) {
    buttonSheetShown = isShown;
    floatingButtonIcon = fabIcon;
    emit(AppChangeBottomSheetState());
  }
}
