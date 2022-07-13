import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/cubit/cubit.dart';

Widget taskRowItem(Map model, context) {
  return Dismissible(
    key: UniqueKey(),
    onDismissed: (direction) {
      TodoCubit.get(context).deleteDatabase(id: model['id']);
    },
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: CircleAvatar(
            child: Text(
              '${model['time']}',
              style: TextStyle(
                fontSize: 15,
              ),
              maxLines: 1,
            ),
            radius: 40,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${model['title']}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(
                height: 5,
              ),
              Text(
                '${model['date']}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
              )
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        IconButton(
            onPressed: () {
              TodoCubit.get(context)
                  .updateDatabase(status: 'done', id: model['id']);
            },
            icon: Icon(
              Icons.check_box,
              color: Colors.green,
            )),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
              onPressed: () {
                TodoCubit.get(context)
                    .updateDatabase(status: 'archived', id: model['id']);
              },
              icon: Icon(
                Icons.archive,
                color: Colors.redAccent,
              )),
        )
      ],
    ),
  );
}
