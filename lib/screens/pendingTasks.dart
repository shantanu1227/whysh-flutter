import 'package:community/config/constants.dart';
import 'package:community/network/api/api.dart';
import 'package:community/network/models/tasks.dart';
import 'package:community/widgets/drawer.dart';
import 'package:community/widgets/tasks.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingTasksScreen extends StatefulWidget {

  PendingTasksScreen({Key key}) : super(key: key);

  @override
  _PendingTasksScreen createState() {
    return new _PendingTasksScreen();
  }
}

class _PendingTasksScreen extends State<PendingTasksScreen> {
  Future<Tasks> futureTasks;
  int zip;

  _PendingTasksScreen();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        zip = prefs.getInt(Constants.SF_KEY_ZIP);
        futureTasks = Api.getPendingTasks(zip);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Help Someone In $zip'),
        ),
        drawer: NavigationDrawer(),
        body: TasksList(futureTasks, false, false)
    );
  }
}
