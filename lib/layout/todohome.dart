import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';
import 'package:todo/modules/donetasks.dart';
import 'package:todo/modules/tasks.dart';
import '../modules/archived_notes.dart';
import 'package:intl/intl.dart';
import '../shared/constants.dart';

class MyHomePage extends StatelessWidget {
  late var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return TodoCubit()..createDatabase();
      },
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (context, state) {
          if (state is InsertDbState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final cubit = TodoCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.appBars[cubit.currentIndex]),
            ),
            body: /*cubit.newtasks.length == 0
               
                ? Center(
                    child: (state is! GetDbLoadingState)
                        ? CircularProgressIndicator()
                        : null)
                : */
                cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  label: 'Tasks',
                  icon: Icon(Icons.menu),
                ),
                BottomNavigationBarItem(
                  label: 'Done',
                  // backgroundColor: Colors.green,
                  icon: Icon(Icons.done),
                ),
                BottomNavigationBarItem(
                  label: 'Archived',
                  // backgroundColor: Colors.redAccent,
                  icon: Icon(Icons.archive_rounded),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.floatingButtonIcon),
              onPressed: () {
                if (cubit.buttonSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertDatabase(
                        date: '${dateController.text}',
                        time: '${timeController.text}',
                        title: '${titleController.text}');
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) {
                          elevation:
                          20.0;
                          return Container(
                            height: 280,
                            width: double.infinity,
                            color: Colors.white,
                            padding: EdgeInsets.all(10),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "This field can't be empty";
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                    decoration: InputDecoration(
                                      label: Text(
                                        'Task Title',
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                      ),
                                      prefix: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Icon(Icons.title,
                                            color: Colors.green),
                                      ),
                                      contentPadding: const EdgeInsets.all(8.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    controller: titleController,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "This field can't be empty";
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                        //print(value?.format(context));
                                      });
                                    },
                                    keyboardType: TextInputType.datetime,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                    decoration: InputDecoration(
                                      label: Text(
                                        'Task Time',
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                      ),
                                      prefix: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Icon(
                                          Icons.watch_later_outlined,
                                          color: Colors.green,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.all(8.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    controller: timeController,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "This field can't be empty";
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2023-06-06'))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    keyboardType: TextInputType.datetime,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                    decoration: InputDecoration(
                                      label: Text(
                                        'Task Date',
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                      ),
                                      prefix: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Icon(
                                          Icons.calendar_month,
                                          color: Colors.green,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.all(8.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    controller: dateController,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                      .closed
                      .then((value) {
                        ///cubit.buttonSheetShown = false;
                        //cubit.getDataFromDatabase(cubit.database);
                        cubit.changeBottomSheetState(
                            isShown: false, fabIcon: Icons.edit);

                       // cubit.floatingButtonIcon = Icons.add;
                      });
                  cubit.changeBottomSheetState(
                      isShown: true, fabIcon: Icons.add);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
