import 'package:community/widgets/createTaskForm.dart';
import 'package:community/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:community/widgets/appBar.dart';

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
        appBar: CustomAppBar(title: Text('Create a Task'), appBar: AppBar(), automaticallyImplyLeading: true),
        drawer: NavigationDrawer(),
        body: Container(
          child: CreateTaskForm(),
        )
    );
  }

}