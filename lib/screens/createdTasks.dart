import 'package:community/network/api/api.dart';
import 'package:community/network/models/tasks.dart';
import 'package:community/widgets/drawer.dart';
import 'package:community/widgets/tasks.dart';
import 'package:flutter/material.dart';
import 'package:community/widgets/appBar.dart';

class CreatedTasksScreen extends StatefulWidget {
  CreatedTasksScreen({Key key}) : super(key: key);

  @override
  _CreatedTasksScreen createState() {
    return new _CreatedTasksScreen();
  }
}

class _CreatedTasksScreen extends State<CreatedTasksScreen> {
  Future<Tasks> futureTasks;

  _CreatedTasksScreen();

  @override
  void initState() {
    super.initState();
    futureTasks = Api.getCreatedTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text('Created Tasks'), appBar: AppBar(), automaticallyImplyLeading: true),
      drawer: NavigationDrawer(),
      body: TasksList(futureTasks, true, true));
  }
}
