import 'package:community/widgets/appBar.dart';
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
        appBar: CustomAppBar(titleContent: Text('Create a Task'),
            automaticallyImplyLeading: true),
        drawer: NavigationDrawer(),
        body: Container(
          color: Colors.grey[200],
          padding: EdgeInsets.all(8),
          child: Card(
              child: new CreateTaskForm()
          ),
        )
    );
  }

}