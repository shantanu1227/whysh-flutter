import 'task.dart';

class Tasks {
  final List<Task> tasks;

  Tasks({this.tasks});

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      tasks: json['tasks'].map<Task>((_json) => Task.fromJson(_json)).toList()
    );
  }
}