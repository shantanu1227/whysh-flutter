import 'package:community/network/models/address.dart';
import 'package:community/network/models/user.dart';

import 'category.dart';

class Task {
  final String id;
  String task;
  Address address;
  final String status;
  final DateTime createdAt;
  final User createdBy;
  final User assignedTo;
  List<Category> categories;

  Task({this.id, this.task, this.address, this.status, this.categories, this.createdAt, this.createdBy, this.assignedTo});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      task: json['task'],
      address: Address.fromJson(json['address']),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      categories: json['categories'].map<Category>((_json) => Category.fromJson(_json)).toList(),
      createdBy: User.fromJson(json['createdBy']),
      assignedTo: User.fromJson(json['assignedTo'])
    );
  }

   Map toJson() {
    return {
      'id': this.id,
      'task': this.task,
      'address': this.address.toJson(),
      'status': this.status,
      'categories': this.categories != null?this.categories.map((e) => e.toJson()).toList():null
    };
  }
}