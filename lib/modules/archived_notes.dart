import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/states.dart';
import 'package:todo/shared/reusableComponents.dart';
import '../cubit/cubit.dart';
import '../shared/constants.dart';

class ArchivedTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   

    return BlocConsumer<TodoCubit, TodoStates>(
        builder: (context, state) {
           final tasks = TodoCubit.get(context).archivedTasks;
          return tasks.length<0 ? Center(child: CircularProgressIndicator(),) : ListView.separated(
              itemBuilder: (context, index) {
                return taskRowItem(tasks[index], context);
              },
              separatorBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Container(
                      height: 2, width: double.infinity, color: Colors.grey),
                );
              },
              itemCount: tasks.length);
        },
        listener: (context, state) {});
  }
}
