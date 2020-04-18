import 'package:community/network/api/api.dart';
import 'package:community/network/models/tasks.dart';
import 'package:community/widgets/drawer.dart';
import 'package:community/widgets/tasks.dart';
import 'package:flutter/material.dart';
import 'package:community/widgets/appBar.dart';

class AssignedTasksScreen extends StatefulWidget {
  AssignedTasksScreen({Key key}) : super(key: key);

  @override
  _AssignedTasksScreen createState() {
    return new _AssignedTasksScreen();
  }
}

class _AssignedTasksScreen extends State<AssignedTasksScreen> {
  Future<Tasks> futureTasks;

  _AssignedTasksScreen();

  @override
  void initState() {
    super.initState();
    futureTasks = Api.getAssignedTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: Text('Assigned Tasks'), appBar: AppBar(), automaticallyImplyLeading: true),
        drawer: NavigationDrawer(),
        body: TasksList(futureTasks, true, false));
  }
}
