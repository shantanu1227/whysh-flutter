import 'package:community/widgets/createTaskForm.dart';
import 'package:community/widgets/drawer.dart';
import 'package:flutter/material.dart';

class CreateTaskScreen extends StatefulWidget {

  @override
  _CreateTaskScreen createState() {
    return new _CreateTaskScreen();
  }

}

class _CreateTaskScreen extends State<CreateTaskScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Task'),
        ),
        drawer: NavigationDrawer(),
        body: Container(
          child: CreateTaskForm(),
        )
    );
  }

}