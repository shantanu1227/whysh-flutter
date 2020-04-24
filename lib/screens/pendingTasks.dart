import 'package:community/config/constants.dart';
import 'package:community/enums/TaskType.dart';
import 'package:community/widgets/appBar.dart';
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
  int zip;

  _PendingTasksScreen();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        zip = prefs.getInt(Constants.SF_KEY_ZIP);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (zip == null) {
      body = CircularProgressIndicator();
    } else {
      body = TasksList(TaskType.PENDING, false, false, zip: zip);
    }
    String message = 'Help Someoone in $zip';
    return Scaffold(
        appBar: CustomAppBar(
            titleContent: Tooltip(message: message, child: Text(message),),
            automaticallyImplyLeading: true),
        drawer: NavigationDrawer(),
        body: body
    );
  }
}
