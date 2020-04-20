import 'package:community/enums/TaskType.dart';
import 'package:community/network/api/api.dart';
import 'package:community/network/models/task.dart';
import 'package:community/network/models/tasks.dart';
import 'package:community/widgets/taskItem.dart';
import 'package:flutter/material.dart';

class TasksList extends StatefulWidget {
  final TaskType taskType;
  final bool showContact;
  final bool isCreator;
  final int zip;

  TasksList(this.taskType, this.showContact, this.isCreator, {this.zip});

  @override
  _TasksList createState() {
    return new _TasksList(this.taskType, this.showContact, this.isCreator,
        zip: this.zip);
  }
}

class _TasksList extends State<TasksList> {
  int zip;
  List<Task> _data = [];
  TaskType taskType;
  Future<List<Task>> _future;
  bool showContact;
  bool isCreator;
  ScrollController _scrollController =
  new ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  String next;
  String requestUrl;

  _TasksList(this.taskType, this.showContact, this.isCreator, {this.zip}) {
    _scrollController.addListener(() {
      var isEnd = _scrollController.offset ==
          _scrollController.position.maxScrollExtent;
      if (isEnd && next != null) {
        setState(() {
          _future = loadData();
        });
      }
    });
    _future = loadData();
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Tasks> getTaskUrl() {
    if (taskType == TaskType.ASSIGNED) {
      return Api.getAssignedTasks(page: next);
    } else if (taskType == TaskType.CREATED) {
      return Api.getCreatedTasks(page: next);
    } else {
      return Api.getPendingTasks(zip, page: next);
    }
  }

  Future<List<Task>> loadData() async {
    Tasks tasks = await getTaskUrl();
    _data.addAll(tasks.tasks);
    next = tasks.next;
    return _data;
  }

  Widget _buildProgressIndicator(ConnectionState connectionState) {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: connectionState == ConnectionState.waiting ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget getList(BuildContext context, List<Task> data,
      ConnectionState connectionState) {
    return new ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: data.length + 1,
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (index == data.length) {
          return _buildProgressIndicator(connectionState);
        }
        final item = data.elementAt(index);
        return new TaskItem(item,
            showContact: showContact, isCreator: isCreator);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: FutureBuilder<List<Task>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Task> loaded = snapshot.data;
              if (loaded.length == 0) {
                return Center(
                  child: Text(
                    'No Tasks.',
                    style: TextStyle(fontSize: 36),
                  ),
                );
              }
              return getList(context, loaded, snapshot.connectionState);
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error}',
                  style: TextStyle(fontSize: 36),
                ),
              );
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
