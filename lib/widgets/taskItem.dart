import 'package:community/config/routes.dart';
import 'package:community/network/api/api.dart';
import 'package:community/network/models/task.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  final bool showContact;
  final bool isCreator;

  TaskItem(this.task, {this.showContact: false, this.isCreator: true});

  @override
  _TaskItem createState() {
    return new _TaskItem(this.task, this.showContact, this.isCreator);
  }
}

class _TaskItem extends State<TaskItem> {
  Task task;
  bool showContact;
  bool isCreator;
  bool isLoading = false;

  _TaskItem(this.task, this.showContact, this.isCreator);

  Future<void> _launchNavigationURL() async {
    String url =
        "https://www.google.com/maps/search/?api=1&query=${this.task.address.location.latitude},${this.task.address.location.longitude}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchCallUrl(String phone) async {
    String url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _assignTask(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Api.assignTask(task.id);
      setState(() {
        isLoading = false;
      });
      await Navigator.of(context).popAndPushNamed(RouteNames.assignedTasks);
      return;
    } on Exception catch (e) {
      setState(() {
        isLoading = false;
      });
      Scaffold.of(context)
          .showSnackBar(new SnackBar(content: Text(e.toString())));
      return;
    }
  }

  Future<void> _cancelTask(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Api.cancelTask(task.id);
      setState(() {
        isLoading = false;
      });
      await Navigator.of(context).popAndPushNamed(RouteNames.createdTasks);
      return;
    } on Exception catch (e) {
      setState(() {
        isLoading = false;
      });
      Scaffold.of(context)
          .showSnackBar(new SnackBar(content: Text(e.toString())));
      return;
    }
  }

  Future<void> _completeTask(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Api.completeTask(task.id);
      setState(() {
        isLoading = false;
      });
      await Navigator.of(context).popAndPushNamed(RouteNames.createdTasks);
    } on Exception catch (e) {
      setState(() {
        isLoading = false;
      });
      Scaffold.of(context)
          .showSnackBar(new SnackBar(content: Text(e.toString())));
      return;
    }
  }

  statusColorLabel(String status) {
    if (status == 'pending') {
      return Color(0xFF6B6B67);
    } else if (status == 'cancelled') {
      return Color(0xFFC0392B);
    } else if (status == 'assigned') {
      return Colors.green;
    }
    return Colors.blueAccent;
  }

  Widget getTaskMetaRow() {
    return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text("#${task.id}", style: new TextStyle(color: Colors.grey[600]),),
          new Container(
            padding: EdgeInsets.all(8.0),
            child: new Text(task.status.toUpperCase(), style: new TextStyle(color: Colors.white)),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: statusColorLabel(task.status))
          ),
        ]);
  }

  Widget getCreatedAtRow() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Tooltip(
          message: task.createdAt.toString(),
          child: new Text(timeago.format(task.createdAt)),
        )
      ],
    );
  }

  Widget getTask() {
    return new Row(
      children: <Widget>[
        new Expanded(
            child: new Text(task.task,
                textAlign: TextAlign.start, style: new TextStyle(fontSize: 20)))
      ],
    );
  }

  Widget getAddress() {
    return new Row(
      children: <Widget>[
        new IconButton(
            icon: Icon(
              Icons.directions,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            onPressed: () => this._launchNavigationURL()),
        new Expanded(child: GestureDetector(child: Text(task.address.getAddress(), style: TextStyle(color: Colors.grey[600])), onTap: () => this._launchNavigationURL()))
      ],
    );
  }

  Widget getContactRow() {
    if (task.status != 'assigned') {
      return Row();
    }
    String phone;
    if (isCreator) {
      phone = task.assignedTo.phone;
    } else {
      phone = task.createdBy.phone;
    }
    return new Row(
      children: <Widget>[
        new IconButton(
            icon: Icon(Icons.call, color: Colors.blueAccent, size: 20.0),
            onPressed: () => this._launchCallUrl(phone)),
        new Expanded(child: Text(phone, style: TextStyle(color: Colors.grey[600])))
      ],
    );
  }

  Widget getActionRow(BuildContext context) {
    String actionText;
    var actionPress;
    String cancelText;
    if (task.status == 'pending' && !isCreator) {
      actionText = 'Volunteer';
      actionPress = _assignTask;
    } else if (task.status == 'assigned' && isCreator) {
      actionText = 'Done';
      actionPress = _completeTask;
    }
    if (task.status != 'cancelled' && task.status != 'completed' && isCreator) {
      cancelText = 'Cancel ?';
    }
    var actionButton;
    var cancelButton;
    var children = new List<Widget>();
    if (actionText != null) {
      actionButton = ButtonTheme(
        minWidth: 200.0,
        child: RaisedButton(
        child: Text(actionText),
        color: Colors.lightBlue[700],
        textColor: Colors.white,
        onPressed: () => actionPress(context)
      )
      );
      children.add(actionButton);
    }
    if (cancelText != null) {
      cancelButton = RaisedButton(
        child: Text(cancelText),
        color: Colors.deepOrangeAccent,
        onPressed: () => _cancelTask(context),
      );
      children.add(cancelButton);
    }
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Card(
          margin: EdgeInsets.all(8),
          child: Padding(
              padding: EdgeInsets.all(4),
              child: Center(
                child: CircularProgressIndicator(),
              )
          )
      );
    }
    return Card(
        margin: EdgeInsets.all(8),
        child: Padding(
            padding: EdgeInsets.all(4),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                getTaskMetaRow(),
                SizedBox(
                  height: 8,
                ),
                getTask(),
                SizedBox(
                  height: 8,
                ),
                getAddress(),
                SizedBox(
                  height: 10,
                ),
                getActionRow(context),
                getContactRow(),
                SizedBox(
                  height: 8,
                ),
              ],
            )));
  }
}
