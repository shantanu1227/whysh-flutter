import 'task.dart';

class Tasks {
  final List<Task> tasks;
  final String next;
  String currentUrl;

  Tasks({this.tasks, this.next});

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
        tasks: json['tasks']
            .map<Task>((_json) => Task.fromJson(_json))
            .toList(),
        next: json['next']
    );
  }
}