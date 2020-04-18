import 'package:community/network/models/tasks.dart';
import 'package:flutter/material.dart';

import 'TaskItem.dart';

class TasksList extends StatelessWidget {
  final Future<Tasks> futureTasks;
  final bool showContact;
  final bool isCreator;

  TasksList(this.futureTasks, this.showContact, this.isCreator);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: FutureBuilder<Tasks>(
      future: futureTasks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.tasks.length == 0) {
            return Card(margin: EdgeInsets.all(8), child: Text('No Tasks.'));
          }
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: snapshot.data.tasks.length,
            itemBuilder: (context, index) {
              final item = snapshot.data.tasks.elementAt(index);
              return new TaskItem(item, showContact: showContact,
                  isCreator: isCreator);
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    ))
    );
    }
}
