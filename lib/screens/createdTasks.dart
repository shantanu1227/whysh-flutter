import 'package:community/enums/TaskType.dart';
import 'package:community/widgets/appBar.dart';
import 'package:community/widgets/drawer.dart';
import 'package:community/widgets/tasks.dart';
import 'package:flutter/material.dart';

class CreatedTasksScreen extends StatefulWidget {
  CreatedTasksScreen({Key key}) : super(key: key);

  @override
  _CreatedTasksScreen createState() {
    return new _CreatedTasksScreen();
  }
}

class _CreatedTasksScreen extends State<CreatedTasksScreen> {

  _CreatedTasksScreen();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(titleContent: Text('Created Tasks'),
            automaticallyImplyLeading: true),
      drawer: NavigationDrawer(),
        body: TasksList(TaskType.CREATED, true, true));
  }
}
