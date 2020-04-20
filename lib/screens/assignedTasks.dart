import 'package:community/enums/TaskType.dart';
import 'package:community/widgets/appBar.dart';
import 'package:community/widgets/drawer.dart';
import 'package:community/widgets/tasks.dart';
import 'package:flutter/material.dart';

class AssignedTasksScreen extends StatefulWidget {
  AssignedTasksScreen({Key key}) : super(key: key);

  @override
  _AssignedTasksScreen createState() {
    return new _AssignedTasksScreen();
  }
}

class _AssignedTasksScreen extends State<AssignedTasksScreen> {

  _AssignedTasksScreen();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: Text('Assigned Tasks'), appBar: AppBar(), automaticallyImplyLeading: true),
        drawer: NavigationDrawer(),
        body: TasksList(TaskType.ASSIGNED, true, false));
  }
}
